Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9124F2B22
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237546AbiDEIms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240494AbiDEIcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF40D7246C;
        Tue,  5 Apr 2022 01:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 558E460FFC;
        Tue,  5 Apr 2022 08:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F005C385A2;
        Tue,  5 Apr 2022 08:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147068;
        bh=8Lxz8YXku8+/UbywXNde6FytYLkgLbFrUsn5jXKeWto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9bmCvbSwkrfxTzTzJKs0GEoVb/TDtXbdvJ8j1UJX86/nqC4gpb/wDmVKkXFbuHt9
         rcYUe4NSnPHjxcOlTkkBij8NAPiAUBbMWniDPyYkjx6G8Xp3IfHPCIUqoiQaB9Phb3
         2ixpQblbj1jhrO5QNADL6fj/5G+Qc58iGoATujZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.17 0963/1126] powerpc/lib/sstep: Fix build errors with newer binutils
Date:   Tue,  5 Apr 2022 09:28:30 +0200
Message-Id: <20220405070435.774343569@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

commit 8219d31effa7be5dbc7ff915d7970672e028c701 upstream.

Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
2.37.90.20220207) the following build error shows up:

  {standard input}: Assembler messages:
  {standard input}:10576: Error: unrecognized opcode: `stbcx.'
  {standard input}:10680: Error: unrecognized opcode: `lharx'
  {standard input}:10694: Error: unrecognized opcode: `lbarx'

Rework to add assembler directives [1] around the instruction.  The
problem with this might be that we can trick a power6 into
single-stepping through an stbcx. for instance, and it will execute that
in kernel mode.

[1] https://sourceware.org/binutils/docs/as/PowerPC_002dPseudo.html#PowerPC_002dPseudo

Fixes: 350779a29f11 ("powerpc: Handle most loads and stores in instruction emulation code")
Cc: stable@vger.kernel.org # v4.14+
Co-developed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220224162215.3406642-3-anders.roxell@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/sstep.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1097,7 +1097,10 @@ NOKPROBE_SYMBOL(emulate_dcbz);
 
 #define __put_user_asmx(x, addr, err, op, cr)		\
 	__asm__ __volatile__(				\
+		".machine push\n"			\
+		".machine power8\n"			\
 		"1:	" op " %2,0,%3\n"		\
+		".machine pop\n"			\
 		"	mfcr	%1\n"			\
 		"2:\n"					\
 		".section .fixup,\"ax\"\n"		\
@@ -1110,7 +1113,10 @@ NOKPROBE_SYMBOL(emulate_dcbz);
 
 #define __get_user_asmx(x, addr, err, op)		\
 	__asm__ __volatile__(				\
+		".machine push\n"			\
+		".machine power8\n"			\
 		"1:	"op" %1,0,%2\n"			\
+		".machine pop\n"			\
 		"2:\n"					\
 		".section .fixup,\"ax\"\n"		\
 		"3:	li	%0,%3\n"		\


