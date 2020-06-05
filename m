Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1DE1EFB2C
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgFEOYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbgFEORg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:17:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11E64208B6;
        Fri,  5 Jun 2020 14:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366655;
        bh=6zwGUGo6IJLz1UzgMnCPHNAuZNi38tSvN2PQ+FnbxdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y58PH5Uy6N7d7r56oZcYtUWWx13jyHJbPNQQtgLrJ1nUXWP48ztkeMPcr/2ZaPw8h
         4PLXzTYg+/XMxZS1Wm4aL0rOF1HUJybTtt/Nws+lA+Xf2mzCeymEqfVNbCrK9Yz9ra
         2J/Q9n7PKTQ1mbeROcM2JnkYRw2wvHmCmwk/Di8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 09/43] x86/hyperv: Properly suspend/resume reenlightenment notifications
Date:   Fri,  5 Jun 2020 16:14:39 +0200
Message-Id: <20200605140153.012469521@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 38dce4195f0daefb566279fd9fd51e1fbd62ae1b ]

Errors during hibernation with reenlightenment notifications enabled were
reported:

 [   51.730435] PM: hibernation entry
 [   51.737435] PM: Syncing filesystems ...
 ...
 [   54.102216] Disabling non-boot CPUs ...
 [   54.106633] smpboot: CPU 1 is now offline
 [   54.110006] unchecked MSR access error: WRMSR to 0x40000106 (tried to
     write 0x47c72780000100ee) at rIP: 0xffffffff90062f24
     native_write_msr+0x4/0x20)
 [   54.110006] Call Trace:
 [   54.110006]  hv_cpu_die+0xd9/0xf0
 ...

Normally, hv_cpu_die() just reassigns reenlightenment notifications to some
other CPU when the CPU receiving them goes offline. Upon hibernation, there
is no other CPU which is still online so cpumask_any_but(cpu_online_mask)
returns >= nr_cpu_ids and using it as hv_vp_index index is incorrect.
Disable the feature when cpumask_any_but() fails.

Also, as we now disable reenlightenment notifications upon hibernation we
need to restore them on resume. Check if hv_reenlightenment_cb was
previously set and restore from hv_resume().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/20200512160153.134467-1-vkuznets@redhat.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index fd51bac11b46..acf76b466db6 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -226,10 +226,18 @@ static int hv_cpu_die(unsigned int cpu)
 
 	rdmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
 	if (re_ctrl.target_vp == hv_vp_index[cpu]) {
-		/* Reassign to some other online CPU */
+		/*
+		 * Reassign reenlightenment notifications to some other online
+		 * CPU or just disable the feature if there are no online CPUs
+		 * left (happens on hibernation).
+		 */
 		new_cpu = cpumask_any_but(cpu_online_mask, cpu);
 
-		re_ctrl.target_vp = hv_vp_index[new_cpu];
+		if (new_cpu < nr_cpu_ids)
+			re_ctrl.target_vp = hv_vp_index[new_cpu];
+		else
+			re_ctrl.enabled = 0;
+
 		wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
 	}
 
@@ -293,6 +301,13 @@ static void hv_resume(void)
 
 	hv_hypercall_pg = hv_hypercall_pg_saved;
 	hv_hypercall_pg_saved = NULL;
+
+	/*
+	 * Reenlightenment notifications are disabled by hv_cpu_die(0),
+	 * reenable them here if hv_reenlightenment_cb was previously set.
+	 */
+	if (hv_reenlightenment_cb)
+		set_hv_tscchange_cb(hv_reenlightenment_cb);
 }
 
 /* Note: when the ops are called, only CPU0 is online and IRQs are disabled. */
-- 
2.25.1



