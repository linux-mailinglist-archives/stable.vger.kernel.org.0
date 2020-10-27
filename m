Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23E529C727
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827805AbgJ0S2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368177AbgJ0N5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:57:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C80F21D42;
        Tue, 27 Oct 2020 13:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807040;
        bh=9y+m+r1F1TV5hF00OHKbbN9tY2ZlfbSVeuXL32U4pI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECAJkZHPe8io6KgQSZ4GqwpNABEiGmAbAEREi9JC8Zvj5C78p3GoQ67G/qWKA5fTm
         onzZoRXvm5EUcaCEdGfNqHnNIcr/Xc47wCfklheqAp2RJJIrJ/6J8QSf+W6zUNgBht
         ZInm1WWxAH9l2SpijFAc/5M9sXTsiK+3YOSzhFd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 020/112] crypto: ixp4xx - Fix the size used in a dma_free_coherent() call
Date:   Tue, 27 Oct 2020 14:48:50 +0100
Message-Id: <20201027134901.529686500@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f7ade9aaf66bd5599690acf0597df2c0f6cd825a ]

Update the size used in 'dma_free_coherent()' in order to match the one
used in the corresponding 'dma_alloc_coherent()', in 'setup_crypt_desc()'.

Fixes: 81bef0150074 ("crypto: ixp4xx - Hardware crypto support for IXP4xx CPUs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ixp4xx_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 8f27903532812..13657105cfb93 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -533,7 +533,7 @@ static void release_ixp_crypto(struct device *dev)
 
 	if (crypt_virt) {
 		dma_free_coherent(dev,
-			NPE_QLEN_TOTAL * sizeof( struct crypt_ctl),
+			NPE_QLEN * sizeof(struct crypt_ctl),
 			crypt_virt, crypt_phys);
 	}
 	return;
-- 
2.25.1



