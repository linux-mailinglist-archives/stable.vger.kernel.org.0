Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC5C4F2B75
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238049AbiDEJEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243447AbiDEIu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:50:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E6E13F68;
        Tue,  5 Apr 2022 01:38:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ECCAB81B18;
        Tue,  5 Apr 2022 08:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CB2C385A1;
        Tue,  5 Apr 2022 08:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147906;
        bh=C/750eIEw2xnKQ7Z3W6sdUklRUAe3atwbovg2TFjKWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWOvQmlTLKveOhPvrQ5jmH2tlg6mBdm0tjVCgQ4oELdVymYwpIxsaD5/tu4yT5zz8
         aKaLmNSkjdXil5TG8V65i6WseDiT7j396WSpAAGv+hhO9GGQ/3QCxrOmbcRJQy7TbQ
         VElP1CTz9k+6u9T7yJdZK6FCcT01AHCGZ021knUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.16 0165/1017] crypto: rsa-pkcs1pad - only allow with rsa
Date:   Tue,  5 Apr 2022 09:17:58 +0200
Message-Id: <20220405070359.119948282@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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


