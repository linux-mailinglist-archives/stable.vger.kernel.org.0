Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DC813FE3B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404349AbgAPXd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:33:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391515AbgAPXdZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:33:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F11582072E;
        Thu, 16 Jan 2020 23:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217605;
        bh=k7jLbKDGZ4iRjIZ4qzQ6bAEV+npIVuYrJOHBHWLt2XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCj7lwHwEscI7rhL8hRRoqUmD1hyGiSVxKW4dFplHlIYFE5pmjp2pq8kuqGD9X4ID
         P0rWajqH+1i/U27UEMEPKv3xgRLP1Fd2yLd67gpHwhqbIpzwS+NpEnxz3Rin08t8l4
         L2S9a9usrb0sjGUZfk0AW8Owre71GvR5aabBFPew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 67/71] dmaengine: k3dma: Avoid null pointer traversal
Date:   Fri, 17 Jan 2020 00:19:05 +0100
Message-Id: <20200116231718.663178995@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 219ae3b545db..803045c92f3b 100644
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



