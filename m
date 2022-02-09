Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F2C4AFB59
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240483AbiBISpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239919AbiBISoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:44:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DA8C02B5F4;
        Wed,  9 Feb 2022 10:42:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C221B82215;
        Wed,  9 Feb 2022 18:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6FAC340E9;
        Wed,  9 Feb 2022 18:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432167;
        bh=Y8q/J0Iry0Dpi9EHXI2yalvcbthB960zMJ7G+0SH+Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdeNjUE2TUiCpsgUfWk/D0BVQEPxdQKE89FUdKdPXy+TVGn2RoRYSpZvp4Uf7GR+e
         aFW8WhJdmAlUUhn8tIrjMJaQM42fBdsb8k9a49vEhXxBlOOzJEX87fw7gnUtOdvy7V
         8oNzE+gANByflZ5s5BL5Z916VBWGj3Tj1G6UL9jPRMQT7OkIXnJHujhxfEUwmZ7D1m
         9NsEiL1SEWlGORijICWXAAEqYL+S1uFKfz+TFmmtYu6M0CYntVT+2HPk8el2Nexw6u
         U8PGhoRbaPzqqZ2xQLgm2gRvnkJCUsxQjZCFLip10gyeQ+okkACE0L5JPmTyvLReDa
         wucamD467uj2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.10 24/27] x86/Xen: streamline (and fix) PV CPU enumeration
Date:   Wed,  9 Feb 2022 13:41:00 -0500
Message-Id: <20220209184103.47635-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184103.47635-1-sashal@kernel.org>
References: <20220209184103.47635-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit e25a8d959992f61b64a58fc62fb7951dc6f31d1f ]

This started out with me noticing that "dom0_max_vcpus=<N>" with <N>
larger than the number of physical CPUs reported through ACPI tables
would not bring up the "excess" vCPU-s. Addressing this is the primary
purpose of the change; CPU maps handling is being tidied only as far as
is necessary for the change here (with the effect of also avoiding the
setting up of too much per-CPU infrastructure, i.e. for CPUs which can
never come online).

Noticing that xen_fill_possible_map() is called way too early, whereas
xen_filter_cpu_maps() is called too late (after per-CPU areas were
already set up), and further observing that each of the functions serves
only one of Dom0 or DomU, it looked like it was better to simplify this.
Use the .get_smp_config hook instead, uniformly for Dom0 and DomU.
xen_fill_possible_map() can be dropped altogether, while
xen_filter_cpu_maps() is re-purposed but not otherwise changed.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/2dbd5f0a-9859-ca2d-085e-a02f7166c610@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten_pv.c |  4 ----
 arch/x86/xen/smp_pv.c       | 26 ++++++--------------------
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 16ff25d6935e7..804c65d2b95f3 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1387,10 +1387,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 		xen_acpi_sleep_register();
 
-		/* Avoid searching for BIOS MP tables */
-		x86_init.mpparse.find_smp_config = x86_init_noop;
-		x86_init.mpparse.get_smp_config = x86_init_uint_noop;
-
 		xen_boot_params_init_edd();
 
 #ifdef CONFIG_ACPI
diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index c2ac319f11a4b..8f9e7e2407c87 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -149,28 +149,12 @@ int xen_smp_intr_init_pv(unsigned int cpu)
 	return rc;
 }
 
-static void __init xen_fill_possible_map(void)
-{
-	int i, rc;
-
-	if (xen_initial_domain())
-		return;
-
-	for (i = 0; i < nr_cpu_ids; i++) {
-		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
-		if (rc >= 0) {
-			num_processors++;
-			set_cpu_possible(i, true);
-		}
-	}
-}
-
-static void __init xen_filter_cpu_maps(void)
+static void __init _get_smp_config(unsigned int early)
 {
 	int i, rc;
 	unsigned int subtract = 0;
 
-	if (!xen_initial_domain())
+	if (early)
 		return;
 
 	num_processors = 0;
@@ -211,7 +195,6 @@ static void __init xen_pv_smp_prepare_boot_cpu(void)
 		 * sure the old memory can be recycled. */
 		make_lowmem_page_readwrite(xen_initial_gdt);
 
-	xen_filter_cpu_maps();
 	xen_setup_vcpu_info_placement();
 
 	/*
@@ -491,5 +474,8 @@ static const struct smp_ops xen_smp_ops __initconst = {
 void __init xen_smp_init(void)
 {
 	smp_ops = xen_smp_ops;
-	xen_fill_possible_map();
+
+	/* Avoid searching for BIOS MP tables */
+	x86_init.mpparse.find_smp_config = x86_init_noop;
+	x86_init.mpparse.get_smp_config = _get_smp_config;
 }
-- 
2.34.1

