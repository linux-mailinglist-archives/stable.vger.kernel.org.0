Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBC22F6C8
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfE3E7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbfE3DJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:43 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B33A24492;
        Thu, 30 May 2019 03:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185782;
        bh=Bx422FIl1dT2IwAkDhd7kxjiKoK4XC/zVmRIsYSeuu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWAsvly/zPfB5MCv7hLPJI9fsiie9AtBgYc3Q5OpX3Rmx3s2p187+B0Hyb1stgV2l
         ivpYUjT1MeW8bSHp/O7HWh7yQjb3ngT+dhw66RmoeVByT6t2W/3OMfOL+DZugd8Fc/
         PVIlqlDAqv8Q278mW4kIuA/YMq4I8H2+sVTdTkGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        kvm@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org
Subject: [PATCH 5.1 005/405] x86/kvm/pmu: Set AMDs virt PMU version to 1
Date:   Wed, 29 May 2019 20:00:03 -0700
Message-Id: <20190530030540.630618892@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit a80c4ec10ed9632c44c829452dc40a0443ff4e85 upstream.

After commit:

  672ff6cff80c ("KVM: x86: Raise #GP when guest vCPU do not support PMU")

my AMD guests started #GPing like this:

  general protection fault: 0000 [#1] PREEMPT SMP
  CPU: 1 PID: 4355 Comm: bash Not tainted 5.1.0-rc6+ #3
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  RIP: 0010:x86_perf_event_update+0x3b/0xa0

with Code: pointing to RDPMC. It is RDPMC because the guest has the
hardware watchdog CONFIG_HARDLOCKUP_DETECTOR_PERF enabled which uses
perf. Instrumenting kvm_pmu_rdpmc() some, showed that it fails due to:

  if (!pmu->version)
  	return 1;

which the above commit added. Since AMD's PMU leaves the version at 0,
that causes the #GP injection into the guest.

Set pmu->version arbitrarily to 1 and move it above the non-applicable
struct kvm_pmu members.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: kvm@vger.kernel.org
Cc: Liran Alon <liran.alon@oracle.com>
Cc: Mihai Carabas <mihai.carabas@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
Fixes: 672ff6cff80c ("KVM: x86: Raise #GP when guest vCPU do not support PMU")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/pmu_amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -269,10 +269,10 @@ static void amd_pmu_refresh(struct kvm_v
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->nr_arch_fixed_counters = 0;
-	pmu->version = 0;
 	pmu->global_status = 0;
 }
 


