Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1679511B5EA
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfLKPPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:15:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729955AbfLKPPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DAB24654;
        Wed, 11 Dec 2019 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077300;
        bh=bEPZPVL0vaFMoN9AWWf5BU7pfcm6B55ATdt3z0aCsvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQApkc+Sb+2lnhOSH4dwYhmmmW4qG8nXgIsZfH+1pmxVrtQuUIaXjtB+1KcJ62Y12
         Nw1JpemlS0qObvBxUa4y5gbrNc0hHBeFLjYibZm5kVZXmgoB3dYzzG/4Q3n2h/bcvD
         82ZkPFxsvNuPNpGJA7a0filYaPddI/KzMWwIMvgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 085/105] crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr
Date:   Wed, 11 Dec 2019 16:06:14 +0100
Message-Id: <20191211150258.847739471@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit 746c908c4d72e49068ab216c3926d2720d71a90d upstream.

This patch fixes a crash that can happen during probe
when the available dma memory is not enough (this can
happen if the crypto4xx is built as a module).

The descriptor window mapping would end up being free'd
twice, once in crypto4xx_build_pdr() and the second time
in crypto4xx_destroy_sdr().

Fixes: 5d59ad6eea82 ("crypto: crypto4xx - fix crypto4xx_build_pdr, crypto4xx_build_sdr leak")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/amcc/crypto4xx_core.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -365,12 +365,8 @@ static u32 crypto4xx_build_sdr(struct cr
 		dma_alloc_coherent(dev->core_dev->device,
 			PPC4XX_SD_BUFFER_SIZE * PPC4XX_NUM_SD,
 			&dev->scatter_buffer_pa, GFP_ATOMIC);
-	if (!dev->scatter_buffer_va) {
-		dma_free_coherent(dev->core_dev->device,
-				  sizeof(struct ce_sd) * PPC4XX_NUM_SD,
-				  dev->sdr, dev->sdr_pa);
+	if (!dev->scatter_buffer_va)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < PPC4XX_NUM_SD; i++) {
 		dev->sdr[i].ptr = dev->scatter_buffer_pa +


