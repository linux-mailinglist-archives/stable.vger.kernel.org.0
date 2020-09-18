Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E0026ED79
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgIRCUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbgIRCRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:17:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35FD623772;
        Fri, 18 Sep 2020 02:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395457;
        bh=xdwUc0AGqkQ7lHewx0MNU6XB17lx+iPqEKFLtXmoihk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0yjuKSaH52RoIxbdg30XjM4uVGHKBnr4423ed6vlu5pSBscMc4Vbyxpf5CESM6vgY
         ZE4m+vdVXjdxmBJJahuIiISTgx2HnmWMbaEAFUiDAUv3LKeIDItyAN3G5gmut5l3lG
         ew1L0fKn0ObeJm+FLHyVCiumUdWljDAkdJCYT8NI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Rutherford <srutherford@google.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 43/64] KVM: Remove CREATE_IRQCHIP/SET_PIT2 race
Date:   Thu, 17 Sep 2020 22:16:22 -0400
Message-Id: <20200918021643.2067895-43-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021643.2067895-1-sashal@kernel.org>
References: <20200918021643.2067895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Rutherford <srutherford@google.com>

[ Upstream commit 7289fdb5dcdbc5155b5531529c44105868a762f2 ]

Fixes a NULL pointer dereference, caused by the PIT firing an interrupt
before the interrupt table has been initialized.

SET_PIT2 can race with the creation of the IRQchip. In particular,
if SET_PIT2 is called with a low PIT timer period (after the creation of
the IOAPIC, but before the instantiation of the irq routes), the PIT can
fire an interrupt at an uninitialized table.

Signed-off-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Jon Cargille <jcargill@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Message-Id: <20200416191152.259434-1-jcargill@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 61fc92f92e0a0..ef920da075184 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4013,10 +4013,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&u.ps, argp, sizeof u.ps))
 			goto out;
+		mutex_lock(&kvm->lock);
 		r = -ENXIO;
 		if (!kvm->arch.vpit)
-			goto out;
+			goto set_pit_out;
 		r = kvm_vm_ioctl_set_pit(kvm, &u.ps);
+set_pit_out:
+		mutex_unlock(&kvm->lock);
 		break;
 	}
 	case KVM_GET_PIT2: {
@@ -4036,10 +4039,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&u.ps2, argp, sizeof(u.ps2)))
 			goto out;
+		mutex_lock(&kvm->lock);
 		r = -ENXIO;
 		if (!kvm->arch.vpit)
-			goto out;
+			goto set_pit2_out;
 		r = kvm_vm_ioctl_set_pit2(kvm, &u.ps2);
+set_pit2_out:
+		mutex_unlock(&kvm->lock);
 		break;
 	}
 	case KVM_REINJECT_CONTROL: {
-- 
2.25.1

