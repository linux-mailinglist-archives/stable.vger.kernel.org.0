Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80323548D77
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354361AbiFMLcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354379AbiFML30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:29:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B89FB1D8;
        Mon, 13 Jun 2022 03:43:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DF8AB80D3A;
        Mon, 13 Jun 2022 10:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65124C34114;
        Mon, 13 Jun 2022 10:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117025;
        bh=3pLThGddqS+pgh7vhgBI/WZp5Itn5226pClHkobufI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIp8ZiYSHatKZBg6Z4eRRN6rB4p3/kNBa93VE7NWC+/XyDmm45yeaDT5mJKgGiUwZ
         DFQQTjTpQMOlWgDtT+Su6Xqex2gIfn+R8gfLypNpO8AxMplikVPh5E586NGI0z4g6K
         Eo18vQCGb0HYfohii/eIBGf7cKiRZ49lnjlq0rgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 271/411] Kconfig: add config option for asm goto w/ outputs
Date:   Mon, 13 Jun 2022 12:09:04 +0200
Message-Id: <20220613094936.886224146@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 587f17018a2c6c414e41a312b002faaef60cf423 upstream.

This allows C code to make use of compilers with support for output
variables along the fallthrough path via preprocessor define:

  CONFIG_CC_HAS_ASM_GOTO_OUTPUT

[ This is not used anywhere yet, and currently released compilers don't
  support this yet, but it's coming, and I have some local experimental
  patches to take advantage of it when it does   - Linus ]

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -38,6 +38,10 @@ config CC_HAS_ASM_GOTO_TIED_OUTPUT
 	# Detect buggy gcc and clang, fixed in gcc-11 clang-14.
 	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
 
+config CC_HAS_ASM_GOTO_OUTPUT
+	depends on CC_HAS_ASM_GOTO
+	def_bool $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
+
 config TOOLS_SUPPORT_RELR
 	def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
 


