Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B646137934
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgAJWGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:06:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgAJWGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:06:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E8CC20838;
        Fri, 10 Jan 2020 22:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693960;
        bh=ok15enOupA5W/wMO7U7KSrXVmeBc2HMpZ4pSkfou/bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWHliHLv3aiGkx43/6SDnEY4UstoanJ4twy/Mg+qtlN5OQfxRNggQrnswgP+Ut+1w
         d7Yxz0czpKG4HMiP6Tk3Mkk4hUOokFDL7cojKNwh5rOS+kIWffF//bz4FqP/NSPYLs
         poluyx3k4SPl5uycli6g+zK+iGL9srvPHHipEFnM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Stultz <john.stultz@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/11] dmaengine: k3dma: Avoid null pointer traversal
Date:   Fri, 10 Jan 2020 17:05:48 -0500
Message-Id: <20200110220556.28505-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220556.28505-1-sashal@kernel.org>
References: <20200110220556.28505-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

[ Upstream commit 2f42e05b942fe2fbfb9bbc6e34e1dd8c3ce4f3a4 ]

In some cases we seem to submit two transactions in a row, which
causes us to lose track of the first. If we then cancel the
request, we may still get an interrupt, which traverses a null
ds_run value.

So try to avoid starting a new transaction if the ds_run value
is set.

While this patch avoids the null pointer crash, I've had some
reports of the k3dma driver still getting confused, which
suggests the ds_run/ds_done value handling still isn't quite
right. However, I've not run into an issue recently with it
so I think this patch is worth pushing upstream to avoid the
crash.

Signed-off-by: John Stultz <john.stultz@linaro.org>
[add ss tag]
Link: https://lore.kernel.org/r/20191218190906.6641-1-john.stultz@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/k3dma.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index 6bfa217ed6d0..ba3c3791f9dc 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -222,9 +222,11 @@ static irqreturn_t k3_dma_int_handler(int irq, void *dev_id)
 			c = p->vchan;
 			if (c && (tc1 & BIT(i))) {
 				spin_lock_irqsave(&c->vc.lock, flags);
-				vchan_cookie_complete(&p->ds_run->vd);
-				p->ds_done = p->ds_run;
-				p->ds_run = NULL;
+				if (p->ds_run != NULL) {
+					vchan_cookie_complete(&p->ds_run->vd);
+					p->ds_done = p->ds_run;
+					p->ds_run = NULL;
+				}
 				spin_unlock_irqrestore(&c->vc.lock, flags);
 			}
 			if (c && (tc2 & BIT(i))) {
@@ -264,6 +266,10 @@ static int k3_dma_start_txd(struct k3_dma_chan *c)
 	if (BIT(c->phy->idx) & k3_dma_get_chan_stat(d))
 		return -EAGAIN;
 
+	/* Avoid losing track of  ds_run if a transaction is in flight */
+	if (c->phy->ds_run)
+		return -EAGAIN;
+
 	if (vd) {
 		struct k3_dma_desc_sw *ds =
 			container_of(vd, struct k3_dma_desc_sw, vd);
-- 
2.20.1

