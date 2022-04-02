Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BAF4F01A5
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiDBMvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiDBMvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:51:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4C95C354
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6FD5B8087F
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443A5C340EC;
        Sat,  2 Apr 2022 12:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648903770;
        bh=qSQPKTZEqavTKiJ2G8DARf8Ds7TeY2SfxIHyzNaDb/g=;
        h=Subject:To:Cc:From:Date:From;
        b=lCYFoaAHgNBAUrJdJmABk+vyIvHkkHxbY7A7qjJwT87T8r6pA9B5TeKOzlw4iIKWw
         MeCJ4lHR+tu1zm5cul8blVK1eBCSeFssMiS/croZ7f5n9jw6wVALhGaWppt6Qqnv5y
         UKTClxHp/QqatlLSlE8aVkh9CVkz612tEMDmaygM=
Subject: FAILED: patch "[PATCH] crypto: rsa-pkcs1pad - only allow with rsa" failed to apply to 5.4-stable tree
To:     ebiggers@google.com, herbert@gondor.apana.org.au,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:49:28 +0200
Message-ID: <164890376824719@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9b30430ea356f237945e52f8a3a42158877bd5a9 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 18 Jan 2022 16:13:02 -0800
Subject: [PATCH] crypto: rsa-pkcs1pad - only allow with rsa

The pkcs1pad template can be instantiated with an arbitrary akcipher
algorithm, which doesn't make sense; it is specifically an RSA padding
scheme.  Make it check that the underlying algorithm really is RSA.

Fixes: 3d5b1ecdea6f ("crypto: rsa - RSA padding algorithm")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 8ac3e73e8ea6..1b3545781425 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -621,6 +621,11 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	rsa_alg = crypto_spawn_akcipher_alg(&ctx->spawn);
 
+	if (strcmp(rsa_alg->base.cra_name, "rsa") != 0) {
+		err = -EINVAL;
+		goto err_free_inst;
+	}
+
 	err = -ENAMETOOLONG;
 	hash_name = crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(hash_name)) {

