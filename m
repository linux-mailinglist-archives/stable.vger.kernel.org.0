Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C151253CF47
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245730AbiFCRx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347219AbiFCRwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA63562DA;
        Fri,  3 Jun 2022 10:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB9FC60EE9;
        Fri,  3 Jun 2022 17:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75FDC3411C;
        Fri,  3 Jun 2022 17:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278632;
        bh=sQ0GPSl5NoQwPN9POfGGNsMy+Sxch4CTIxQGvcHIVJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNVmtlsI96A2wYZ40DU+Fu95l8C8eENXStboWnRUCz6hUHomfdAO4CncSQ0WEhN7r
         nxWsKZCsFx+UikUYP4tKKnMB5krM0yM4VE0+qwsVcliIXcXlfLyUylvSBD2K4E0kLM
         YvLdPUaNX0Z7fGRycTcG8Iuv/wGEFPUgFyy4ky1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 35/66] crypto: ecrdsa - Fix incorrect use of vli_cmp
Date:   Fri,  3 Jun 2022 19:43:15 +0200
Message-Id: <20220603173821.665178127@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
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


