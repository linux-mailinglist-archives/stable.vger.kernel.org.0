Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F794BE890
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbiBUJva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:51:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352317AbiBUJrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFCC41F8D;
        Mon, 21 Feb 2022 01:19:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C02CCE0E76;
        Mon, 21 Feb 2022 09:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81887C340E9;
        Mon, 21 Feb 2022 09:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435165;
        bh=fFDyHU/EXMCfwe3bvn0ogCYcjkIKtHPdA+SKnAQmZxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgV7JV41FTOUu1smu60f57NN8NGgeAr7B2XSBh5Qn4RUXEpHajXn0B87gXqx65qC/
         9CcBlN8D+NjJSQufGODpkG5aib9aNn/ssq1+AacnYtz9caWisgCfhZEk8FHy9LXBeZ
         LzaEi4iE5rwY2swqIQ5F0HtoL2wQGieop23xKcvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 067/227] x86/Xen: streamline (and fix) PV CPU enumeration
Date:   Mon, 21 Feb 2022 09:48:06 +0100
Message-Id: <20220221084937.101310202@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5004feb16783d..d47c3d176ae4b 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1341,10 +1341,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 		xen_acpi_sleep_register();
 
-		/* Avoid searching for BIOS MP tables */
-		x86_init.mpparse.find_smp_config = x86_init_noop;
-		x86_init.mpparse.get_smp_config = x86_init_uint_noop;
-
 		xen_boot_params_init_edd();
 
 #ifdef CONFIG_ACPI
diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index 6a8f3b53ab834..4a6019238ee7d 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -148,28 +148,12 @@ int xen_smp_intr_init_pv(unsigned int cpu)
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
@@ -210,7 +194,6 @@ static void __init xen_pv_smp_prepare_boot_cpu(void)
 		 * sure the old memory can be recycled. */
 		make_lowmem_page_readwrite(xen_initial_gdt);
 
-	xen_filter_cpu_maps();
 	xen_setup_vcpu_info_placement();
 
 	/*
@@ -476,5 +459,8 @@ static const struct smp_ops xen_smp_ops __initconst = {
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



