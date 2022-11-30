Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703BD63DFFE
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiK3Swu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiK3Sw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:52:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730C29FEC4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26E1CB81CAC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CF7C433C1;
        Wed, 30 Nov 2022 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834342;
        bh=qvo0L5KjFEOTE8f0MGBe4zoA4BrVKwLqGu1Z+tVTtX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXornSsRg8wIPen9lKuVMJExJAzDxQjLCK0ci8TO8cmCWQQ5WedCJ99+ClZJhyMSL
         gcUN/VUsLK6TEOEFBFwtaz8CPJNwqJdkyo4JjxMpM2ZJwIueaJFA+BubXhfIT0D6Qq
         IWtbNCkdvwWailY3ACin9CNOjf9N9CRh1aBNCWjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qi Hu <huqi@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.0 218/289] LoongArch: Clear FPU/SIMD thread info flags for kernel thread
Date:   Wed, 30 Nov 2022 19:23:23 +0100
Message-Id: <20221130180549.061113837@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

commit e428e9613531d1ef6bd0d91352899712b29134fb upstream.

If a kernel thread is created by a user thread, it may carry FPU/SIMD
thread info flags (TIF_USEDFPU, TIF_USEDSIMD, etc.). Then it will be
considered as a fpu owner and kernel try to save its FPU/SIMD context
and cause such errors:

[   41.518931] do_fpu invoked from kernel context![#1]:
[   41.523933] CPU: 1 PID: 395 Comm: iou-wrk-394 Not tainted 6.1.0-rc5+ #217
[   41.530757] Hardware name: Loongson Loongson-3A5000-7A1000-1w-CRB/Loongson-LS3A5000-7A1000-1w-CRB, BIOS vUDK2018-LoongArch-V2.0.pre-beta8 08/18/2022
[   41.544064] $ 0   : 0000000000000000 90000000011e9468 9000000106c7c000 9000000106c7fcf0
[   41.552101] $ 4   : 9000000106305d40 9000000106689800 9000000106c7fd08 0000000003995818
[   41.560138] $ 8   : 0000000000000001 90000000009a72e4 0000000000000020 fffffffffffffffc
[   41.568174] $12   : 0000000000000000 0000000000000000 0000000000000020 00000009aab7e130
[   41.576211] $16   : 00000000000001ff 0000000000000407 0000000000000001 0000000000000000
[   41.584247] $20   : 0000000000000000 0000000000000001 9000000106c7fd70 90000001002f0400
[   41.592284] $24   : 0000000000000000 900000000178f740 90000000011e9834 90000001063057c0
[   41.600320] $28   : 0000000000000000 0000000000000001 9000000006826b40 9000000106305140
[   41.608356] era   : 9000000000228848 _save_fp+0x0/0xd8
[   41.613542] ra    : 90000000011e9468 __schedule+0x568/0x8d0
[   41.619160] CSR crmd: 000000b0
[   41.619163] CSR prmd: 00000000
[   41.622359] CSR euen: 00000000
[   41.625558] CSR ecfg: 00071c1c
[   41.628756] CSR estat: 000f0000
[   41.635239] ExcCode : f (SubCode 0)
[   41.638783] PrId  : 0014c010 (Loongson-64bit)
[   41.643191] Modules linked in: acpi_ipmi vfat fat ipmi_si ipmi_devintf cfg80211 ipmi_msghandler rfkill fuse efivarfs
[   41.653734] Process iou-wrk-394 (pid: 395, threadinfo=0000000004ebe913, task=00000000636fa1be)
[   41.662375] Stack : 00000000ffff0875 9000000006800ec0 9000000006800ec0 90000000002d57e0
[   41.670412]         0000000000000001 0000000000000000 9000000106535880 0000000000000001
[   41.678450]         9000000105291800 0000000000000000 9000000105291838 900000000178e000
[   41.686487]         9000000106c7fd90 9000000106305140 0000000000000001 90000000011e9834
[   41.694523]         00000000ffff0875 90000000011f034c 9000000105291838 9000000105291830
[   41.702561]         0000000000000000 9000000006801440 00000000ffff0875 90000000002d48c0
[   41.710597]         9000000128800001 9000000106305140 9000000105291838 9000000105291838
[   41.718634]         9000000105291830 9000000107811740 9000000105291848 90000000009bf1e0
[   41.726672]         9000000105291830 9000000107811748 2d6b72772d756f69 0000000000343933
[   41.734708]         0000000000000000 0000000000000000 0000000000000000 0000000000000000
[   41.742745]         ...
[   41.745252] Call Trace:
[   42.197868] [<9000000000228848>] _save_fp+0x0/0xd8
[   42.205214] [<90000000011ed468>] __schedule+0x568/0x8d0
[   42.210485] [<90000000011ed834>] schedule+0x64/0xd4
[   42.215411] [<90000000011f434c>] schedule_timeout+0x88/0x188
[   42.221115] [<90000000009c36d0>] io_wqe_worker+0x184/0x350
[   42.226645] [<9000000000221cf0>] ret_from_kernel_thread+0xc/0x9c

This can be easily triggered by ltp testcase syscalls/io_uring02 and it
can also be easily fixed by clearing the FPU/SIMD thread info flags for
kernel threads in copy_thread().

Cc: stable@vger.kernel.org
Reported-by: Qi Hu <huqi@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/process.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/loongarch/kernel/process.c
+++ b/arch/loongarch/kernel/process.c
@@ -152,7 +152,7 @@ int copy_thread(struct task_struct *p, c
 		childregs->csr_crmd = p->thread.csr_crmd;
 		childregs->csr_prmd = p->thread.csr_prmd;
 		childregs->csr_ecfg = p->thread.csr_ecfg;
-		return 0;
+		goto out;
 	}
 
 	/* user thread */
@@ -171,14 +171,15 @@ int copy_thread(struct task_struct *p, c
 	 */
 	childregs->csr_euen = 0;
 
+	if (clone_flags & CLONE_SETTLS)
+		childregs->regs[2] = tls;
+
+out:
 	clear_tsk_thread_flag(p, TIF_USEDFPU);
 	clear_tsk_thread_flag(p, TIF_USEDSIMD);
 	clear_tsk_thread_flag(p, TIF_LSX_CTX_LIVE);
 	clear_tsk_thread_flag(p, TIF_LASX_CTX_LIVE);
 
-	if (clone_flags & CLONE_SETTLS)
-		childregs->regs[2] = tls;
-
 	return 0;
 }
 


