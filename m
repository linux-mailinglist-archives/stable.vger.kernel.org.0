Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6578D3C4542
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbhGLGYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234207AbhGLGX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6F0A61178;
        Mon, 12 Jul 2021 06:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070813;
        bh=dzBRkxMhPCWStOI860unHBjMU1EL1uyOTDxzHOD9dEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1AtoBxxffAqpnLYyBS2myYRoMeBFHyrwh5DFGBgQeJ2OY67GIrIjkp9kY+LTYFRA
         gXOSKm9PmonoM5qT/4Q5RnGDGz0MRlrTbcNBIWemiQgIVepjJcR78xsIbdPxKF5w0w
         0tvWUnDyVsvBBfXFUPCC4NyX80amlBOH8QbnX9iU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/348] crypto: ccp - Fix a resource leak in an error handling path
Date:   Mon, 12 Jul 2021 08:08:54 +0200
Message-Id: <20210712060721.015174589@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a6f8e68e238a15bb15f1726b35c695136c64eaba ]

If an error occurs after calling 'sp_get_irqs()', 'sp_free_irqs()' must be
called as already done in the error handling path.

Fixes: f4d18d656f88 ("crypto: ccp - Abstract interrupt registeration")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: John Allen <john.allen@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sp-pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index b29d2e663e10..f607b19ff4d2 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -213,7 +213,7 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (ret) {
 			dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n",
 				ret);
-			goto e_err;
+			goto free_irqs;
 		}
 	}
 
@@ -221,10 +221,12 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ret = sp_init(sp);
 	if (ret)
-		goto e_err;
+		goto free_irqs;
 
 	return 0;
 
+free_irqs:
+	sp_free_irqs(sp);
 e_err:
 	dev_notice(dev, "initialization failed\n");
 	return ret;
-- 
2.30.2



