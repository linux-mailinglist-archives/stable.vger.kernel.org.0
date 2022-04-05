Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2132C4F2561
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiDEHte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiDEHsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1A026C;
        Tue,  5 Apr 2022 00:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B83F8B81B9C;
        Tue,  5 Apr 2022 07:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F29EC340EE;
        Tue,  5 Apr 2022 07:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144757;
        bh=C/750eIEw2xnKQ7Z3W6sdUklRUAe3atwbovg2TFjKWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNQpXYzuVRDemEUOQqomLbTiGsTbX6dia6nCxjbD9euckWwcredTRce5d8L8Gq1ww
         yC+vqByKxqg13K9n3/smWQ2OhTLZW1mPhfqh+o5Huf+eEAqesBQVYoqOeu8gmE83+I
         dBAwc3EDljW9dASPd6zOhZhNo5O88owMsvT/UZ5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.17 0160/1126] crypto: rsa-pkcs1pad - only allow with rsa
Date:   Tue,  5 Apr 2022 09:15:07 +0200
Message-Id: <20220405070412.287396986@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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


