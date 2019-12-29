Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22FD112C332
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfL2PvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:51:15 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:52425 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbfL2PvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:51:15 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 205C53C0;
        Sun, 29 Dec 2019 10:51:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:51:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ulC3dd
        omjELkjV8ZH7JGJa4AhhdSzbvHaXPmi2FBgM4=; b=UTSszm9CGkN8rusOtVlNky
        JSyTEobLZqOLPwsOnMwd3C1pkJeZ0GdQpoSTIQVJT+dLGGeUGmYIBZGgstRbwPzt
        UOrqEfzKQ4Wv2gG4dh8CYgUYTa6gkAjj5SOTQehnHFc/ztm2/yJdK3h2ljCpRIvI
        GWI4n5ycYenh06/qZIdp0sV2ErrXkS33xX014ClFcBQjiqbLnc1dtjz8frkwwAzN
        gU/am6DJbs8R2at0xD+ilbpSgYMMdqyDQVvwOe5ddg5KrQ+J342akIRFumRUaN+X
        1vANFlSkW8H64LmfzL1PHn/dtAcT/Vks2WwoJXNJUkI80nDgD7AD6gJfyZap7nPQ
        ==
X-ME-Sender: <xms:ccsIXlGMZUfNNuP6rI8UO6IQsyox_-a3ae-KfnGBOZ57Is_Uwt8u6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:ccsIXrY7qiIbIuuoue3NPE-6XS8-EdyuJ1vrcsotH09XnqEGuHW6ew>
    <xmx:ccsIXqHFcMpD1_wxZUgO7gixS9Jo-9Cvr5GDiM4kYcZ7ByeXB6zBKQ>
    <xmx:ccsIXowR2aQpB-ceMjmVX7xC6N35Yvv27Cu9MZASn44-BjOgo7mnGQ>
    <xmx:ccsIXoT_Jx_pTc7avXuciZS1s_istvCFTNWUyLgZl1x4jvsN3Sq-Ew>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 45E173060B17;
        Sun, 29 Dec 2019 10:51:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] kvm: x86: Host feature SSBD doesn't imply guest feature" failed to apply to 4.19-stable tree
To:     jmattson@google.com, ebiggers@kernel.org, jacobhxu@google.com,
        pbonzini@redhat.com, pshier@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:51:06 +0100
Message-ID: <1577634666179186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 396d2e878f92ec108e4293f1c77ea3bc90b414ff Mon Sep 17 00:00:00 2001
From: Jim Mattson <jmattson@google.com>
Date: Fri, 13 Dec 2019 16:15:15 -0800
Subject: [PATCH] kvm: x86: Host feature SSBD doesn't imply guest feature
 SPEC_CTRL_SSBD

The host reports support for the synthetic feature X86_FEATURE_SSBD
when any of the three following hardware features are set:
  CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31]
  CPUID.80000008H:EBX.AMD_SSBD[bit 24]
  CPUID.80000008H:EBX.VIRT_SSBD[bit 25]

Either of the first two hardware features implies the existence of the
IA32_SPEC_CTRL MSR, but CPUID.80000008H:EBX.VIRT_SSBD[bit 25] does
not. Therefore, CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31] should only be
set in the guest if CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31] or
CPUID.80000008H:EBX.AMD_SSBD[bit 24] is set on the host.

Fixes: 0c54914d0c52a ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Jacob Xu <jacobhxu@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c0aa07487eb8..dd18aa6fa317 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -402,7 +402,8 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 			entry->edx |= F(SPEC_CTRL);
 		if (boot_cpu_has(X86_FEATURE_STIBP))
 			entry->edx |= F(INTEL_STIBP);
-		if (boot_cpu_has(X86_FEATURE_SSBD))
+		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+		    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 			entry->edx |= F(SPEC_CTRL_SSBD);
 		/*
 		 * We emulate ARCH_CAPABILITIES in software even

