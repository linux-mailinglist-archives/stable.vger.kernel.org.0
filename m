Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214B0621501
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbiKHOH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbiKHOHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:07:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC4D70572
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:07:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97760B81ADB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D771BC433D6;
        Tue,  8 Nov 2022 14:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916431;
        bh=G0DsZgAzlVolF9g6XPs3W1vrzU1wL1qn9570OJrENaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWERXp42JRVEyEcFqzQ/kvhE8qpSYRaaOxYOflIB3W5xlD8mSZXAg+qrBlXbbkrnR
         px9YUMli85nFN5QtmhkniXm4sDFk3i17P8zyFJXqD+ESsudeKJ+kNRMdZ1Zc42GwDD
         2we7MbIBp01DjpGNwhP22EeLY/b0errxlQNqQWxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <yujie.liu@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 019/197] tools/nolibc: Fix missing strlen() definition and infinite loop with gcc-12
Date:   Tue,  8 Nov 2022 14:37:37 +0100
Message-Id: <20221108133355.646439477@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit bfc3b0f05653a28c8d41067a2aa3875d1f982e3e ]

When built at -Os, gcc-12 recognizes an strlen() pattern in nolibc_strlen()
and replaces it with a jump to strlen(), which is not defined as a symbol
and breaks compilation. Worse, when the function is called strlen(), the
function is simply replaced with a jump to itself, hence becomes an
infinite loop.

One way to avoid this is to always set -ffreestanding, but the calling
code doesn't know this and there's no way (either via attributes or
pragmas) to globally enable it from include files, effectively leaving
a painful situation for the caller.

Alexey suggested to place an empty asm() statement inside the loop to
stop gcc from recognizing a well-known pattern, which happens to work
pretty fine. At least it allows us to make sure our local definition
is not replaced with a self jump.

The function only needs to be renamed back to strlen() so that the symbol
exists, which implies that nolibc_strlen() which is used on variable
strings has to be declared as a macro that points back to it before the
strlen() macro is redifined.

It was verified to produce valid code with gcc 3.4 to 12.1 at different
optimization levels, and both with constant and variable strings.

In case this problem surfaces again in the future, an alternate approach
consisting in adding an optimize("no-tree-loop-distribute-patterns")
function attribute for gcc>=12 worked as well but is less pretty.

Reported-by: kernel test robot <yujie.liu@intel.com>
Link: https://lore.kernel.org/r/202210081618.754a77db-yujie.liu@intel.com
Fixes: 66b6f755ad45 ("rcutorture: Import a copy of nolibc")
Fixes: 96980b833a21 ("tools/nolibc/string: do not use __builtin_strlen() at -O0")
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/string.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/include/nolibc/string.h b/tools/include/nolibc/string.h
index bef35bee9c44..718a405ffbc3 100644
--- a/tools/include/nolibc/string.h
+++ b/tools/include/nolibc/string.h
@@ -125,14 +125,18 @@ char *strcpy(char *dst, const char *src)
 }
 
 /* this function is only used with arguments that are not constants or when
- * it's not known because optimizations are disabled.
+ * it's not known because optimizations are disabled. Note that gcc 12
+ * recognizes an strlen() pattern and replaces it with a jump to strlen(),
+ * thus itself, hence the asm() statement below that's meant to disable this
+ * confusing practice.
  */
 static __attribute__((unused))
-size_t nolibc_strlen(const char *str)
+size_t strlen(const char *str)
 {
 	size_t len;
 
-	for (len = 0; str[len]; len++);
+	for (len = 0; str[len]; len++)
+		asm("");
 	return len;
 }
 
@@ -140,13 +144,12 @@ size_t nolibc_strlen(const char *str)
  * the two branches, then will rely on an external definition of strlen().
  */
 #if defined(__OPTIMIZE__)
+#define nolibc_strlen(x) strlen(x)
 #define strlen(str) ({                          \
 	__builtin_constant_p((str)) ?           \
 		__builtin_strlen((str)) :       \
 		nolibc_strlen((str));           \
 })
-#else
-#define strlen(str) nolibc_strlen((str))
 #endif
 
 static __attribute__((unused))
-- 
2.35.1



