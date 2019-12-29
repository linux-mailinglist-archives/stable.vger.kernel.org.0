Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F7612C8FD
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387615AbfL2R6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387607AbfL2R6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0830206A4;
        Sun, 29 Dec 2019 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642328;
        bh=jjSDoosDC2f5Hfu0htQLEoNtBfuF1F+entclPo6rXTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nq1e6kNOEd5IQw5yVhIOezwGAFrHWFTR/rKe8DxTFW2iZ/rfmp4mMFj9GFf+RYxGJ
         6Ag7Or4SbvkzbeDHWpTcftxiCbS6VUfqWO/KtJWV2Lj4zEZVSpJnXiF4tgFrPlt41t
         wqqhZmdh74F9ZePBOgGevCaxNCGAUyDEJBcEfH7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Borislav Petkov <bp@suse.de>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, x86-ml <x86@kernel.org>
Subject: [PATCH 5.4 421/434] x86/MCE/AMD: Do not use rdmsr_safe_on_cpu() in smca_configure()
Date:   Sun, 29 Dec 2019 18:27:54 +0100
Message-Id: <20191229172731.058586083@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

commit 246ff09f89e54fdf740a8d496176c86743db3ec7 upstream.

... because interrupts are disabled that early and sending IPIs can
deadlock:

  BUG: sleeping function called from invalid context at kernel/sched/completion.c:99
  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/1
  no locks held by swapper/1/0.
  irq event stamp: 0
  hardirqs last  enabled at (0): [<0000000000000000>] 0x0
  hardirqs last disabled at (0): [<ffffffff8106dda9>] copy_process+0x8b9/0x1ca0
  softirqs last  enabled at (0): [<ffffffff8106dda9>] copy_process+0x8b9/0x1ca0
  softirqs last disabled at (0): [<0000000000000000>] 0x0
  Preemption disabled at:
  [<ffffffff8104703b>] start_secondary+0x3b/0x190
  CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.5.0-rc2+ #1
  Hardware name: GIGABYTE MZ01-CE1-00/MZ01-CE1-00, BIOS F02 08/29/2018
  Call Trace:
   dump_stack
   ___might_sleep.cold.92
   wait_for_completion
   ? generic_exec_single
   rdmsr_safe_on_cpu
   ? wrmsr_on_cpus
   mce_amd_feature_init
   mcheck_cpu_init
   identify_cpu
   identify_secondary_cpu
   smp_store_cpu_info
   start_secondary
   secondary_startup_64

The function smca_configure() is called only on the current CPU anyway,
therefore replace rdmsr_safe_on_cpu() with atomic rdmsr_safe() and avoid
the IPI.

 [ bp: Update commit message. ]

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/157252708836.3876.4604398213417262402.stgit@buzz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mce/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -269,7 +269,7 @@ static void smca_configure(unsigned int
 	if (smca_banks[bank].hwid)
 		return;
 
-	if (rdmsr_safe_on_cpu(cpu, MSR_AMD64_SMCA_MCx_IPID(bank), &low, &high)) {
+	if (rdmsr_safe(MSR_AMD64_SMCA_MCx_IPID(bank), &low, &high)) {
 		pr_warn("Failed to read MCA_IPID for bank %d\n", bank);
 		return;
 	}


