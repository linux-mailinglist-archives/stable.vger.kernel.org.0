Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6FA499E39
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356137AbiAXWa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585442AbiAXWXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:23:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82181C04189A;
        Mon, 24 Jan 2022 12:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E560B81218;
        Mon, 24 Jan 2022 20:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720DBC340E5;
        Mon, 24 Jan 2022 20:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057626;
        bh=E+29dWAS2bNGWEVBTIKKRP7OxbGQOJmSmmqhxe69i2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BeF8sHTQBI2shzoqeLW9ayyVfDISZ2Q6x9nloNAlZxF2OA2ZiUSnzxs8wYYf65O2/
         wyiT9cb7izFbTJWRVAwvX8Sv38FUw8anVIvAY7F4CzlnK/GOVtT8hnRSfhiWmt5K9n
         wuiDllbrutCZq9yLtkkbYjy3IsRG3uSXPIHygf6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 0027/1039] riscv: use hart id instead of cpu id on machine_kexec
Date:   Mon, 24 Jan 2022 19:30:16 +0100
Message-Id: <20220124184126.052139899@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


