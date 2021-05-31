Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBE4395E98
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhEaOAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232065AbhEaN6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:58:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B32561936;
        Mon, 31 May 2021 13:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468140;
        bh=29yBi7z/CJIiEuekGlfUeyaZL3+2djxDR7+tD7HwhU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFHveuq1xI0N6yw4lwyj2SpgcV3yoF2c5lrmt8FSsg5eB4OF2tVyIWzUepE892z/S
         +7BMjZ4OKBAVneR2fA1ae3IEYk+jKXxTTb8BKTzSMtRsBkJpt2kpocpnin9bylISRY
         3LxWRbMqn8lIZQrGVterHU4LIJX2/xFYs+mqrovk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/252] Revert "crypto: cavium/nitrox - add an error message to explain the failure of pci_request_mem_regions"
Date:   Mon, 31 May 2021 15:13:17 +0200
Message-Id: <20210531130702.491494728@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
index 9d14be97e381..cee2a2713038 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -451,7 +451,6 @@ static int nitrox_probe(struct pci_dev *pdev,
 	err = pci_request_mem_regions(pdev, nitrox_driver_name);
 	if (err) {
 		pci_disable_device(pdev);
-		dev_err(&pdev->dev, "Failed to request mem regions!\n");
 		return err;
 	}
 	pci_set_master(pdev);
-- 
2.30.2



