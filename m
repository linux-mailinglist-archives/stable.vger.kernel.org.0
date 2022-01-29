Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8367E4A2FC5
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 14:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243132AbiA2N1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 08:27:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54062 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243032AbiA2N1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 08:27:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C61660DB7
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 13:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D265C340E5;
        Sat, 29 Jan 2022 13:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643462872;
        bh=FN5CUIr7rkLl2QDHJZG/P+JFh/55KQTr1QJNnUIGA+Q=;
        h=Subject:To:Cc:From:Date:From;
        b=Bp5mk0B55F6m194WmqaMSgg6YbidfrHqrju0uz4JgUsH4TVgussfpujqQIOfohydl
         xyAN8ZG2uEIZjTkZk3t/jfaQoPTtze2GvHqgEHNBKP6hD6/iSQeQqIt5LmTgFxKc9g
         VKGPKCF4PVHBVYp+rJ3ayk6ZuA2TxWIfKRs7fy9E=
Subject: FAILED: patch "[PATCH] KVM: x86: Update vCPU's runtime CPUID on write to" failed to apply to 4.9-stable tree
To:     likexu@tencent.com, pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 14:27:38 +0100
Message-ID: <1643462858111200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4c282e51e4450b94680d6ca3b10f830483b1f243 Mon Sep 17 00:00:00 2001
From: Like Xu <likexu@tencent.com>
Date: Wed, 26 Jan 2022 17:22:25 +0000
Subject: [PATCH] KVM: x86: Update vCPU's runtime CPUID on write to
 MSR_IA32_XSS

Do a runtime CPUID update for a vCPU if MSR_IA32_XSS is written, as the
size in bytes of the XSAVE area is affected by the states enabled in XSS.

Fixes: 203000993de5 ("kvm: vmx: add MSR logic for XSAVES")
Cc: stable@vger.kernel.org
Signed-off-by: Like Xu <likexu@tencent.com>
[sean: split out as a separate patch, adjust Fixes tag]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220126172226.2298529-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b6d60c296eda..9c984eeed30c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3535,6 +3535,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~supported_xss)
 			return 1;
 		vcpu->arch.ia32_xss = data;
+		kvm_update_cpuid_runtime(vcpu);
 		break;
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)

