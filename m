Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0983C63DDD7
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiK3SbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiK3SbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:31:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246A38D672
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:31:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC8E5B81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21848C433D6;
        Wed, 30 Nov 2022 18:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833060;
        bh=DYeV9Tz3GHJjlEoirj7QtXPTUyghXKfd57pxpa3OCDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTl08fpDidannVfj9D3Jc5fiN68qF1ZmIwqI5WAaQmEQ85PFqv6wsTuJ5NlhcMIc7
         e7DwQ3fXcRI8PYV4m5xPN2Ufps1RRQxx75sOmiOYu/sftpDg8scK2gjd2RznuKlZt6
         By5LHOa0GsFMrGcJDO3KCFQ7dywHqKA5rTAF9wG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sean Christopherson <seanjc@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/162] init/Kconfig: fix CC_HAS_ASM_GOTO_TIED_OUTPUT test with dash
Date:   Wed, 30 Nov 2022 19:23:00 +0100
Message-Id: <20221130180531.176061816@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 534bd70374d646f17e2cebe0e6e4cdd478ce4f0c ]

When using dash as /bin/sh, the CC_HAS_ASM_GOTO_TIED_OUTPUT test fails
with a syntax error which is not the one we are looking for:

<stdin>: In function ‘foo’:
<stdin>:1:29: warning: missing terminating " character
<stdin>:1:29: error: missing terminating " character
<stdin>:2:5: error: expected ‘:’ before ‘+’ token
<stdin>:2:7: warning: missing terminating " character
<stdin>:2:7: error: missing terminating " character
<stdin>:2:5: error: expected declaration or statement at end of input

Removing '\n' solves this.

Fixes: 1aa0e8b144b6 ("Kconfig: Add option for asm goto w/ tied outputs to workaround clang-13 bug")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 22912631d79b..eba883d6d9ed 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -71,7 +71,7 @@ config CC_HAS_ASM_GOTO_OUTPUT
 config CC_HAS_ASM_GOTO_TIED_OUTPUT
 	depends on CC_HAS_ASM_GOTO_OUTPUT
 	# Detect buggy gcc and clang, fixed in gcc-11 clang-14.
-	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
+	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
 
 config TOOLS_SUPPORT_RELR
 	def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
-- 
2.35.1



