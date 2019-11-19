Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2110179E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfKSGCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:02:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbfKSFlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D63222DC;
        Tue, 19 Nov 2019 05:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142103;
        bh=7o3t0HLIp/Gxq4Put8H/ayN9hsib+w2vXFjw9yIg2lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nch+jO/Y1gZGswuDo7cVn/F/B3H0+QeHpHJHsF3ib5+mSduZBH1dZrsIHP8Os9upd
         dgxcoyrEO4jZbb7JzVMShBeOokg2rd8mQb/FjZmQLQwRuzqpQ3IprWhT/aVAd0oJ6H
         lnl0Al8ZnbKNQyGkhSR1MUFAXoZ+HgDpB/EvgMS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Manszewski <c.manszewski@samsung.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 388/422] crypto: s5p-sss: Fix race in error handling
Date:   Tue, 19 Nov 2019 06:19:45 +0100
Message-Id: <20191119051424.238691009@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Manszewski <c.manszewski@samsung.com>

[ Upstream commit 5842cd44786055231b233ed5ed98cdb63ffb7db3 ]

Remove a race condition introduced by error path in functions:
s5p_aes_interrupt and s5p_aes_crypt_start. Setting the busy field of
struct s5p_aes_dev to false made it possible for s5p_tasklet_cb to
change the req field, before s5p_aes_complete was called.

Change the first parameter of s5p_aes_complete to struct
ablkcipher_request. Before spin_unlock, make a copy of the currently
handled request, to ensure s5p_aes_complete function call with the
correct request.

Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
Acked-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/s5p-sss.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index faa282074e5aa..9021ad9df0c45 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -475,9 +475,9 @@ static void s5p_sg_done(struct s5p_aes_dev *dev)
 }
 
 /* Calls the completion. Cannot be called with dev->lock hold. */
-static void s5p_aes_complete(struct s5p_aes_dev *dev, int err)
+static void s5p_aes_complete(struct ablkcipher_request *req, int err)
 {
-	dev->req->base.complete(&dev->req->base, err);
+	req->base.complete(&req->base, err);
 }
 
 static void s5p_unset_outdata(struct s5p_aes_dev *dev)
@@ -655,6 +655,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
 	struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
+	struct ablkcipher_request *req;
 	int err_dma_tx = 0;
 	int err_dma_rx = 0;
 	int err_dma_hx = 0;
@@ -727,7 +728,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 
 		spin_unlock_irqrestore(&dev->lock, flags);
 
-		s5p_aes_complete(dev, 0);
+		s5p_aes_complete(dev->req, 0);
 		/* Device is still busy */
 		tasklet_schedule(&dev->tasklet);
 	} else {
@@ -752,11 +753,12 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 error:
 	s5p_sg_done(dev);
 	dev->busy = false;
+	req = dev->req;
 	if (err_dma_hx == 1)
 		s5p_set_dma_hashdata(dev, dev->hash_sg_iter);
 
 	spin_unlock_irqrestore(&dev->lock, flags);
-	s5p_aes_complete(dev, err);
+	s5p_aes_complete(req, err);
 
 hash_irq_end:
 	/*
@@ -1983,7 +1985,7 @@ indata_error:
 	s5p_sg_done(dev);
 	dev->busy = false;
 	spin_unlock_irqrestore(&dev->lock, flags);
-	s5p_aes_complete(dev, err);
+	s5p_aes_complete(req, err);
 }
 
 static void s5p_tasklet_cb(unsigned long data)
-- 
2.20.1



