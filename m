Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA20F4931AE
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350362AbiASAPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:15:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47634 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348506AbiASAO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:14:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0A87B8185B;
        Wed, 19 Jan 2022 00:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EED8C340E5;
        Wed, 19 Jan 2022 00:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642551296;
        bh=xVBGpsBT8Iho12AXNuLcSsyn7RKWZaSgxxscCl3hAIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caa4kBE21AwZ7Kj2+eCtEsc6AICOVicbyDBBx09rjT1GdEbrgrl909JfpdZv9ZHUg
         jYcUqC3UYgKs6RyMVI4s54CUf34FQCdffkuonH0kEnDrKkyfamNtZSGU1r9hGC7iQ+
         1ylMolIZbgz2EQ7JRrTE0QkADA3ClR8xSHrsIY3flJpKYwVeaj9rMUyojd4GjuCoKk
         WZ818qprZPa4DukBg17Hn9bWL/t7xNU+YeYj4q5mZ/DAB4/sFKw7YfI2AihmrLgjpv
         7UwHVLonBJ3hjdvulJeYkTaZiDtlPVRmP/yVXxWCl997tatdgnlgCglffvOKur2jV5
         HHmoP5UyxVO2A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH v2 4/5] crypto: rsa-pkcs1pad - fix buffer overread in pkcs1pad_verify_complete()
Date:   Tue, 18 Jan 2022 16:13:05 -0800
Message-Id: <20220119001306.85355-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119001306.85355-1-ebiggers@kernel.org>
References: <20220119001306.85355-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Before checking whether the expected digest_info is present, we need to
check that there are enough bytes remaining.

Fixes: a49de377e051 ("crypto: Add hash param to pkcs1pad")
Cc: <stable@vger.kernel.org> # v4.6+
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/rsa-pkcs1pad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 6b556ddeb3a00..9d804831c8b3f 100644
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

