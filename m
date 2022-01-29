Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29E94A2FC4
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 14:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243103AbiA2N1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 08:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243032AbiA2N1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 08:27:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092D3C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 05:27:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B93FBB827B6
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 13:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D890EC340E5;
        Sat, 29 Jan 2022 13:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643462868;
        bh=tT3UqIFN+7n2fSY1jHMwKF8I2lnx5Zmhl33TbBIg+IE=;
        h=Subject:To:Cc:From:Date:From;
        b=sUtmcK3P0WSk9Vrz0o27C5HjAcibmRzKsCOPUIOyhe2ZTKPaNyoIBRCBOEdLKYqq3
         hUNlrLwFFNZAC5UE9xM86pr4XDH9+fLozqaAoZydFOWRec5R4S+Ut7iR95/p4GBoby
         wYcpnKBhuI48cwWIB15IIjASGiDnpuDvdj2zw+X8=
Subject: FAILED: patch "[PATCH] KVM: x86: Update vCPU's runtime CPUID on write to" failed to apply to 4.19-stable tree
To:     likexu@tencent.com, pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 14:27:37 +0100
Message-ID: <16434628578647@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

