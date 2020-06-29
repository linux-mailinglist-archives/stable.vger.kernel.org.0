Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A4E20DF3F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732520AbgF2Udh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732295AbgF2TZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 963D3253E5;
        Mon, 29 Jun 2020 15:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445320;
        bh=Ie/PtohFDNOi+umCC4vojT6M6OKKj7WlFys5FF3v0E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MfZixJu41l4cCvuNk4WPGUDqOgHVYQdmGW4rk6YxpwGMMS00erN0ReWvFBc9/g44
         VCODbiCfDPcoQ3DKJTv/C9SxaH+8pc8qd6sJ1KHaX8v6+9XG0/5H8ovEp0oZzz1pAB
         8geoDKLu4Ctl19LWxj5HIo2xfq+jKBxTsEZ+1He4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 087/191] x86/boot/compressed: Relax sed symbol type regex for LLVM ld.lld
Date:   Mon, 29 Jun 2020 11:38:23 -0400
Message-Id: <20200629154007.2495120-88-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3b16935b22bcc..d1df7d2e31b1e 100644
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

