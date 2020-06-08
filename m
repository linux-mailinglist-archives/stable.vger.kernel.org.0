Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C79B1F24AE
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbgFHXVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731193AbgFHXVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C4A92072F;
        Mon,  8 Jun 2020 23:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658499;
        bh=xJDsdbdyq7liIv4sqCE7RI5+x+OictqjM4VIOWGkLNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daQILlnQCPHNw8hbf0aT8x5FAYGWx+nTclPrT8zI3TvNmOC2x4djmJjjoHWAfDFv7
         HEyWd/K3MbOICsu5He+29Zq+W5ev6kYWlkvevcHsfR9Z4TW+cuBmrZ0nmf3DG3ex4L
         YBsEYmRVhqkUi0maB8kz5H6waddA3n1U4LN0TxTA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 131/175] x86/boot: Correct relocation destination on old linkers
Date:   Mon,  8 Jun 2020 19:18:04 -0400
Message-Id: <20200608231848.3366970-131-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit 5214028dd89e49ba27007c3ee475279e584261f0 ]

For the 32-bit kernel, as described in

  6d92bc9d483a ("x86/build: Build compressed x86 kernels as PIE"),

pre-2.26 binutils generates R_386_32 relocations in PIE mode. Since the
startup code does not perform relocation, any reloc entry with R_386_32
will remain as 0 in the executing code.

Commit

  974f221c84b0 ("x86/boot: Move compressed kernel to the end of the
                 decompression buffer")

added a new symbol _end but did not mark it hidden, which doesn't give
the correct offset on older linkers. This causes the compressed kernel
to be copied beyond the end of the decompression buffer, rather than
flush against it. This region of memory may be reserved or already
allocated for other purposes by the bootloader.

Mark _end as hidden to fix. This changes the relocation from R_386_32 to
R_386_RELATIVE even on the pre-2.26 binutils.

For 64-bit, this is not strictly necessary, as the 64-bit kernel is only
built as PIE if the linker supports -z noreloc-overflow, which implies
binutils-2.27+, but for consistency, mark _end as hidden here too.

The below illustrates the before/after impact of the patch using
binutils-2.25 and gcc-4.6.4 (locally compiled from source) and QEMU.

  Disassembly before patch:
    48:   8b 86 60 02 00 00       mov    0x260(%esi),%eax
    4e:   2d 00 00 00 00          sub    $0x0,%eax
                          4f: R_386_32    _end
  Disassembly after patch:
    48:   8b 86 60 02 00 00       mov    0x260(%esi),%eax
    4e:   2d 00 f0 76 00          sub    $0x76f000,%eax
                          4f: R_386_RELATIVE      *ABS*

Dump from extract_kernel before patch:
	early console in extract_kernel
	input_data: 0x0207c098 <--- this is at output + init_size
	input_len: 0x0074fef1
	output: 0x01000000
	output_len: 0x00fa63d0
	kernel_total_size: 0x0107c000
	needed_size: 0x0107c000

Dump from extract_kernel after patch:
	early console in extract_kernel
	input_data: 0x0190d098 <--- this is at output + init_size - _end
	input_len: 0x0074fef1
	output: 0x01000000
	output_len: 0x00fa63d0
	kernel_total_size: 0x0107c000
	needed_size: 0x0107c000

Fixes: 974f221c84b0 ("x86/boot: Move compressed kernel to the end of the decompression buffer")
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200207214926.3564079-1-nivedita@alum.mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/head_32.S | 5 +++--
 arch/x86/boot/compressed/head_64.S | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 70ffce98c568..d7c0fcc1dbf9 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -49,16 +49,17 @@
  * Position Independent Executable (PIE) so that linker won't optimize
  * R_386_GOT32X relocation to its fixed symbol address.  Older
  * linkers generate R_386_32 relocations against locally defined symbols,
- * _bss, _ebss, _got and _egot, in PIE.  It isn't wrong, just less
+ * _bss, _ebss, _got, _egot and _end, in PIE.  It isn't wrong, just less
  * optimal than R_386_RELATIVE.  But the x86 kernel fails to properly handle
  * R_386_32 relocations when relocating the kernel.  To generate
- * R_386_RELATIVE relocations, we mark _bss, _ebss, _got and _egot as
+ * R_386_RELATIVE relocations, we mark _bss, _ebss, _got, _egot and _end as
  * hidden:
  */
 	.hidden _bss
 	.hidden _ebss
 	.hidden _got
 	.hidden _egot
+	.hidden _end
 
 	__HEAD
 ENTRY(startup_32)
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 07d2002da642..50c9eeb36f0d 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -42,6 +42,7 @@
 	.hidden _ebss
 	.hidden _got
 	.hidden _egot
+	.hidden _end
 
 	__HEAD
 	.code32
-- 
2.25.1

