Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747295013F6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiDNNgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344157AbiDNNar (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:30:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BA01D3;
        Thu, 14 Apr 2022 06:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0404D619DA;
        Thu, 14 Apr 2022 13:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A45BC385A1;
        Thu, 14 Apr 2022 13:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942901;
        bh=WGzA0ctAcwdby+M4vYAbQfqFHtsHBqGitgfb3nXrlIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p41kG2VLfoVTbMPYRDsaDFwUcqkPP4wdNFUyNtYd83RtL6UPtI0axMEf4zRsjzRb4
         uAXksG6/ieNxAYY0HGu7Ohr3SYLRtEYyL2P7qNWvnQ6r54i5Fl4b/gR2TJg0yZ6s8s
         Ck1vVR58WFUO4NIiEYLg1/dzJkKW2qsouLJhit+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 302/338] KVM: arm64: Check arm64_get_bp_hardening_data() didnt return NULL
Date:   Thu, 14 Apr 2022 15:13:25 +0200
Message-Id: <20220414110847.480494699@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: James Morse <james.morse@arm.com>

Will reports that with CONFIG_EXPERT=y and CONFIG_HARDEN_BRANCH_PREDICTOR=n,
the kernel dereferences a NULL pointer during boot:

[    2.384444] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[    2.384461] pstate: 20400085 (nzCv daIf +PAN -UAO)
[    2.384472] pc : cpu_hyp_reinit+0x114/0x30c
[    2.384476] lr : cpu_hyp_reinit+0x80/0x30c

[    2.384529] Call trace:
[    2.384533]  cpu_hyp_reinit+0x114/0x30c
[    2.384537]  _kvm_arch_hardware_enable+0x30/0x54
[    2.384541]  flush_smp_call_function_queue+0xe4/0x154
[    2.384544]  generic_smp_call_function_single_interrupt+0x10/0x18
[    2.384549]  ipi_handler+0x170/0x2b0
[    2.384555]  handle_percpu_devid_fasteoi_ipi+0x120/0x1cc
[    2.384560]  __handle_domain_irq+0x9c/0xf4
[    2.384563]  gic_handle_irq+0x6c/0xe4
[    2.384566]  el1_irq+0xf0/0x1c0
[    2.384570]  arch_cpu_idle+0x28/0x44
[    2.384574]  do_idle+0x100/0x2a8
[    2.384577]  cpu_startup_entry+0x20/0x24
[    2.384581]  secondary_start_kernel+0x1b0/0x1cc
[    2.384589] Code: b9469d08 7100011f 540003ad 52800208 (f9400108)
[    2.384600] ---[ end trace 266d08dbf96ff143 ]---
[    2.385171] Kernel panic - not syncing: Fatal exception in interrupt

In this configuration arm64_get_bp_hardening_data() returns NULL.
Add a check in kvm_get_hyp_vector().

Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/linux-arm-kernel/20220408120041.GB27685@willie-the-truck/
Fixes: a68912a3ae3 ("KVM: arm64: Add templates for BHB mitigation sequences")
Cc: stable@vger.kernel.org # 4.19
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 44d3fdbcdf62..0243b6d22453 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -439,7 +439,8 @@ static inline void *kvm_get_hyp_vector(void)
 	int slot = -1;
 
 	if ((cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) ||
-	     cpus_have_const_cap(ARM64_SPECTRE_BHB)) && data->template_start) {
+	     cpus_have_const_cap(ARM64_SPECTRE_BHB)) &&
+	    data && data->template_start) {
 		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs_start));
 		slot = data->hyp_vectors_slot;
 	}
-- 
2.35.1



