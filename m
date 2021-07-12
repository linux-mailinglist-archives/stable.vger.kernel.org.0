Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4593C526E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345759AbhGLHqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345722AbhGLHoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22B9E611F1;
        Mon, 12 Jul 2021 07:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075654;
        bh=13W/oWj5gz5cu8Ueim6ZFf/pSWtuKM8PboyUgGy7j0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qudk8DQRuQeNFWx7OC+Wjf6uvO5tgUZ1lUDv11OpvLCdmsgS6UQDvfZQkhWmGyExp
         3u103InpPG4j2pJWosCdBbYdcjr6fQJv6KMqHVf/JZG3/xPe+qQLLBfoMBLGyxEI+D
         yQmT+IGzlNXqppidklWk46BVWa4hGlS78jFAoezo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 290/800] crypto: ccp - Fix a resource leak in an error handling path
Date:   Mon, 12 Jul 2021 08:05:13 +0200
Message-Id: <20210712060955.797764530@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index f468594ef8af..6fb6ba35f89d 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -222,7 +222,7 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (ret) {
 			dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n",
 				ret);
-			goto e_err;
+			goto free_irqs;
 		}
 	}
 
@@ -230,10 +230,12 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
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



