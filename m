Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2116E548AF1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344170AbiFMKuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347457AbiFMKs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:48:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213372D1C0;
        Mon, 13 Jun 2022 03:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52BC6CE1109;
        Mon, 13 Jun 2022 10:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB92C3411E;
        Mon, 13 Jun 2022 10:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115984;
        bh=5rz/pCFVP0KvalI8oTynYPiP7RRn0myqsnfJnDunsxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtCKyOmhbLz2l2vS1uF7ARyCtffJ6xTU7PoiQiqm7eS+EX/icHJS+wwL6+HoGK1ro
         pwf6yHqKDnW4QPX1fcZEpTa9VEDZZLLdfPgMLdPMNhnyrtxeqtqxuuJYFPBfg44hq0
         NTZ9xX89lLEhvdHRTTahdBa+Pbze8AWB1mdn7Pz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.4 001/411] binfmt_flat: do not stop relocating GOT entries prematurely on riscv
Date:   Mon, 13 Jun 2022 12:04:34 +0200
Message-Id: <20220613094928.532599398@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Niklas Cassel <niklas.cassel@wdc.com>

commit 6045ab5fea4c849153ebeb0acb532da5f29d69c4 upstream.

bFLT binaries are usually created using elf2flt.

The linker script used by elf2flt has defined the .data section like the
following for the last 19 years:

.data : {
	_sdata = . ;
	__data_start = . ;
	data_start = . ;
	*(.got.plt)
	*(.got)
	FILL(0) ;
	. = ALIGN(0x20) ;
	LONG(-1)
	. = ALIGN(0x20) ;
	...
}

It places the .got.plt input section before the .got input section.
The same is true for the default linker script (ld --verbose) on most
architectures except x86/x86-64.

The binfmt_flat loader should relocate all GOT entries until it encounters
a -1 (the LONG(-1) in the linker script).

The problem is that the .got.plt input section starts with a GOTPLT header
(which has size 16 bytes on elf64-riscv and 8 bytes on elf32-riscv), where
the first word is set to -1. See the binutils implementation for riscv [1].

This causes the binfmt_flat loader to stop relocating GOT entries
prematurely and thus causes the application to crash when running.

Fix this by skipping the whole GOTPLT header, since the whole GOTPLT header
is reserved for the dynamic linker.

The GOTPLT header will only be skipped for bFLT binaries with flag
FLAT_FLAG_GOTPIC set. This flag is unconditionally set by elf2flt if the
supplied ELF binary has the symbol _GLOBAL_OFFSET_TABLE_ defined.
ELF binaries without a .got input section should thus remain unaffected.

Tested on RISC-V Canaan Kendryte K210 and RISC-V QEMU nommu_virt_defconfig.

[1] https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=bfd/elfnn-riscv.c;hb=binutils-2_38#l3275

Cc: <stable@vger.kernel.org>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20220414091018.896737-1-niklas.cassel@wdc.com
Fixed-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202204182333.OIUOotK8-lkp@intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_flat.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -422,6 +422,30 @@ static void old_reloc(unsigned long rl)
 
 /****************************************************************************/
 
+static inline u32 __user *skip_got_header(u32 __user *rp)
+{
+	if (IS_ENABLED(CONFIG_RISCV)) {
+		/*
+		 * RISC-V has a 16 byte GOT PLT header for elf64-riscv
+		 * and 8 byte GOT PLT header for elf32-riscv.
+		 * Skip the whole GOT PLT header, since it is reserved
+		 * for the dynamic linker (ld.so).
+		 */
+		u32 rp_val0, rp_val1;
+
+		if (get_user(rp_val0, rp))
+			return rp;
+		if (get_user(rp_val1, rp + 1))
+			return rp;
+
+		if (rp_val0 == 0xffffffff && rp_val1 == 0xffffffff)
+			rp += 4;
+		else if (rp_val0 == 0xffffffff)
+			rp += 2;
+	}
+	return rp;
+}
+
 static int load_flat_file(struct linux_binprm *bprm,
 		struct lib_info *libinfo, int id, unsigned long *extra_stack)
 {
@@ -769,7 +793,8 @@ static int load_flat_file(struct linux_b
 	 * image.
 	 */
 	if (flags & FLAT_FLAG_GOTPIC) {
-		for (rp = (u32 __user *)datapos; ; rp++) {
+		rp = skip_got_header((u32 __user *) datapos);
+		for (; ; rp++) {
 			u32 addr, rp_val;
 			if (get_user(rp_val, rp))
 				return -EFAULT;


