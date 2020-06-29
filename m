Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C037920E6E2
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404256AbgF2Vvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgF2Sfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA4952479A;
        Mon, 29 Jun 2020 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444105;
        bh=R2j6V0eZaLlrba2WbCE1v/ST4757gs8/EMzZo0IjirQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1OviV8XQhH3uAJBDH2eMw9RXdFn+G6UwWSUG3wPMJuhb62mebPXPCgUXkA40SUD3
         2bJaN6Uhl1hpdCYwIKErV80N1WIJnNUfzcCg33+n+o2yT344dLGtzXhAS1tlTfpiAu
         OjG5q4TWYr1oWM3+tqYSGp6P9+n254akVMpDEdoU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 216/265] kvm: lapic: fix broken vcpu hotplug
Date:   Mon, 29 Jun 2020 11:17:29 -0400
Message-Id: <20200629151818.2493727-217-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Mammedov <imammedo@redhat.com>

commit af28dfacbe00d53df5dec2bf50640df33138b1fe upstream.

Guest fails to online hotplugged CPU with error
  smpboot: do_boot_cpu failed(-1) to wakeup CPU#4

It's caused by the fact that kvm_apic_set_state(), which used to call
recalculate_apic_map() unconditionally and pulled hotplugged CPU into
apic map, is updating map conditionally on state changes.  In this case
the APIC map is not considered dirty and the is not updated.

Fix the issue by forcing unconditional update from kvm_apic_set_state(),
like it used to be.

Fixes: 4abaffce4d25a ("KVM: LAPIC: Recalculate apic map in batch")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Message-Id: <20200622160830.426022-1-imammedo@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9af25c97612a7..8967e320a9784 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2512,6 +2512,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
+	apic->vcpu->kvm->arch.apic_map_dirty = true;
 	kvm_recalculate_apic_map(vcpu->kvm);
 	kvm_apic_set_version(vcpu);
 
-- 
2.25.1

