Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1067827CD43
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgI2Mm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729129AbgI2LKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:10:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 711A321D46;
        Tue, 29 Sep 2020 11:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377803;
        bh=RkAgZ0llnIywDojBShVlZTmNEJcf13A5yJpo8vi/diU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wp6gLZfrTKuNimrQonCZ+HmyINOB+p6QVjEGr7Jv8kqilqqv3rt88Fc7sBzVP8RpU
         N59JpTSkpN/OrZyJniaPw2ueNq5kBntIbas8GDASVGwSHjwOaXKf/aCeuEki9PGZuj
         tQUhmahKOybI1Xp5tLimL7V5WFpEv1OiBf09oRk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Rutherford <srutherford@google.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 077/121] KVM: Remove CREATE_IRQCHIP/SET_PIT2 race
Date:   Tue, 29 Sep 2020 13:00:21 +0200
Message-Id: <20200929105933.995631521@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6b7faa14c27bb..3c0f9be107e42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4263,10 +4263,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
@@ -4286,10 +4289,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
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



