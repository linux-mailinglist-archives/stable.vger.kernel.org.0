Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442CE268DDC
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 16:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgINOff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 10:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:32912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgINNFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E79032224C;
        Mon, 14 Sep 2020 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088701;
        bh=CecopbIxRuxj/S1S8shXfRQpmD8h2mSpBBGt+VGBdOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWwg+A9PvyD4P3zj1oy45b3LHGRaiHWijvDfffa1A+8Gd86WJ6JrMivYFdHxpAGoB
         0pPXQzLJScTfZuRNavnb86KtdYY3+I+l4e4WVXC6CU8mvUw9YuEljgaHDfRznRYhBq
         oMg+iJTy31rJtAwZL+YWdb+0khdc2aEDdD0YkAeI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/22] KVM: MIPS: Change the definition of kvm type
Date:   Mon, 14 Sep 2020 09:04:34 -0400
Message-Id: <20200914130434.1804478-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130434.1804478-1-sashal@kernel.org>
References: <20200914130434.1804478-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index 1109924560d8c..b22a3565e1330 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -131,6 +131,8 @@ int kvm_arch_check_processor_compat(void)
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	switch (type) {
+	case KVM_VM_MIPS_AUTO:
+		break;
 #ifdef CONFIG_KVM_MIPS_VZ
 	case KVM_VM_MIPS_VZ:
 #else
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e735bc4075dc7..1b6b8e05868dd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -768,9 +768,10 @@ struct kvm_ppc_resize_hpt {
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

