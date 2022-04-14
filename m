Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4DF5013A7
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348275AbiDNOEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346263AbiDNN4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:56:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53094652E6;
        Thu, 14 Apr 2022 06:46:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E13E0612E6;
        Thu, 14 Apr 2022 13:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED44DC385A5;
        Thu, 14 Apr 2022 13:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943984;
        bh=GmG49H7qoQjEtcOTtxsppeEViImyfS6qlYEWyemRfbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZbhNQxjJI2xHR8eRspr0yPZzPHhKisXbzVj9HCsO47f7MYWYcMvqQ9zPKCBc32q3
         ZjOoLZLFjTyZCH5TLmoN2ChLx608Obi4sZqtJU8WTqqXUpoFZA+AsrM+/dWsJWuKxQ
         rDWuQ6umBJu5pbnKfweKzpisZd9x8W+kfd3a9nBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 312/475] powerpc/lib/sstep: Fix build errors with newer binutils
Date:   Thu, 14 Apr 2022 15:11:37 +0200
Message-Id: <20220414110903.819434521@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
@@ -906,7 +906,10 @@ NOKPROBE_SYMBOL(emulate_dcbz);
 
 #define __put_user_asmx(x, addr, err, op, cr)		\
 	__asm__ __volatile__(				\
+		".machine push\n"			\
+		".machine power8\n"			\
 		"1:	" op " %2,0,%3\n"		\
+		".machine pop\n"			\
 		"	mfcr	%1\n"			\
 		"2:\n"					\
 		".section .fixup,\"ax\"\n"		\
@@ -919,7 +922,10 @@ NOKPROBE_SYMBOL(emulate_dcbz);
 
 #define __get_user_asmx(x, addr, err, op)		\
 	__asm__ __volatile__(				\
+		".machine push\n"			\
+		".machine power8\n"			\
 		"1:	"op" %1,0,%2\n"			\
+		".machine pop\n"			\
 		"2:\n"					\
 		".section .fixup,\"ax\"\n"		\
 		"3:	li	%0,%3\n"		\


