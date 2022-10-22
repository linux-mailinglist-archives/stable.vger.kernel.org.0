Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B241F6088EF
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiJVIZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbiJVIYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260F35D894;
        Sat, 22 Oct 2022 01:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0DAA60B40;
        Sat, 22 Oct 2022 07:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4598C433C1;
        Sat, 22 Oct 2022 07:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425488;
        bh=NI1fBXPVYlDZ4B6j6GMBIhhEi5k4CLiLesxDmWTMZN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q48ZTopRp9I5z4OnjJqvBCuB+HbLzOsxSkgHiMOLlH8alBh5jnqkeKG6ef98tAJzW
         jdvViRoeCE8SzMlU/1OfDykjp6ISuaW3bSs5grrdq3YKcPhCvEehrumbbX3A9yXPRF
         JcLCNz33JGanPAZ0llXIoRHTzzzUXIs2KnTF2GCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ignat Korchagin <ignat@cloudflare.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 517/717] crypto: akcipher - default implementation for setting a private key
Date:   Sat, 22 Oct 2022 09:26:36 +0200
Message-Id: <20221022072521.161399308@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ignat Korchagin <ignat@cloudflare.com>

[ Upstream commit bc155c6c188c2f0c5749993b1405673d25a80389 ]

Changes from v1:
  * removed the default implementation from set_pub_key: it is assumed that
    an implementation must always have this callback defined as there are
    no use case for an algorithm, which doesn't need a public key

Many akcipher implementations (like ECDSA) support only signature
verifications, so they don't have all callbacks defined.

Commit 78a0324f4a53 ("crypto: akcipher - default implementations for
request callbacks") introduced default callbacks for sign/verify
operations, which just return an error code.

However, these are not enough, because before calling sign the caller would
likely call set_priv_key first on the instantiated transform (as the
in-kernel testmgr does). This function does not have a default stub, so the
kernel crashes, when trying to set a private key on an akcipher, which
doesn't support signature generation.

I've noticed this, when trying to add a KAT vector for ECDSA signature to
the testmgr.

With this patch the testmgr returns an error in dmesg (as it should)
instead of crashing the kernel NULL ptr dereference.

Fixes: 78a0324f4a53 ("crypto: akcipher - default implementations for request callbacks")
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/akcipher.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index f866085c8a4a..ab975a420e1e 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -120,6 +120,12 @@ static int akcipher_default_op(struct akcipher_request *req)
 	return -ENOSYS;
 }
 
+static int akcipher_default_set_key(struct crypto_akcipher *tfm,
+				     const void *key, unsigned int keylen)
+{
+	return -ENOSYS;
+}
+
 int crypto_register_akcipher(struct akcipher_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
@@ -132,6 +138,8 @@ int crypto_register_akcipher(struct akcipher_alg *alg)
 		alg->encrypt = akcipher_default_op;
 	if (!alg->decrypt)
 		alg->decrypt = akcipher_default_op;
+	if (!alg->set_priv_key)
+		alg->set_priv_key = akcipher_default_set_key;
 
 	akcipher_prepare_alg(alg);
 	return crypto_register_alg(base);
-- 
2.35.1



