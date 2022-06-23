Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B1A55811A
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbiFWQ4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiFWQte (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:49:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A74F4D9C5;
        Thu, 23 Jun 2022 09:47:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF16DB8248A;
        Thu, 23 Jun 2022 16:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AEBC3411B;
        Thu, 23 Jun 2022 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002864;
        bh=1Q7nYL+PFimdCa78FDSk0iwaElT93gMiVpni45/1IVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5ZfND/+i3+Qi3kA6Ppg3C7xMSXasjh3AFwC7KyJ9nhmv+h7JZ+bbnvjLUwiBRDbI
         ctMZfFqcjVPSoOI51Av/NEIPASuydHcM1CLqk6WqC00smoZyLtCYTo0l37rnYFaIN3
         5X27uQLdtHNVVTdu/eEsra4Q0aIQ+aOkgYAUTupU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 052/264] lib/crypto: sha1: re-roll loops to reduce code size
Date:   Thu, 23 Jun 2022 18:40:45 +0200
Message-Id: <20220623164345.543250515@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 9a1536b093bb5bf60689021275fd24d513bb8db0 upstream.

With SHA-1 no longer being used for anything performance oriented, and
also soon to be phased out entirely, we can make up for the space added
by unrolled BLAKE2s by simply re-rolling SHA-1. Since SHA-1 is so much
more complex, re-rolling it more or less takes care of the code size
added by BLAKE2s. And eventually, hopefully we'll see SHA-1 removed
entirely from most small kernel builds.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/sha1.c |   95 ++++++++-----------------------------------------------------
 1 file changed, 14 insertions(+), 81 deletions(-)

--- a/lib/sha1.c
+++ b/lib/sha1.c
@@ -9,6 +9,7 @@
 #include <linux/export.h>
 #include <linux/bitops.h>
 #include <linux/cryptohash.h>
+#include <linux/string.h>
 #include <asm/unaligned.h>
 
 /*
@@ -54,7 +55,8 @@
 #define SHA_ROUND(t, input, fn, constant, A, B, C, D, E) do { \
 	__u32 TEMP = input(t); setW(t, TEMP); \
 	E += TEMP + rol32(A,5) + (fn) + (constant); \
-	B = ror32(B, 2); } while (0)
+	B = ror32(B, 2); \
+	TEMP = E; E = D; D = C; C = B; B = A; A = TEMP; } while (0)
 
 #define T_0_15(t, A, B, C, D, E)  SHA_ROUND(t, SHA_SRC, (((C^D)&B)^D) , 0x5a827999, A, B, C, D, E )
 #define T_16_19(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (((C^D)&B)^D) , 0x5a827999, A, B, C, D, E )
@@ -81,6 +83,7 @@
 void sha_transform(__u32 *digest, const char *data, __u32 *array)
 {
 	__u32 A, B, C, D, E;
+	unsigned int i = 0;
 
 	A = digest[0];
 	B = digest[1];
@@ -89,94 +92,24 @@ void sha_transform(__u32 *digest, const
 	E = digest[4];
 
 	/* Round 1 - iterations 0-16 take their input from 'data' */
-	T_0_15( 0, A, B, C, D, E);
-	T_0_15( 1, E, A, B, C, D);
-	T_0_15( 2, D, E, A, B, C);
-	T_0_15( 3, C, D, E, A, B);
-	T_0_15( 4, B, C, D, E, A);
-	T_0_15( 5, A, B, C, D, E);
-	T_0_15( 6, E, A, B, C, D);
-	T_0_15( 7, D, E, A, B, C);
-	T_0_15( 8, C, D, E, A, B);
-	T_0_15( 9, B, C, D, E, A);
-	T_0_15(10, A, B, C, D, E);
-	T_0_15(11, E, A, B, C, D);
-	T_0_15(12, D, E, A, B, C);
-	T_0_15(13, C, D, E, A, B);
-	T_0_15(14, B, C, D, E, A);
-	T_0_15(15, A, B, C, D, E);
+	for (; i < 16; ++i)
+		T_0_15(i, A, B, C, D, E);
 
 	/* Round 1 - tail. Input from 512-bit mixing array */
