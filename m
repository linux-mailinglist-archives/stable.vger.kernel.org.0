Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF88748E603
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240231AbiANIWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240269AbiANIV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:21:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11C5C0617A7;
        Fri, 14 Jan 2022 00:21:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61BB361E37;
        Fri, 14 Jan 2022 08:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971C7C36AE9;
        Fri, 14 Jan 2022 08:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642148471;
        bh=42/E2d5qp+aGEb3LON47WXAM0iCKqIGuFaGn17hu4ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwEY2mD2KTqbOdCNrAF+34oRuR7ZeEHeS/ssxh6swbbl2GJscXxJezaxAQOpJbh9J
         3x4uIyVb4YHrVnFeh8wkaKu5qE5MyUq0m90yTEp8pKnfr7d7kv+IV4ZwpLD8ZHnuPS
         v+xhwlpjy/gshT8EQK6DqXqYmfFP5JS4dW+CP7da/TxARNnSU7t/dZoMyf8gshjlU2
         wo+y2dnnQIbpTgv9TqgqAjxdgo+C55QOklM48homFpxz9JdKq7OuHK6QJRQEARV0kj
         zwtlTnolTgK85pyq+x8MxKDvDr0ab8GQ1YZv2lw00hLX7iP5q82CtfMDbcLUzzBh2i
         6PMtXfp96PW6w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Denis Kenzior <denkenz@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] crypto: rsa-pkcs1pad - fix buffer overread in pkcs1pad_verify_complete()
Date:   Fri, 14 Jan 2022 00:19:38 -0800
Message-Id: <20220114081939.218416-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081939.218416-1-ebiggers@kernel.org>
References: <20220114081939.218416-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Before checking whether the expected digest_info is present, we need to
check that there are enough bytes remaining.

Fixes: a49de377e051 ("crypto: Add hash param to pkcs1pad")
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/rsa-pkcs1pad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 7b223adebabf..6cd24b4b9b9e 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -476,6 +476,8 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 	pos++;
 
 	if (digest_info) {
+		if (digest_info->size > dst_len - pos)
+			goto done;
 		if (crypto_memneq(out_buf + pos, digest_info->data,
 				  digest_info->size))
 			goto done;
-- 
2.34.1

