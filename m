Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DABAF4CF727
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbiCGJos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240602AbiCGJlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F644B43A;
        Mon,  7 Mar 2022 01:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADBBD60FF6;
        Mon,  7 Mar 2022 09:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AF6C340F4;
        Mon,  7 Mar 2022 09:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645865;
        bh=tgNigy6iluIbCmY3PIKN2TAhpdqPD7xQ2/sANhsu4tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=junW8Bo3SGds9qNJ9VJ7cDRCCxYuhF+puwRfzUFivJgxhLfCrDb1qenJoG8Osyxl9
         TKoH+FpiqDAzcD+bq/Ju832KVlODnod5uGG2R/VXKh6i4Kn0MTK9cht/lEpM4HQABx
         +ywZtvxRi7EiGUIRgEueSjVFmSRgH/VLg8WRuCqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/262] KVM: x86: Exit to userspace if emulation prepared a completion callback
Date:   Mon,  7 Mar 2022 10:16:44 +0100
Message-Id: <20220307091704.203349969@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Wenlong <houwenlong93@linux.alibaba.com>

[ Upstream commit adbfb12d4c4517a8adde23a7fc46538953d56eea ]

em_rdmsr() and em_wrmsr() return X86EMUL_IO_NEEDED if MSR accesses
required an exit to userspace. However, x86_emulate_insn() doesn't return
X86EMUL_*, so x86_emulate_instruction() doesn't directly act on
X86EMUL_IO_NEEDED; instead, it looks for other signals to differentiate
between PIO, MMIO, etc. causing RDMSR/WRMSR emulation not to
exit to userspace now.

Nevertheless, if the userspace_msr_exit_test testcase in selftests
is changed to test RDMSR/WRMSR with a forced emulation prefix,
the test passes.  What happens is that first userspace exit
information is filled but the userspace exit does not happen.
Because x86_emulate_instruction() returns 1, the guest retries
the instruction---but this time RIP has already been adjusted
past the forced emulation prefix, so the guest executes RDMSR/WRMSR
and the userspace exit finally happens.

Since the X86EMUL_IO_NEEDED path has provided a complete_userspace_io
callback, x86_emulate_instruction() can just return 0 if the
callback is not NULL. Then RDMSR/WRMSR instruction emulation will
exit to userspace directly, without the RDMSR/WRMSR vmexit.

Fixes: 1ae099540e8c7 ("KVM: x86: Allow deflecting unknown MSR accesses to user space")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <56f9df2ee5c05a81155e2be366c9dc1f7adc8817.1635842679.git.houwenlong93@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b76486702ded..8213f7fb71a7b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8068,6 +8068,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			writeback = false;
 		r = 0;
 		vcpu->arch.complete_userspace_io = complete_emulated_mmio;
+	} else if (vcpu->arch.complete_userspace_io) {
+		writeback = false;
+		r = 0;
 	} else if (r == EMULATION_RESTART)
 		goto restart;
 	else
-- 
2.34.1



