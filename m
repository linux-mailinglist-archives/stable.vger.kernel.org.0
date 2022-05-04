Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097BB51A77C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355119AbiEDRGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355709AbiEDREk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5284F470;
        Wed,  4 May 2022 09:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BD5861852;
        Wed,  4 May 2022 16:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94340C385A4;
        Wed,  4 May 2022 16:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683196;
        bh=vzK/3MQfktlOQvm7xuFwJAiiuTHOPQGeUfSkCAJbx3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6o+ZIYO+flgNnbuSmSyOYr7KA3Jv9vzxvBxgB5Oe4YWw9vBXOm6oHnMOXdekUOPv
         OmAqD9GI5/jsamCpYhkznyWa6KZYmdHZdBRvv6LLOjDu/3ORVRxQH9sYTsYJR8akpP
         h+1yuzQqiVsEyYqbU1V9Yn8NlGxCSGFO3qtlWT/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 039/177] hex2bin: make the function hex_to_bin constant-time
Date:   Wed,  4 May 2022 18:43:52 +0200
Message-Id: <20220504153056.413198047@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit e5be15767e7e284351853cbaba80cde8620341fb upstream.

The function hex2bin is used to load cryptographic keys into device
mapper targets dm-crypt and dm-integrity.  It should take constant time
independent on the processed data, so that concurrently running
unprivileged code can't infer any information about the keys via
microarchitectural convert channels.

This patch changes the function hex_to_bin so that it contains no
branches and no memory accesses.

Note that this shouldn't cause performance degradation because the size
of the new function is the same as the size of the old function (on
x86-64) - and the new function causes no branch misprediction penalties.

I compile-tested this function with gcc on aarch64 alpha arm hppa hppa64
i386 ia64 m68k mips32 mips64 powerpc powerpc64 riscv sh4 s390x sparc32
sparc64 x86_64 and with clang on aarch64 arm hexagon i386 mips32 mips64
powerpc powerpc64 s390x sparc32 sparc64 x86_64 to verify that there are
no branches in the generated code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kernel.h |    2 +-
 lib/hexdump.c          |   32 +++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 8 deletions(-)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -277,7 +277,7 @@ static inline char *hex_byte_pack_upper(
 	return buf;
 }
 
-extern int hex_to_bin(char ch);
+extern int hex_to_bin(unsigned char ch);
 extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
 extern char *bin2hex(char *dst, const void *src, size_t count);
 
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -22,15 +22,33 @@ EXPORT_SYMBOL(hex_asc_upper);
  *
  * hex_to_bin() converts one hex digit to its actual value or -1 in case of bad
  * input.
+ *
+ * This function is used to load cryptographic keys, so it is coded in such a
+ * way that there are no conditions or memory accesses that depend on data.
+ *
+ * Explanation of the logic:
+ * (ch - '9' - 1) is negative if ch <= '9'
+ * ('0' - 1 - ch) is negative if ch >= '0'
+ * we "and" these two values, so the result is negative if ch is in the range
+ *	'0' ... '9'
+ * we are only interested in the sign, so we do a shift ">> 8"; note that right
+ *	shift of a negative value is implementation-defined, so we cast the
+ *	value to (unsigned) before the shift --- we have 0xffffff if ch is in
+ *	the range '0' ... '9', 0 otherwise
+ * we "and" this value with (ch - '0' + 1) --- we have a value 1 ... 10 if ch is
+ *	in the range '0' ... '9', 0 otherwise
+ * we add this value to -1 --- we have a value 0 ... 9 if ch is in the range '0'
+ *	... '9', -1 otherwise
+ * the next line is similar to the previous one, but we need to decode both
+ *	uppercase and lowercase letters, so we use (ch & 0xdf), which converts
+ *	lowercase to uppercase
  */
-int hex_to_bin(char ch)
+int hex_to_bin(unsigned char ch)
 {
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	ch = tolower(ch);
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	return -1;
+	unsigned char cu = ch & 0xdf;
+	return -1 +
+		((ch - '0' +  1) & (unsigned)((ch - '9' - 1) & ('0' - 1 - ch)) >> 8) +
+		((cu - 'A' + 11) & (unsigned)((cu - 'F' - 1) & ('A' - 1 - cu)) >> 8);
 }
 EXPORT_SYMBOL(hex_to_bin);
 


