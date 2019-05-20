Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088992362B
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389754AbfETMno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389741AbfETM2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB4BA20645;
        Mon, 20 May 2019 12:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355325;
        bh=Vc76SIEwx46ODrXQqltdqyN2/mHnKSGbQiibyzx/1hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3fL8GWx5H2E4fXJg3vZp359nb0eI5emHn+kqjplqzM/GTfYpaMckmXA6Pl+TPpx6
         oBvKj/PkRcW4OkY+ZYpHidy4Nsmf99tghxty7lPg4VjJJuhIiNO6n2a9yLd+Edrm1r
         HhBsRxGBZDRHdEPFnrMaX3ptgIWKFiet+Q2YJlkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.0 059/123] crypto: ccree - fix mem leak on error path
Date:   Mon, 20 May 2019 14:13:59 +0200
Message-Id: <20190520115248.697804651@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit d574b707c873d6ef1a2a155f8cfcfecd821e9a2e upstream.

Fix a memory leak on the error path of IV generation code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_ivgen.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/crypto/ccree/cc_ivgen.c
+++ b/drivers/crypto/ccree/cc_ivgen.c
@@ -154,9 +154,6 @@ void cc_ivgen_fini(struct cc_drvdata *dr
 	}
 
 	ivgen_ctx->pool = NULL_SRAM_ADDR;
-
-	/* release "this" context */
-	kfree(ivgen_ctx);
 }
 
 /*!
@@ -174,10 +171,12 @@ int cc_ivgen_init(struct cc_drvdata *drv
 	int rc;
 
 	/* Allocate "this" context */
-	ivgen_ctx = kzalloc(sizeof(*ivgen_ctx), GFP_KERNEL);
+	ivgen_ctx = devm_kzalloc(device, sizeof(*ivgen_ctx), GFP_KERNEL);
 	if (!ivgen_ctx)
 		return -ENOMEM;
 
+	drvdata->ivgen_handle = ivgen_ctx;
+
 	/* Allocate pool's header for initial enc. key/IV */
 	ivgen_ctx->pool_meta = dma_alloc_coherent(device, CC_IVPOOL_META_SIZE,
 						  &ivgen_ctx->pool_meta_dma,
@@ -196,8 +195,6 @@ int cc_ivgen_init(struct cc_drvdata *drv
 		goto out;
 	}
 
-	drvdata->ivgen_handle = ivgen_ctx;
-
 	return cc_init_iv_sram(drvdata);
 
 out:


