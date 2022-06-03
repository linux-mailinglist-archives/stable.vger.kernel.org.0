Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE20553CFDB
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345895AbiFCR5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241008AbiFCR4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:56:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FB456766;
        Fri,  3 Jun 2022 10:53:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89DF561255;
        Fri,  3 Jun 2022 17:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896B8C36AE2;
        Fri,  3 Jun 2022 17:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278832;
        bh=sQ0GPSl5NoQwPN9POfGGNsMy+Sxch4CTIxQGvcHIVJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R//gbOLlwURquQb98PwvE3qBJVfq4anxUcQo9JWBsNM3nFRs8m05VM/OZi+g/KuK1
         gnm/aHK9Sr7mffDj3hYrol+b8uvrC81mn6S9J5p8L4lflsL+/WGlesCbACP3Z78b6X
         PZY787AvgBNSAWn5YR2KyBHidAkAXiVF0S2KvqNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.17 41/75] crypto: ecrdsa - Fix incorrect use of vli_cmp
Date:   Fri,  3 Jun 2022 19:43:25 +0200
Message-Id: <20220603173822.911441981@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Chikunov <vt@altlinux.org>

commit 7cc7ab73f83ee6d50dc9536bc3355495d8600fad upstream.

Correctly compare values that shall be greater-or-equal and not just
greater.

Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/ecrdsa.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/crypto/ecrdsa.c
+++ b/crypto/ecrdsa.c
@@ -113,15 +113,15 @@ static int ecrdsa_verify(struct akcipher
 
 	/* Step 1: verify that 0 < r < q, 0 < s < q */
 	if (vli_is_zero(r, ndigits) ||
-	    vli_cmp(r, ctx->curve->n, ndigits) == 1 ||
+	    vli_cmp(r, ctx->curve->n, ndigits) >= 0 ||
 	    vli_is_zero(s, ndigits) ||
-	    vli_cmp(s, ctx->curve->n, ndigits) == 1)
+	    vli_cmp(s, ctx->curve->n, ndigits) >= 0)
 		return -EKEYREJECTED;
 
 	/* Step 2: calculate hash (h) of the message (passed as input) */
 	/* Step 3: calculate e = h \mod q */
 	vli_from_le64(e, digest, ndigits);
-	if (vli_cmp(e, ctx->curve->n, ndigits) == 1)
+	if (vli_cmp(e, ctx->curve->n, ndigits) >= 0)
 		vli_sub(e, e, ctx->curve->n, ndigits);
 	if (vli_is_zero(e, ndigits))
 		e[0] = 1;
@@ -137,7 +137,7 @@ static int ecrdsa_verify(struct akcipher
 	/* Step 6: calculate point C = z_1P + z_2Q, and R = x_c \mod q */
 	ecc_point_mult_shamir(&cc, z1, &ctx->curve->g, z2, &ctx->pub_key,
 			      ctx->curve);
-	if (vli_cmp(cc.x, ctx->curve->n, ndigits) == 1)
+	if (vli_cmp(cc.x, ctx->curve->n, ndigits) >= 0)
 		vli_sub(cc.x, cc.x, ctx->curve->n, ndigits);
 
 	/* Step 7: if R == r signature is valid */


