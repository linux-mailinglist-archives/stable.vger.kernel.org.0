Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D754F32CE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344983AbiDEKk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244178AbiDEJlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC983BABBA;
        Tue,  5 Apr 2022 02:25:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97B42B81C9A;
        Tue,  5 Apr 2022 09:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76DAC385A0;
        Tue,  5 Apr 2022 09:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150725;
        bh=C/750eIEw2xnKQ7Z3W6sdUklRUAe3atwbovg2TFjKWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJU4hAxgmoS5bVBbc9scrGuLBifz2uYD6c7SUcNuxPVl1Tw7S8DTvYbi29e7StVZK
         uSqIn6MmsX7TGnkdZw+XKap4fHI1QTChxGuPhF5YAHG3QCkSJdR7vg0bcWwQ3WHwCi
         uz5ygbmwRF7VvfbYkKRKiIC54jnCMbDpAaefUw7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 157/913] crypto: rsa-pkcs1pad - only allow with rsa
Date:   Tue,  5 Apr 2022 09:20:19 +0200
Message-Id: <20220405070344.545392184@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric Biggers <ebiggers@google.com>

commit 9b30430ea356f237945e52f8a3a42158877bd5a9 upstream.

The pkcs1pad template can be instantiated with an arbitrary akcipher
algorithm, which doesn't make sense; it is specifically an RSA padding
scheme.  Make it check that the underlying algorithm really is RSA.

Fixes: 3d5b1ecdea6f ("crypto: rsa - RSA padding algorithm")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/rsa-pkcs1pad.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -621,6 +621,11 @@ static int pkcs1pad_create(struct crypto
 
 	rsa_alg = crypto_spawn_akcipher_alg(&ctx->spawn);
 
+	if (strcmp(rsa_alg->base.cra_name, "rsa") != 0) {
+		err = -EINVAL;
+		goto err_free_inst;
+	}
+
 	err = -ENAMETOOLONG;
 	hash_name = crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(hash_name)) {


