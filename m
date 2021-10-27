Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8926243CC05
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 16:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbhJ0OZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 10:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242517AbhJ0OYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 10:24:22 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D59C061570
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 07:21:56 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m26so2895300pff.3
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 07:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LcgMg779T/gdBXlrNU3YHrX7Gk6gacaR5KBJWJtm+pg=;
        b=aZB0T1FFZxSGyIpj59SsCIORPIGrEoeVOClNLIUCiUOsG5zahPLh7gqzsZH/29YSPU
         C7+5bsEj80wNpWA5naRezLjvxAifOnrOsScbYdvczPPmY0CIj7bTgPvZt17L8o8lqq/p
         fVT87s96rdixTjLDQ2F5MfYqhemxGZyJUnxj/OFZ1dmAqnGR51QhkCSG/x1Ncvzs8sp9
         MJTisyKwWzCzSjBmf1VpUTNKHeR/6d0DyiQ9hfOGH+j9iAk+Yh6hUzuRnOusxD+PmdXm
         Vta71sU1BItic0lHoRmoc97RnlWO0esPgWRA9CIskTN5a+J4cOvJWsIsKDfprIJIG3Dh
         Os7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LcgMg779T/gdBXlrNU3YHrX7Gk6gacaR5KBJWJtm+pg=;
        b=IOxkLNdUci3xdx3VWCJ4G/RkrfWpk7Kk08pGwyLdbClRXgIWvDYGCVKDMOQ3CVEpIw
         F6MlFE1mc6wjeXH+j89uRvsHWGd2vhv4CEu4wm+s/rxEoEFjx2RUYzrZf+zqIMrfQ6zK
         8z55kc6d2eJtGhCOdwZZo3w4171KcizwWwF4qh0w0KXEkV7cRRQQdgjzcIBqVCRrS0GI
         ZMJBPcNFdrXjJfEz3Kjsu6KSAmSQc6TXKyVeq+nVeDLZMpILxiSiixjFid+nF/jq2Fld
         EK7aWDbK4YvrLLPhRboZiOF8mmhG8Py7ZheDY0O9szQ/1bimHr7WSefUNcjg3G9ftfLR
         Tuyg==
X-Gm-Message-State: AOAM530et06+WosfCcwDsyv5xspR+3uJmygoGzfhPVcTiXc+JnEFXXSI
        BFeAu00CcIKpVnzs6l/zsBWtFlLVrgA=
X-Google-Smtp-Source: ABdhPJy+gtXfVi2Tyiqe+BeTvidQTvDcUYUelFUBl7Qe7/pxsIKAYTZ/yS6QFsJsrvKFw03g9IHYjA==
X-Received: by 2002:a63:9308:: with SMTP id b8mr24176255pge.104.1635344516390;
        Wed, 27 Oct 2021 07:21:56 -0700 (PDT)
Received: from bobo.ibm.com ([118.208.159.180])
        by smtp.gmail.com with ESMTPSA id d14sm159979pfu.124.2021.10.27.07.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 07:21:56 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Laurent Vivier <lvivier@redhat.com>, stable@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3] KVM: PPC: Tick accounting should defer vtime accounting 'til after IRQ handling
Date:   Thu, 28 Oct 2021 00:21:50 +1000
Message-Id: <20211027142150.3711582-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Vivier <lvivier@redhat.com>

Commit 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest
context before enabling irqs") moved guest_exit() into the interrupt
protected area to avoid wrong context warning (or worse). The problem is
that tick-based time accounting has not yet been updated at this point
(because it depends on the timer interrupt firing), so the guest time
gets incorrectly accounted to system time.

To fix the problem, follow the x86 fix in commit 160457140187 ("Defer
vtime accounting 'til after IRQ handling"), and allow host IRQs to run
before accounting the guest exit time.

In the case vtime accounting is enabled, this is not required because TB
is used directly for accounting.

Before this patch, with CONFIG_TICK_CPU_ACCOUNTING=y in the host and a
guest running a kernel compile, the 'guest' fields of /proc/stat are
stuck at zero. With the patch they can be observed increasing roughly as
expected.

Fixes: e233d54d4d97 ("KVM: booke: use __kvm_guest_exit")
Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs")
Cc: <stable@vger.kernel.org> # 5.12
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
[np: only required for tick accounting, add Book3E fix, tweak changelog]
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v2:
- I took over the patch with Laurent's blessing.
- Changed to avoid processing IRQs if we do have vtime accounting
  enabled.
- Changed so in either case the accounting is called with irqs disabled.
- Added similar Book3E fix.
- Rebased on upstream, tested, observed bug and confirmed fix.

 arch/powerpc/kvm/book3s_hv.c | 30 ++++++++++++++++++++++++++++--
 arch/powerpc/kvm/booke.c     | 16 +++++++++++++++-
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2acb1c96cfaf..7b74fc0a986b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3726,7 +3726,20 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 
 	kvmppc_set_host_core(pcpu);
 
-	guest_exit_irqoff();
+	context_tracking_guest_exit();
+	if (!vtime_accounting_enabled_this_cpu()) {
+		local_irq_enable();
+		/*
+		 * Service IRQs here before vtime_account_guest_exit() so any
+		 * ticks that occurred while running the guest are accounted to
+		 * the guest. If vtime accounting is enabled, accounting uses
+		 * TB rather than ticks, so it can be done without enabling
+		 * interrupts here, which has the problem that it accounts
+		 * interrupt processing overhead to the host.
+		 */
+		local_irq_disable();
+	}
+	vtime_account_guest_exit();
 
 	local_irq_enable();
 
@@ -4510,7 +4523,20 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	kvmppc_set_host_core(pcpu);
 
-	guest_exit_irqoff();
+	context_tracking_guest_exit();
+	if (!vtime_accounting_enabled_this_cpu()) {
+		local_irq_enable();
+		/*
+		 * Service IRQs here before vtime_account_guest_exit() so any
+		 * ticks that occurred while running the guest are accounted to
+		 * the guest. If vtime accounting is enabled, accounting uses
+		 * TB rather than ticks, so it can be done without enabling
+		 * interrupts here, which has the problem that it accounts
+		 * interrupt processing overhead to the host.
+		 */
+		local_irq_disable();
+	}
+	vtime_account_guest_exit();
 
 	local_irq_enable();
 
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 977801c83aff..8c15c90dd3a9 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1042,7 +1042,21 @@ int kvmppc_handle_exit(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	}
 
 	trace_kvm_exit(exit_nr, vcpu);
-	guest_exit_irqoff();
+
+	context_tracking_guest_exit();
+	if (!vtime_accounting_enabled_this_cpu()) {
+		local_irq_enable();
+		/*
+		 * Service IRQs here before vtime_account_guest_exit() so any
+		 * ticks that occurred while running the guest are accounted to
+		 * the guest. If vtime accounting is enabled, accounting uses
+		 * TB rather than ticks, so it can be done without enabling
+		 * interrupts here, which has the problem that it accounts
+		 * interrupt processing overhead to the host.
+		 */
+		local_irq_disable();
+	}
+	vtime_account_guest_exit();
 
 	local_irq_enable();
 
-- 
2.23.0

