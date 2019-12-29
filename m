Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B179C12C333
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfL2PvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:51:18 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:59401 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbfL2PvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:51:18 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E4EC5444;
        Sun, 29 Dec 2019 10:51:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:51:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lTNNUX
        H54z7NnwTsDwvskqoKOURS0mnqcQlSbPcffCw=; b=bNcG2ZNi1xoffAPpDrJ4ic
        AjfSofYAhFK7w4XnmHtDzzYnBeZ9OS4PLpgmGrr07xXC01AyxlZonIFuGYrsTMs2
        NyrKqoGip6e+/HzFh+iqP11luROx6he8+Cez5yb60jIFCH9lTh0ZWxoaizAoASXE
        aP5+M6Jr5XiPI0ETTecBeldd8s50R5A+uBVHftdn4gkcPyxQWoYAz9qJ3L2ViMY4
        TtMb7B4epjB+FpDrcC6pgW2ZUpuIi/JUibHChGvcyhqsGoj63GXOW7r1Euj7CBTv
        8YHow1Hwd5EQrgiu2AIXMetKQqXwoA6r7dBP/x8gMl5dlp1hvzW2cDidT2kidjqQ
        ==
X-ME-Sender: <xms:dMsIXt8ZZkrnIKa7wPVPALgZO-sHhNeffhiuRz9bv7akv1ndTlbX9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:dMsIXl9TcEVhscDRJKzQ9IKH3yuab4oHxqJAn9pTUotDwgM1olR6uA>
    <xmx:dMsIXmDG-Xq9-STDM9tSNInKozrTk8C_BC_SNHgZqmzfuQ1woYKxlQ>
    <xmx:dMsIXlzAEvQJv4zBueqY-GQAT5txfRKsI5UkLa7ACJzG7wgMXv_Q-g>
    <xmx:dMsIXuPXaC5Wjpv9lxt6h-mu4Wt7j4v-NDkbp6JGajin52Q2gLbh4Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3065F3060B17;
        Sun, 29 Dec 2019 10:51:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] kvm: x86: Host feature SSBD doesn't imply guest feature" failed to apply to 4.9-stable tree
To:     jmattson@google.com, ebiggers@kernel.org, jacobhxu@google.com,
        pbonzini@redhat.com, pshier@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:51:07 +0100
Message-ID: <157763466799103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