-	T_16_19(16, E, A, B, C, D);
-	T_16_19(17, D, E, A, B, C);
-	T_16_19(18, C, D, E, A, B);
-	T_16_19(19, B, C, D, E, A);
+	for (; i < 20; ++i)
+		T_16_19(i, A, B, C, D, E);
 
 	/* Round 2 */
-	T_20_39(20, A, B, C, D, E);
-	T_20_39(21, E, A, B, C, D);
-	T_20_39(22, D, E, A, B, C);
-	T_20_39(23, C, D, E, A, B);
-	T_20_39(24, B, C, D, E, A);
-	T_20_39(25, A, B, C, D, E);
-	T_20_39(26, E, A, B, C, D);
-	T_20_39(27, D, E, A, B, C);
-	T_20_39(28, C, D, E, A, B);
-	T_20_39(29, B, C, D, E, A);
-	T_20_39(30, A, B, C, D, E);
-	T_20_39(31, E, A, B, C, D);
-	T_20_39(32, D, E, A, B, C);
-	T_20_39(33, C, D, E, A, B);
-	T_20_39(34, B, C, D, E, A);
-	T_20_39(35, A, B, C, D, E);
-	T_20_39(36, E, A, B, C, D);
-	T_20_39(37, D, E, A, B, C);
-	T_20_39(38, C, D, E, A, B);
-	T_20_39(39, B, C, D, E, A);
+	for (; i < 40; ++i)
+		T_20_39(i, A, B, C, D, E);
 
 	/* Round 3 */
-	T_40_59(40, A, B, C, D, E);
-	T_40_59(41, E, A, B, C, D);
-	T_40_59(42, D, E, A, B, C);
-	T_40_59(43, C, D, E, A, B);
-	T_40_59(44, B, C, D, E, A);
-	T_40_59(45, A, B, C, D, E);
-	T_40_59(46, E, A, B, C, D);
-	T_40_59(47, D, E, A, B, C);
-	T_40_59(48, C, D, E, A, B);
-	T_40_59(49, B, C, D, E, A);
-	T_40_59(50, A, B, C, D, E);
-	T_40_59(51, E, A, B, C, D);
-	T_40_59(52, D, E, A, B, C);
-	T_40_59(53, C, D, E, A, B);
-	T_40_59(54, B, C, D, E, A);
-	T_40_59(55, A, B, C, D, E);
-	T_40_59(56, E, A, B, C, D);
-	T_40_59(57, D, E, A, B, C);
-	T_40_59(58, C, D, E, A, B);
-	T_40_59(59, B, C, D, E, A);
+	for (; i < 60; ++i)
+		T_40_59(i, A, B, C, D, E);
 
 	/* Round 4 */
-	T_60_79(60, A, B, C, D, E);
-	T_60_79(61, E, A, B, C, D);
-	T_60_79(62, D, E, A, B, C);
-	T_60_79(63, C, D, E, A, B);
-	T_60_79(64, B, C, D, E, A);
-	T_60_79(65, A, B, C, D, E);
-	T_60_79(66, E, A, B, C, D);
-	T_60_79(67, D, E, A, B, C);
-	T_60_79(68, C, D, E, A, B);
-	T_60_79(69, B, C, D, E, A);
-	T_60_79(70, A, B, C, D, E);
-	T_60_79(71, E, A, B, C, D);
-	T_60_79(72, D, E, A, B, C);
-	T_60_79(73, C, D, E, A, B);
-	T_60_79(74, B, C, D, E, A);
-	T_60_79(75, A, B, C, D, E);
-	T_60_79(76, E, A, B, C, D);
-	T_60_79(77, D, E, A, B, C);
-	T_60_79(78, C, D, E, A, B);
-	T_60_79(79, B, C, D, E, A);
+	for (; i < 80; ++i)
+		T_60_79(i, A, B, C, D, E);
 
 	digest[0] += A;
 	digest[1] += B;


