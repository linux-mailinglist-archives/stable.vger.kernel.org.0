Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BDD3C5270
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346163AbhGLHqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349619AbhGLHoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83EF1613C3;
        Mon, 12 Jul 2021 07:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075659;
        bh=4ox1c5vajLLweD9uJNnhhrAuT1dDz2Tqin7ORoQ4kPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9K6nbw/9HNFmZWk8ha3pKF8JNSFSuS1Imb+olwwLSgYUsBPX7LWf8mnweTdeFn/B
         SKiWpv3U7YVnGQB+XUilNxXvLXfk7l6st5vxjI6OL8tjPjXZaquTLoxGQzL352e8/e
         xIU6Wp3jjB6v0kgKYOZlb2FAfORjqQlEB9MSea0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Tiangen <tongtiangen@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 309/800] crypto: nitrox - fix unchecked variable in nitrox_register_interrupts
Date:   Mon, 12 Jul 2021 08:05:32 +0200
Message-Id: <20210712060958.359716520@linuxfoundation.org>
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

From: Tong Tiangen <tongtiangen@huawei.com>

[ Upstream commit 57c126661f50b884d3812e7db6e00f2e778eccfb ]

Function nitrox_register_interrupts leaves variable 'nr_vecs' unchecked, which
would be use as kcalloc parameter later.

Fixes: 5155e118dda9 ("crypto: cavium/nitrox - use pci_alloc_irq_vectors() while enabling MSI-X.")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/nitrox/nitrox_isr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
index c288c4b51783..f19e520da6d0 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -307,6 +307,10 @@ int nitrox_register_interrupts(struct nitrox_device *ndev)
 	 * Entry 192: NPS_CORE_INT_ACTIVE
 	 */
 	nr_vecs = pci_msix_vec_count(pdev);
+	if (nr_vecs < 0) {
+		dev_err(DEV(ndev), "Error in getting vec count %d\n", nr_vecs);
+		return nr_vecs;
+	}
 
 	/* Enable MSI-X */
 	ret = pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_MSIX);
-- 
2.30.2



