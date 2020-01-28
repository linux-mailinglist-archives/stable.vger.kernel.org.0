Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FE614BA94
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgA1OQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:16:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbgA1OQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:16:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CB402468D;
        Tue, 28 Jan 2020 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220987;
        bh=FjKs7kj1QyIdMdGW6JMz6tb12uo0pJoik3pgWS1XT2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0x439QPpLzilx/dUO5gxIGSxihv5C8MmqXrQJj96RViYamCE30xLg8BsF5E2qBPO
         mDaNUqWOJzYyARjtC21RJKKhIX1o5MB3V4/j2WYGL8yyeYnarwnXgZcTa7cAD+Lzaa
         kADePgO7qb8k/uCEpcU4h3Brw0E7/a/e9JYKWjuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 044/271] crypto: tgr192 - fix unaligned memory access
Date:   Tue, 28 Jan 2020 15:03:13 +0100
Message-Id: <20200128135855.930739000@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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



