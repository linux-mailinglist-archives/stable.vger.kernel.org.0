Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958573961F0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhEaOss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233758AbhEaOqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:46:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDDFC61C8A;
        Mon, 31 May 2021 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469347;
        bh=HtUfS1IYrpmkkbbRs5ghCDWJ7J7xHW4JZRf67JBRtoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FiFpNEEWg5Tw4Mozohrzz/gA+KHWmmL7ez1kKSDE6wqH3M9PbuRFtpbtmLSAab8g5
         z65UeRObdSfEVxgl4fktwy+RV+RAtcAi60NUiU/DY4+HI8uDG+RF2veg1eYnBu2rwr
         RNRIydhCpvQecB3X2bTcmR/+0RYIiRbJOMp4wp4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 162/296] Revert "crypto: cavium/nitrox - add an error message to explain the failure of pci_request_mem_regions"
Date:   Mon, 31 May 2021 15:13:37 +0200
Message-Id: <20210531130709.304966184@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 6a3239a738d86c5e9b5aad17fefe2c2bfd6ced83 ]

This reverts commit 9fcddaf2e28d779cb946d23838ba6d50f299aa80 as it was
submitted under a fake name and we can not knowingly accept anonymous
contributions to the repository.

This commit was part of a submission "test" to the Linux kernel
community by some "researchers" at umn.edu.  As outlined at:
	https://www-users.cs.umn.edu/%7Ekjlu/papers/full-disclosure.pdf
it was done so as an attempt to submit a known-buggy patch to see if it
could get by our review.  However, the submission turned out to actually
be correct, and not have a bug in it as the author did not understand
how the PCI driver model works at all, and so the submission was
accepted.

As this change is of useless consequence, there is no loss of
functionality in reverting it.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Email: Herbert Xu <herbert@gondor.apana.org.au>
Link: https://lore.kernel.org/r/YIkTi9a3nnL50wMq@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/nitrox/nitrox_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index facc8e6bc580..d385daf2c71c 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -442,7 +442,6 @@ static int nitrox_probe(struct pci_dev *pdev,
 	err = pci_request_mem_regions(pdev, nitrox_driver_name);
 	if (err) {
 		pci_disable_device(pdev);
-		dev_err(&pdev->dev, "Failed to request mem regions!\n");
 		return err;
 	}
 	pci_set_master(pdev);
-- 
2.30.2



