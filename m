Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF1114BB3B
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgA1OKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgA1OKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:10:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 525F724685;
        Tue, 28 Jan 2020 14:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220601;
        bh=FjKs7kj1QyIdMdGW6JMz6tb12uo0pJoik3pgWS1XT2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPyGn1qJH7Zdm69iOGFH3P0OO7wgyr4rsiRWQhmS80VU5m5p4M6GWJT5PpQtqXWZZ
         tum0G4CWQHbn7mSanbHduZw21oyFrogLIEe5saCdssqFXIMKrxDZ5FKM2+JWIPHqnY
         X/QvdZbKQGjQEt2DTIUGsOibc0V5eKkV8rHATgms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 035/183] crypto: tgr192 - fix unaligned memory access
Date:   Tue, 28 Jan 2020 15:04:14 +0100
Message-Id: <20200128135833.524246053@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit f990f7fb58ac8ac9a43316f09a48cff1a49dda42 ]

Fix an unaligned memory access in tgr192_transform() by using the
unaligned access helpers.

Fixes: 06ace7a9bafe ("[CRYPTO] Use standard byte order macros wherever possible")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tgr192.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index 321bc6ff2a9d1..904c8444aa0a2 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -25,8 +25,9 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <asm/byteorder.h>
 #include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 #define TGR192_DIGEST_SIZE 24
 #define TGR160_DIGEST_SIZE 20
@@ -468,10 +469,9 @@ static void tgr192_transform(struct tgr192_ctx *tctx, const u8 * data)
 	u64 a, b, c, aa, bb, cc;
 	u64 x[8];
 	int i;
-	const __le64 *ptr = (const __le64 *)data;
 
 	for (i = 0; i < 8; i++)
-		x[i] = le64_to_cpu(ptr[i]);
+		x[i] = get_unaligned_le64(data + i * sizeof(__le64));
 
 	/* save */
 	a = aa = tctx->a;
-- 
2.20.1



