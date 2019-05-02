Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B2C11DD6
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEBPe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729109AbfEBPcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:32:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F5F820C01;
        Thu,  2 May 2019 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811126;
        bh=65ruzGAENGirINjoKdB+RVXEuqlPR6pfOjvTO9q47JE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBr86lxsktL/c+5BGZskf999eeQMaLUmlSDDck3wPGM4vtchMglNX9zL9g22QMDFK
         7Yms0jrcRZ+8qhBwFeAbEkdMNUVWqqqqukd2blCtcLxeKFA3diIXbFxCIZdirGkuD9
         S2rJYyVQJI9ooazTJAI4bNrbEt/i/PUoqUlzO4PY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 085/101] x86/kvm/hyper-v: avoid spurious pending stimer on vCPU init
Date:   Thu,  2 May 2019 17:21:27 +0200
Message-Id: <20190502143345.557664615@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 013cc6ebbf41496ce4badedd71ea6d4a6d198c14 ]

When userspace initializes guest vCPUs it may want to zero all supported
MSRs including Hyper-V related ones including HV_X64_MSR_STIMERn_CONFIG/
HV_X64_MSR_STIMERn_COUNT. With commit f3b138c5d89a ("kvm/x86: Update SynIC
timers on guest entry only") we began doing stimer_mark_pending()
unconditionally on every config change.

The issue I'm observing manifests itself as following:
- Qemu writes 0 to STIMERn_{CONFIG,COUNT} MSRs and marks all stimers as
  pending in stimer_pending_bitmap, arms KVM_REQ_HV_STIMER;
- kvm_hv_has_stimer_pending() starts returning true;
- kvm_vcpu_has_events() starts returning true;
- kvm_arch_vcpu_runnable() starts returning true;
- when kvm_arch_vcpu_ioctl_run() gets into
  (vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED) case:
  - kvm_vcpu_block() gets in 'kvm_vcpu_check_block(vcpu) < 0' and returns
    immediately, avoiding normal wait path;
  - -EAGAIN is returned from kvm_arch_vcpu_ioctl_run() immediately forcing
    userspace to retry.

So instead of normal wait path we get a busy loop on all secondary vCPUs
before they get INIT signal. This seems to be undesirable, especially given
that this happens even when Hyper-V extensions are not used.

Generally, it seems to be pointless to mark an stimer as pending in
stimer_pending_bitmap and arm KVM_REQ_HV_STIMER as the only thing
kvm_hv_process_stimers() will do is clear the corresponding bit. We may
just not mark disabled timers as pending instead.

Fixes: f3b138c5d89a ("kvm/x86: Update SynIC timers on guest entry only")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/x86/kvm/hyperv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 89d20ed1d2e8..371c669696d7 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -526,7 +526,9 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 		new_config.enable = 0;
 	stimer->config.as_uint64 = new_config.as_uint64;
 
-	stimer_mark_pending(stimer, false);
+	if (stimer->config.enable)
+		stimer_mark_pending(stimer, false);
+
 	return 0;
 }
 
@@ -542,7 +544,10 @@ static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 		stimer->config.enable = 0;
 	else if (stimer->config.auto_enable)
 		stimer->config.enable = 1;
-	stimer_mark_pending(stimer, false);
+
+	if (stimer->config.enable)
+		stimer_mark_pending(stimer, false);
+
 	return 0;
 }
 
-- 
2.19.1



