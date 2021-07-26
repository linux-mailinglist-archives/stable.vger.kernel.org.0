Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBAF3D61E6
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhGZPdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233463AbhGZPcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7108560F9E;
        Mon, 26 Jul 2021 16:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315959;
        bh=3QYSvqeWbBTXGr2oSTU79hdZinU2VNkohiJFYStArjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtcOIzYG++VWQtC1rtE7nqIvV8ZRD0pvMoiJWx8tSRtz/4wiH6QeH6mHN5BGtI0QG
         wCcgukmqzx76lyU4M0UbsYOHbOl3kOPGpUyQ+reH3XnKtTx/URCG3BccaZaLYDlXPe
         2j6OoYrPONYXjCuTtkJyyNVT/8KLXUm7q4VHy0hM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bin Meng <bmeng.cn@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 133/223] riscv: Fix 32-bit RISC-V boot failure
Date:   Mon, 26 Jul 2021 17:38:45 +0200
Message-Id: <20210726153850.601220234@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bin Meng <bmeng.cn@gmail.com>

[ Upstream commit d0e4dae74470fb709fc0ab61862c317938f4cc4d ]

Commit dd2d082b5760 ("riscv: Cleanup setup_bootmem()") adjusted
the calling sequence in setup_bootmem(), which invalidates the fix
commit de043da0b9e7 ("RISC-V: Fix usage of memblock_enforce_memory_limit")
did for 32-bit RISC-V unfortunately.

So now 32-bit RISC-V does not boot again when testing booting kernel
on QEMU 'virt' with '-m 2G', which was exactly what the original
commit de043da0b9e7 ("RISC-V: Fix usage of memblock_enforce_memory_limit")
tried to fix.

Fixes: dd2d082b5760 ("riscv: Cleanup setup_bootmem()")
Signed-off-by: Bin Meng <bmeng.cn@gmail.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 4c4c92ce0bb8..9b23b95c50cf 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -123,7 +123,7 @@ void __init setup_bootmem(void)
 {
 	phys_addr_t vmlinux_end = __pa_symbol(&_end);
 	phys_addr_t vmlinux_start = __pa_symbol(&_start);
-	phys_addr_t dram_end = memblock_end_of_DRAM();
+	phys_addr_t dram_end;
 	phys_addr_t max_mapped_addr = __pa(~(ulong)0);
 
 #ifdef CONFIG_XIP_KERNEL
@@ -146,6 +146,8 @@ void __init setup_bootmem(void)
 #endif
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
 
+	dram_end = memblock_end_of_DRAM();
+
 	/*
 	 * memblock allocator is not aware of the fact that last 4K bytes of
 	 * the addressable memory can not be mapped because of IS_ERR_VALUE
-- 
2.30.2



