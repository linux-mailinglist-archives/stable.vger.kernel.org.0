Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB0C4991A7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344192AbiAXUMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:12:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37262 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355070AbiAXUKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:10:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 482C261375;
        Mon, 24 Jan 2022 20:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C09C340E5;
        Mon, 24 Jan 2022 20:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055052;
        bh=E+29dWAS2bNGWEVBTIKKRP7OxbGQOJmSmmqhxe69i2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsswdLZc4JBtxXE6dctJ8PVJ8M22zmLmajBQjHAYk+qm99DxJqYp5Pl32x1W9VfzN
         amFvibxzu7UJ1Hj5nD9cOn8IZCecQ8s0IHz8Z1N2LPbmv2tD25QsgkCPBaUy37DDlI
         b4E4dIfIsLzZKqVofX0IHJJ47k1+us75tpICLMRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 025/846] riscv: use hart id instead of cpu id on machine_kexec
Date:   Mon, 24 Jan 2022 19:32:22 +0100
Message-Id: <20220124184101.791758733@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Kossifidis <mick@ics.forth.gr>

commit 0e105f1d0037d677dff3c697d22f9551e6c39af8 upstream.

raw_smp_processor_id() doesn't return the hart id as stated in
arch/riscv/include/asm/smp.h, use smp_processor_id() instead
to get the cpu id, and cpuid_to_hartid_map() to pass the hart id
to the next kernel. This fixes kexec on HiFive Unleashed/Unmatched
where cpu ids and hart ids don't match (on qemu-virt they match).

Fixes: fba8a8674f68 ("RISC-V: Add kexec support")
Signed-off-by: Nick Kossifidis <mick@ics.forth.gr>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/machine_kexec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -169,7 +169,8 @@ machine_kexec(struct kimage *image)
 	struct kimage_arch *internal = &image->arch;
 	unsigned long jump_addr = (unsigned long) image->start;
 	unsigned long first_ind_entry = (unsigned long) &image->head;
-	unsigned long this_hart_id = raw_smp_processor_id();
+	unsigned long this_cpu_id = smp_processor_id();
+	unsigned long this_hart_id = cpuid_to_hartid_map(this_cpu_id);
 	unsigned long fdt_addr = internal->fdt_addr;
 	void *control_code_buffer = page_address(image->control_code_page);
 	riscv_kexec_method kexec_method = NULL;


