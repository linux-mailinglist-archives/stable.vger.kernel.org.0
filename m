Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B74137984
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgAJWF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727439AbgAJWF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:05:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D576E222D9;
        Fri, 10 Jan 2020 22:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693925;
        bh=uPUy8SKeR3KTC7Y2sKB4khJaHsZIJ/WlclQs0lehUJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pp8C6Ix6Ry4xcpsCEMAEtyUVh/aB/0pksRmk2xS80xcM/8B9fW6B/qEKOZvHuCkLr
         4MlUtV6ge0n8pOy5TEc8l2cIM/93EyLbvHd2YKyJeruFmi+MBdEPerWT50FJ4jriLX
         uRF8dmOtMg71kulaV06015JaUVCNPbyLLjRR0tU8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Stultz <john.stultz@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/26] dmaengine: k3dma: Avoid null pointer traversal
Date:   Fri, 10 Jan 2020 17:05:02 -0500
Message-Id: <20200110220519.28250-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220519.28250-1-sashal@kernel.org>
References: <20200110220519.28250-1-sashal@kernel.org>
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
index 4b36c8810517..d05471653224 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -229,9 +229,11 @@ static irqreturn_t k3_dma_int_handler(int irq, void *dev_id)
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
@@ -271,6 +273,10 @@ static int k3_dma_start_txd(struct k3_dma_chan *c)
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

