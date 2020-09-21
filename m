Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924B5272DA1
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgIUQls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728308AbgIUQl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B4B123998;
        Mon, 21 Sep 2020 16:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706487;
        bh=neZeJyo/vrJWlGXfGrMWd1Maus0uo5g1Kgtkd1PsBV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sj7SHi9veREEmnEF4T2+bwC/XnpMdpIEPPZsE7gHFm79T73Z3kRpWR4ozH5C0F3Rg
         gwJibyFDqHXlvmU18/abDOzHXvA2eU5B+syyvcgRVTSXxosYhtQ+yOvE8beiI8w+wm
         bUI3NMVoizXSoeCoruSi/VHJfNbfyQq5StH58x4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/49] KVM: MIPS: Change the definition of kvm type
Date:   Mon, 21 Sep 2020 18:28:09 +0200
Message-Id: <20200921162035.764498563@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

[ Upstream commit 15e9e35cd1dec2bc138464de6bf8ef828df19235 ]

MIPS defines two kvm types:

 #define KVM_VM_MIPS_TE          0
 #define KVM_VM_MIPS_VZ          1

In Documentation/virt/kvm/api.rst it is said that "You probably want to
use 0 as machine type", which implies that type 0 be the "automatic" or
"default" type. And, in user-space libvirt use the null-machine (with
type 0) to detect the kvm capability, which returns "KVM not supported"
on a VZ platform.

I try to fix it in QEMU but it is ugly:
https://lists.nongnu.org/archive/html/qemu-devel/2020-08/msg05629.html

And Thomas Huth suggests me to change the definition of kvm type:
https://lists.nongnu.org/archive/html/qemu-devel/2020-09/msg03281.html

So I define like this:

 #define KVM_VM_MIPS_AUTO        0
 #define KVM_VM_MIPS_VZ          1
 #define KVM_VM_MIPS_TE          2

Since VZ and TE cannot co-exists, using type 0 on a TE platform will
still return success (so old user-space tools have no problems on new
kernels); the advantage is that using type 0 on a VZ platform will not
return failure. So, the only problem is "new user-space tools use type
2 on old kernels", but if we treat this as a kernel bug, we can backport
this patch to old stable kernels.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Message-Id: <1599734031-28746-1-git-send-email-chenhc@lemote.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kvm/mips.c     | 2 ++
 include/uapi/linux/kvm.h | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index e7f5ef6bed0fe..79485790f7b56 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -131,6 +131,8 @@ void kvm_arch_check_processor_compat(void *rtn)
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	switch (type) {
+	case KVM_VM_MIPS_AUTO:
+		break;
 #ifdef CONFIG_KVM_MIPS_VZ
 	case KVM_VM_MIPS_VZ:
 #else
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 66ce6659ecb69..c297abc4e6697 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -746,9 +746,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_PPC_HV 1
 #define KVM_VM_PPC_PR 2
 
-/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
-#define KVM_VM_MIPS_TE		0
+/* on MIPS, 0 indicates auto, 1 forces VZ ASE, 2 forces trap & emulate */
+#define KVM_VM_MIPS_AUTO	0
 #define KVM_VM_MIPS_VZ		1
+#define KVM_VM_MIPS_TE		2
 
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
-- 
2.25.1



