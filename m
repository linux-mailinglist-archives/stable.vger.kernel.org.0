Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE1E5943F5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347340AbiHOWD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350431AbiHOWCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:02:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7716E56BBA;
        Mon, 15 Aug 2022 12:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 215EBB80EAB;
        Mon, 15 Aug 2022 19:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774F8C433C1;
        Mon, 15 Aug 2022 19:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592199;
        bh=O4b+wZIdNDyRYvQfOFHRVJytBEWmlO6Mx0dPFE9bktY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7bLuuihY2j6emmHMz/4kUeTPnbihPJZP1HnKCCWDweR7bfPR4si7/avoqpj44F7j
         YM5+1YoAsGS3eUrPJCD8GzRXNZ7/UsdUh3wQodnkRIZLO5rxsmUOZezpI0Wfi7Mj0w
         RHrDA4qIbtzF0v75TE9IswtMUvTusjn/s6r7j878=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Atish Patra <atishp@rivosinc.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.19 0073/1157] RISC-V: kexec: Fixup use of smp_processor_id() in preemptible context
Date:   Mon, 15 Aug 2022 19:50:29 +0200
Message-Id: <20220815180442.442808247@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Xianting Tian <xianting.tian@linux.alibaba.com>

commit 357628e68f5c08ad578a718dc62a0031e06dbe91 upstream.

Use __smp_processor_id() to avoid check the preemption context when
CONFIG_DEBUG_PREEMPT enabled, as we will enter crash kernel and no
return.

Without the patch,
[  103.781044] sysrq: Trigger a crash
[  103.784625] Kernel panic - not syncing: sysrq triggered crash
[  103.837634] CPU1: off
[  103.889668] CPU2: off
[  103.933479] CPU3: off
[  103.939424] Starting crashdump kernel...
[  103.943442] BUG: using smp_processor_id() in preemptible [00000000] code: sh/346
[  103.950884] caller is debug_smp_processor_id+0x1c/0x26
[  103.956051] CPU: 0 PID: 346 Comm: sh Kdump: loaded Not tainted 5.10.113-00002-gce03f03bf4ec-dirty #149
[  103.965355] Call Trace:
[  103.967805] [<ffffffe00020372a>] walk_stackframe+0x0/0xa2
[  103.973206] [<ffffffe000bcf1f4>] show_stack+0x32/0x3e
[  103.978258] [<ffffffe000bd382a>] dump_stack_lvl+0x72/0x8e
[  103.983655] [<ffffffe000bd385a>] dump_stack+0x14/0x1c
[  103.988705] [<ffffffe000bdc8fe>] check_preemption_disabled+0x9e/0xaa
[  103.995057] [<ffffffe000bdc926>] debug_smp_processor_id+0x1c/0x26
[  104.001150] [<ffffffe000206c64>] machine_kexec+0x22/0xd0
[  104.006463] [<ffffffe000291a7e>] __crash_kexec+0x6a/0xa4
[  104.011774] [<ffffffe000bcf3fa>] panic+0xfc/0x2b0
[  104.016480] [<ffffffe000656ca4>] sysrq_reset_seq_param_set+0x0/0x70
[  104.022745] [<ffffffe000657310>] __handle_sysrq+0x8c/0x154
[  104.028229] [<ffffffe0006577e8>] write_sysrq_trigger+0x5a/0x6a
[  104.034061] [<ffffffe0003d90e0>] proc_reg_write+0x58/0xd4
[  104.039459] [<ffffffe00036cff4>] vfs_write+0x7e/0x254
[  104.044509] [<ffffffe00036d2f6>] ksys_write+0x58/0xbe
[  104.049558] [<ffffffe00036d36a>] sys_write+0xe/0x16
[  104.054434] [<ffffffe000201b9a>] ret_from_syscall+0x0/0x2
[  104.067863] Will call new kernel at ecc00000 from hart id 0
[  104.074939] FDT image at fc5ee000
[  104.079523] Bye...

With the patch we can got clear output,
[   67.740553] sysrq: Trigger a crash
[   67.744166] Kernel panic - not syncing: sysrq triggered crash
[   67.809123] CPU1: off
[   67.865210] CPU2: off
[   67.909075] CPU3: off
[   67.919123] Starting crashdump kernel...
[   67.924900] Will call new kernel at ecc00000 from hart id 0
[   67.932045] FDT image at fc5ee000
[   67.935560] Bye...

Fixes: 0e105f1d0037 ("riscv: use hart id instead of cpu id on machine_kexec")
Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220811074150.3020189-2-xianting.tian@linux.alibaba.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/machine_kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -171,7 +171,7 @@ machine_kexec(struct kimage *image)
 	struct kimage_arch *internal = &image->arch;
 	unsigned long jump_addr = (unsigned long) image->start;
 	unsigned long first_ind_entry = (unsigned long) &image->head;
-	unsigned long this_cpu_id = smp_processor_id();
+	unsigned long this_cpu_id = __smp_processor_id();
 	unsigned long this_hart_id = cpuid_to_hartid_map(this_cpu_id);
 	unsigned long fdt_addr = internal->fdt_addr;
 	void *control_code_buffer = page_address(image->control_code_page);


