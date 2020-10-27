Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344CF29B059
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754586AbgJ0OS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901094AbgJ0OS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:18:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A583206F7;
        Tue, 27 Oct 2020 14:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808307;
        bh=FNJyOdQCwhfK32OtsZAWoC9iVmU4EVc/qERQdNz4HDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtcURX7HbrkUvvqFmZ37Ii+r/h60EgD23jMWnfqVRYDoVFZHTSkS63QntkV1tet2/
         aTILwW3yWWgbr1DrAVbe6ASpok7Y9AkfRlFD9efHj3Uwl5HW/BgStdirEuKdBM/x5k
         aGmb2Mhw521ct7Kip5bdXxtBDEX9uPsMPXh4WPx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/264] crypto: ixp4xx - Fix the size used in a dma_free_coherent() call
Date:   Tue, 27 Oct 2020 14:51:39 +0100
Message-Id: <20201027135432.597930202@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index 27f7dad2d45d9..9b7b8558db31d 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -530,7 +530,7 @@ static void release_ixp_crypto(struct device *dev)
 
 	if (crypt_virt) {
 		dma_free_coherent(dev,
-			NPE_QLEN_TOTAL * sizeof( struct crypt_ctl),
+			NPE_QLEN * sizeof(struct crypt_ctl),
 			crypt_virt, crypt_phys);
 	}
 }
-- 
2.25.1



