Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FCF3C4905
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbhGLGlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238448AbhGLGkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EECE6113B;
        Mon, 12 Jul 2021 06:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071839;
        bh=2CQbUng5Nsn7B0NMNpN5W0OkZdM60MMhMInGhtGeFOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJ9BgEmX3zU3HfA+IBq2jKqkKwdE/EP0nSY5knEHekPPmSIII0vCDxs2eGT1JkRXd
         BzBptBA1hpTaDcFpRdGTsvGwVKn1+p4t60andswDgvAqJGBYAd19a0qYkw4ylsmxkR
         KkeoVKAao3CadDgetU3TTn09ZEkc3YuYEu34uhRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Tiangen <tongtiangen@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/593] crypto: nitrox - fix unchecked variable in nitrox_register_interrupts
Date:   Mon, 12 Jul 2021 08:06:40 +0200
Message-Id: <20210712060909.300892982@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 3dec570a190a..10e3408bf704 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -306,6 +306,10 @@ int nitrox_register_interrupts(struct nitrox_device *ndev)
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



