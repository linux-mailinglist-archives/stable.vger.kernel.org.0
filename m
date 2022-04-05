Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641D44F416B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383106AbiDEMYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355908AbiDEKWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB15BA9957;
        Tue,  5 Apr 2022 03:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AA4E61500;
        Tue,  5 Apr 2022 10:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5781AC385A2;
        Tue,  5 Apr 2022 10:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153123;
        bh=C/750eIEw2xnKQ7Z3W6sdUklRUAe3atwbovg2TFjKWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1gqnRvMswRkH8MRdOj8yW2FjDZHeIj2W5Oa9ORu+l0v7U06YDP3T0QqtDK6FFpVf
         C+KUBjpzPafGcwNtQFb2Dcr9RwcQLT5rWIb6AT1N3XoOvfjXj9SVHs9cTQ5zKYOe0m
         5pLBjTrRTho2C5nIAthUmUk1+q2QmE9mdWlqXQWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 109/599] crypto: rsa-pkcs1pad - only allow with rsa
Date:   Tue,  5 Apr 2022 09:26:43 +0200
Message-Id: <20220405070302.078174380@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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


