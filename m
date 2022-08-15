Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF52E594291
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349914AbiHOVwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350505AbiHOVva (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:51:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8461910650A;
        Mon, 15 Aug 2022 12:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B971C60FB9;
        Mon, 15 Aug 2022 19:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB774C433C1;
        Mon, 15 Aug 2022 19:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591970;
        bh=F+IUHW4HbX9SiRh8h0ul58D2aCwIe0rryQCeCZm0uYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vR0eogViHFZEpdDJMOT31uJWc3dDkpgT7EbJVgAkb5O1UOWme1eY3NZitLJ1dc/6Q
         ecwLH7wYscnU6ALN/BkEgZtwVqGtNTTvpjBRO9u4CWYG6v59BYay98+nN71rhUlfgr
         BQbO7Ttr4+eR3vw4rTGYi3RHepfVOWa9YnZhBCUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 0038/1157] KVM: x86/mmu: Treat NX as a valid SPTE bit for NPT
Date:   Mon, 15 Aug 2022 19:49:54 +0200
Message-Id: <20220815180440.965453015@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 6c6ab524cfae0799e55c82b2c1d61f1af0156f8d upstream.

Treat the NX bit as valid when using NPT, as KVM will set the NX bit when
the NX huge page mitigation is enabled (mindblowing) and trigger the WARN
that fires on reserved SPTE bits being set.

KVM has required NX support for SVM since commit b26a71a1a5b9 ("KVM: SVM:
Refuse to load kvm_amd if NX support is not available") for exactly this
reason, but apparently it never occurred to anyone to actually test NPT
with the mitigation enabled.

  ------------[ cut here ]------------
  spte = 0x800000018a600ee7, level = 2, rsvd bits = 0x800f0000001fe000
  WARNING: CPU: 152 PID: 15966 at arch/x86/kvm/mmu/spte.c:215 make_spte+0x327/0x340 [kvm]
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 10.48.0 01/27/2022
  RIP: 0010:make_spte+0x327/0x340 [kvm]
  Call Trace:
   <TASK>
   tdp_mmu_map_handle_target_level+0xc3/0x230 [kvm]
   kvm_tdp_mmu_map+0x343/0x3b0 [kvm]
   direct_page_fault+0x1ae/0x2a0 [kvm]
   kvm_tdp_page_fault+0x7d/0x90 [kvm]
   kvm_mmu_page_fault+0xfb/0x2e0 [kvm]
   npf_interception+0x55/0x90 [kvm_amd]
   svm_invoke_exit_handler+0x31/0xf0 [kvm_amd]
   svm_handle_exit+0xf6/0x1d0 [kvm_amd]
   vcpu_enter_guest+0xb6d/0xee0 [kvm]
   ? kvm_pmu_trigger_event+0x6d/0x230 [kvm]
   vcpu_run+0x65/0x2c0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x355/0x610 [kvm]
   kvm_vcpu_ioctl+0x551/0x610 [kvm]
   __se_sys_ioctl+0x77/0xc0
   __x64_sys_ioctl+0x1d/0x20
   do_syscall_64+0x44/0xa0
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
   </TASK>
  ---[ end trace 0000000000000000 ]---

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220723013029.1753623-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4567,7 +4567,7 @@ reset_tdp_shadow_zero_bits_mask(struct k
 
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-					context->root_role.level, false,
+					context->root_role.level, true,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					false, true);
 	else


