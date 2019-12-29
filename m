Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2614E12C334
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfL2PvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:51:19 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:36075 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbfL2PvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:51:19 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 5C59142B;
        Sun, 29 Dec 2019 10:51:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:51:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cBQaIV
        oMcUU2fBruz6icR3wIYw8NZ+AnYIPu3i5CR78=; b=ovrlLTFmKIoI0jtYPC7oKr
        oEf3JURtMiJItovqJrmVDcUEBYE193c1mp9+agwqUJB2WanwMOGp0CT6StAfQvFk
        b6v7CIj7PkhV4ACmhiFQF7gbE6uJO8KPEoy1rm3CIpasjlDtbIsqHNRtP/usvEGp
        b+Uxv8zOw2G2E8K8wjEw4bdvuwbsRglKC640okJcJ9J8gE8yzaIqypm9PgVO+bxJ
        feCiIIpbFv57fIXNspN1O7/EVHPoEoFCXMlDnPFWC7esnWuVjaXw5zjfwhyk7lyk
        g9mSiQ43yf/eUowCpFRgri5cQeoxVKFGnlGFAe/+/jFqNGD4Mzyr/rZMAT+HybuQ
        ==
X-ME-Sender: <xms:dcsIXmA-4VcscdIbBkkM3jJY21FUf8OJBsev0kAIDIjYa4ODYTPVYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:dcsIXo8pNdLySRaa-h5FA-HKAutFqfqUPJhibLsCUd49psTzitHIEw>
    <xmx:dcsIXqCbunnbOQuL8m70edQZaebsTZY5rG9tMm2st2s3T6PSmOgyHQ>
    <xmx:dcsIXlTSOxoNiWB9Dub4PvC0CqrpI7UsmgD4i2qOAvhbmLvro-6ziw>
    <xmx:dssIXooS9vj6Q8Sw5bBU82R5XAOO5C4vhcM41Q814Hkrjs4h2SkJtQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 966F93060B17;
        Sun, 29 Dec 2019 10:51:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] kvm: x86: Host feature SSBD doesn't imply guest feature" failed to apply to 4.14-stable tree
To:     jmattson@google.com, ebiggers@kernel.org, jacobhxu@google.com,
        pbonzini@redhat.com, pshier@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:51:07 +0100
Message-ID: <157763466722642@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

