Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF2F558289
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiFWRQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiFWRN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F4C995C7;
        Thu, 23 Jun 2022 09:59:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B0F360FFA;
        Thu, 23 Jun 2022 16:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23A0C36AE2;
        Thu, 23 Jun 2022 16:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003556;
        bh=/Unki+FpIaDGECWe1V9jGlUeejcMaSxiAptWRvMMIjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G47/9PlYYARlcxYzmXz5vOy7R0iSd9VeI7bg8qrga8eYGQ4n/LZSMA5YE/xTJoHtr
         wFuFBTHFS7rxVc878tG6wuQDo+QcBU77DL5FqCYS8wjLT4mS5Hk5gtOaOwiE9r3g2X
         6S7wv5S/bkLvoq9xMuYWbcTadxM2CCxTR9QF+S60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 013/237] drivers/char/random.c: remove unused stuct poolinfo::poolbits
Date:   Thu, 23 Jun 2022 18:40:47 +0200
Message-Id: <20220623164343.533309583@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 3bd0b5bf7dc3ea02070fcbcd682ecf628269e8ef upstream.

This field is never used, might as well remove it.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -295,7 +295,7 @@
  * To allow fractional bits to be tracked, the entropy_count field is
  * denominated in units of 1/8th bits.
  *
- * 2*(ENTROPY_SHIFT + log2(poolbits)) must <= 31, or the multiply in
+ * 2*(ENTROPY_SHIFT + poolbitshift) must <= 31, or the multiply in
  * credit_entropy_bits() needs to be 64 bits wide.
  */
 #define ENTROPY_SHIFT 3
@@ -360,8 +360,8 @@ static int random_write_wakeup_bits = 28
  * irreducible, which we have made here.
  */
 static const struct poolinfo {
-	int poolbitshift, poolwords, poolbytes, poolbits, poolfracbits;
-#define S(x) ilog2(x)+5, (x), (x)*4, (x)*32, (x) << (ENTROPY_SHIFT+5)
+	int poolbitshift, poolwords, poolbytes, poolfracbits;
+#define S(x) ilog2(x)+5, (x), (x)*4, (x) << (ENTROPY_SHIFT+5)
 	int tap1, tap2, tap3, tap4, tap5;
 } poolinfo_table[] = {
 	/* was: x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 */


