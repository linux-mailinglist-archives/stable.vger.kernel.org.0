Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE217615866
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiKBCvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiKBCvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:51:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDD321E1B
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB812B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78D7C433D6;
        Wed,  2 Nov 2022 02:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357478;
        bh=GdGLe9uqOO2Oj8Z421tuQludSHEJRy8nxD4k0b7fgW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYT8K+LFju9W3gFc7pJTlIN5Pb4YBjm2+FDvgKGZT6A2diX+s61lqaHw1rshdmv8g
         PnzB9nBlCGv8vbTvDYDYR/nwJj7KiaEYIB69jgSYJaU5+SZhsDh7a3JJCL/LoJVYsh
         TjZtR4oJsveP/zT/7AmCn4EVA0wSdI5pV8OOEnUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Yao <yuan.yao@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 176/240] x86/fpu: Fix copy_xstate_to_uabi() to copy init states correctly
Date:   Wed,  2 Nov 2022 03:32:31 +0100
Message-Id: <20221102022115.368113314@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chang S. Bae <chang.seok.bae@intel.com>

[ Upstream commit 471f0aa7fa64e23766a1473b32d9ec3f0718895a ]

When an extended state component is not present in fpstate, but in init
state, the function copies from init_fpstate via copy_feature().

But, dynamic states are not present in init_fpstate because of all-zeros
init states. Then retrieving them from init_fpstate will explode like this:

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 ...
 RIP: 0010:memcpy_erms+0x6/0x10
  ? __copy_xstate_to_uabi_buf+0x381/0x870
  fpu_copy_guest_fpstate_to_uabi+0x28/0x80
  kvm_arch_vcpu_ioctl+0x14c/0x1460 [kvm]
  ? __this_cpu_preempt_check+0x13/0x20
  ? vmx_vcpu_put+0x2e/0x260 [kvm_intel]
  kvm_vcpu_ioctl+0xea/0x6b0 [kvm]
  ? kvm_vcpu_ioctl+0xea/0x6b0 [kvm]
  ? __fget_light+0xd4/0x130
  __x64_sys_ioctl+0xe3/0x910
  ? debug_smp_processor_id+0x17/0x20
  ? fpregs_assert_state_consistent+0x27/0x50
  do_syscall_64+0x3f/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Adjust the 'mask' to zero out the userspace buffer for the features that
are not available both from fpstate and from init_fpstate.

The dynamic features depend on the compacted XSAVE format. Ensure it is
enabled before reading XCOMP_BV in init_fpstate.

Fixes: 2308ee57d93d ("x86/fpu/amx: Enable the AMX feature in 64-bit mode")
Reported-by: Yuan Yao <yuan.yao@intel.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Yuan Yao <yuan.yao@intel.com>
Link: https://lore.kernel.org/lkml/BYAPR11MB3717EDEF2351C958F2C86EED95259@BYAPR11MB3717.namprd11.prod.outlook.com/
Link: https://lkml.kernel.org/r/20221021185844.13472-1-chang.seok.bae@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index e77cabfa802f..59e543b95a3c 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1125,6 +1125,15 @@ void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
 	 */
 	mask = fpstate->user_xfeatures;
 
+	/*
+	 * Dynamic features are not present in init_fpstate. When they are
+	 * in an all zeros init state, remove those from 'mask' to zero
+	 * those features in the user buffer instead of retrieving them
+	 * from init_fpstate.
+	 */
+	if (fpu_state_size_dynamic())
+		mask &= (header.xfeatures | xinit->header.xcomp_bv);
+
 	for_each_extended_xfeature(i, mask) {
 		/*
 		 * If there was a feature or alignment gap, zero the space
-- 
2.35.1



