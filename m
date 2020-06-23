Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87998206060
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392389AbgFWUmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392398AbgFWUmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:42:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3485320675;
        Tue, 23 Jun 2020 20:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944933;
        bh=kGRmZLItnQkLpbUnjXCwaWJEJgShGAHtqXcmb9eupoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7RWDqDeDms6oSTyG5DDk4rryo3iUHieHEOCnSfPIjN/WHbC4ofrOE8y+lIvhmeIb
         pKV0T3beKV/LkbcwQfMVjVFupetsWY84zrbem4vpsuKbBOH+qMR6o92kldXaPn1/Im
         NEUydLu6AEP8mxCC1p1gxM/iRpG3e9OrCzEdXpkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 181/206] x86/boot/compressed: Relax sed symbol type regex for LLVM ld.lld
Date:   Tue, 23 Jun 2020 21:58:29 +0200
Message-Id: <20200623195325.942584567@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit bc310baf2ba381c648983c7f4748327f17324562 upstream.

The final build stage of the x86 kernel captures some symbol
addresses from the decompressor binary and copies them into zoffset.h.
It uses sed with a regular expression that matches the address, symbol
type and symbol name, and mangles the captured addresses and the names
of symbols of interest into #define directives that are added to
zoffset.h

The symbol type is indicated by a single letter, which we match
strictly: only letters in the set 'ABCDGRSTVW' are matched, even
though the actual symbol type is relevant and therefore ignored.

Commit bc7c9d620 ("efi/libstub/x86: Force 'hidden' visibility for
extern declarations") made a change to the way external symbol
references are classified, resulting in 'startup_32' now being
emitted as a hidden symbol. This prevents the use of GOT entries to
refer to this symbol via its absolute address, which recent toolchains
(including Clang based ones) already avoid by default, making this
change a no-op in the majority of cases.

However, as it turns out, the LLVM linker classifies such hidden
symbols as symbols with static linkage in fully linked ELF binaries,
causing tools such as NM to output a lowercase 't' rather than an upper
case 'T' for the type of such symbols. Since our sed expression only
matches upper case letters for the symbol type, the line describing
startup_32 is disregarded, resulting in a build error like the following

  arch/x86/boot/header.S:568:18: error: symbol 'ZO_startup_32' can not be
                                        undefined in a subtraction expression
  init_size: .long (0x00000000008fd000 - ZO_startup_32 +
                    (((0x0000000001f6361c + ((0x0000000001f6361c >> 8) + 65536)
                     - 0x00000000008c32e5) + 4095) & ~4095)) # kernel initialization size

Given that we are only interested in the value of the symbol, let's match
any character in the set 'a-zA-Z' instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index e2839b5c246c2..6539c50fb9aae 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -87,7 +87,7 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [a-zA-Z] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
-- 
2.25.1



