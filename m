Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7522040BD
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 21:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgFVT5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 15:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgFVT5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 15:57:15 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFACC0617BB
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 12:57:15 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id u23so14169945otq.10
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 12:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qafrzlyjQqkYVb549WmrCToGRQSD43SzPHaqq1cYeDQ=;
        b=UDNbUG+oR2XRF/ayYYmqngVWjA/wjtVVnZ2I6zoq4kOvRIw52h0jBDHrOxE9ZWftWl
         8HUOtlhL3wjjf575mqxupZMoO75tOveuN5R9GfIsFL9pQTA1EGY0+R8VUyKTQHtEFOO7
         Lr4icMUpILpDzzuV5AQqrxZvZ+Dv646m7+80vunswF99dP9/XCJbHjiw2vlufCNhhLTl
         aKTTDShcXgLtR1RqfSAdNWPkHlw+Y5DPgjgq6eCS1VfdRKpdbrtoDAVO+jQBkOZJ2kkm
         EuvhOPp0OWWKTv+SanWINe8rvDDJnysmtuloHwYJOtnKZ5O1ytkuJKP4XKbCd4BjjY6e
         wEdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qafrzlyjQqkYVb549WmrCToGRQSD43SzPHaqq1cYeDQ=;
        b=SoOZOO/Czm9GyU9rzqUYNOaJEfNZsfQIIjKvcp/l0UKH3/KL7unSxfGVM00hU7IXeB
         KfGNTbeUP8lB3R7RfO+h6Z1kMlMLSojAUl+Vl4YGqm+ETfAO5MKZVifRVC91K6H4siKs
         7kZGjx0/dgV5HxYS18c5kYjJHj9hrMEiD56FaDlZzbClpQcJWfPAAR8kKNWSnbDljIrz
         64iiyj3Bygx8znNdQ6qqxyMrh30woru7drBEaP5jCSHJ9grG90vzNJHtUT8DIIbniEq7
         fDR0C86buZkPlas4o9vJv1QMqvsXw9zslRA6V6rpulRUx7kC1x0HKhHQsX+jQ1goKs4f
         1Gng==
X-Gm-Message-State: AOAM533Lo+RhNK6khtJMFGzGZaZlKVZwfErHTLUA4fSQZIPI8FHBCjB9
        9NWM63oPhlBz+K74pE9i3Xw=
X-Google-Smtp-Source: ABdhPJwDdiRi97jvSi78wahfXEUEAtL2k4TwDTHN23czzEvU+jjhVmnVe2Fx7Ur8iBnyj7GfeQhpAA==
X-Received: by 2002:a9d:6201:: with SMTP id g1mr14741618otj.181.1592855834657;
        Mon, 22 Jun 2020 12:57:14 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::7])
        by smtp.gmail.com with ESMTPSA id p207sm3462673oic.22.2020.06.22.12.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 12:57:13 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 5.4] x86/boot/compressed: Relax sed symbol type regex for LLVM ld.lld
Date:   Mon, 22 Jun 2020 19:56:39 +0000
Message-Id: <20200622195639.2670308-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
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
---

Hi all,

Please apply this patch to 5.4 (and older releases if you feel it
necessary), as it fixes a build error that I see when linking with
ld.lld on certain distribution configurations after upstream commit
5214028dd89e ("x86/boot: Correct relocation destination on old linkers")
was applied in 5.4.48.

$ make -skj"$(nproc)" CC=clang LD=ld.lld O=out/x86_64 olddefconfig bzImage
...
ld.lld: error: undefined symbol: ZO__end
>>> referenced by arch/x86/boot/header.o:(.header+0x71)
...

While the commit message references bc7c9d620 as the first problematic
commit, I see the same behavior of capital versus lowercase letters from
nm here too. I assume this is not seen in mainline because this commit
was already in the tree when 5214028dd89e was applied.

v5.4.47:

$ nm -S out/x86_64/arch/x86/boot/compressed/vmlinux | grep " _end"
000000000094b000 B _end

$ cat out/x86_64/arch/x86/boot/zoffset.h
#define ZO__ehead 0x00000000000003b1
#define ZO__end 0x000000000094b000
#define ZO__text 0x000000000090ce50
#define ZO_efi32_stub_entry 0x0000000000000190
#define ZO_efi64_stub_entry 0x0000000000000390
#define ZO_efi_pe_entry 0x00000000000002f0
#define ZO_input_data 0x00000000000003b1
#define ZO_startup_32 0x0000000000000000
#define ZO_startup_64 0x0000000000000200
#define ZO_z_input_len 0x000000000090ca9e
#define ZO_z_output_len 0x0000000002eeb42c

v5.4.48:

$ nm -S out/x86_64/arch/x86/boot/compressed/vmlinux | grep " _end"
000000000094b000 b _end

$ cat out/x86_64/arch/x86/boot/zoffset.h
#define ZO__ehead 0x00000000000003b1
#define ZO__text 0x000000000090ccf0
#define ZO_efi32_stub_entry 0x0000000000000190
#define ZO_efi64_stub_entry 0x0000000000000390
#define ZO_efi_pe_entry 0x00000000000002f0
#define ZO_input_data 0x00000000000003b1
#define ZO_startup_32 0x0000000000000000
#define ZO_startup_64 0x0000000000000200
#define ZO_z_input_len 0x000000000090c93b
#define ZO_z_output_len 0x0000000002eeb4c8

v5.4.48 with this patch:

$ nm -S out/x86_64/arch/x86/boot/compressed/vmlinux | grep " _end"
000000000094b000 b _end

$ cat out/x86_64/arch/x86/boot/zoffset.h
#define ZO__ehead 0x00000000000003b1
#define ZO__end 0x000000000094b000
#define ZO__text 0x000000000090cd60
#define ZO_efi32_stub_entry 0x0000000000000190
#define ZO_efi64_stub_entry 0x0000000000000390
#define ZO_efi_pe_entry 0x00000000000002f0
#define ZO_input_data 0x00000000000003b1
#define ZO_startup_32 0x0000000000000000
#define ZO_startup_64 0x0000000000000200
#define ZO_z_input_len 0x000000000090c9af
#define ZO_z_output_len 0x0000000002eeb4c8

Hopefully this clears things up.

Cheers,
Nathan

 arch/x86/boot/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index e2839b5c246c..6539c50fb9aa 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -87,7 +87,7 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [a-zA-Z] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_ehead\|_text\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@

base-commit: 67cb016870e2fa9ffc8d34cf20db5331e6f2cf4d
-- 
2.27.0

