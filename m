Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8409C54B9B9
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358142AbiFNSwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358148AbiFNSvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:51:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9574FC73;
        Tue, 14 Jun 2022 11:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C35AEB81AEC;
        Tue, 14 Jun 2022 18:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE79C341C0;
        Tue, 14 Jun 2022 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232351;
        bh=j4lFb4yq0BeaQiUH/m95Ux29RehTiuihGV7HK7RLQb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BI2Ty/lR4XtfqkkfmkKWMAdOv/0kKETHm3CnzqgmgvheAzSuqc8QW/ZtxfF98tx9M
         BkQH0qQa3fnkKmi39Uy8nzqlSBfuwCYB7Ld0VKoHjxO0ABy6WNw53jZdwp9bM0qZeo
         5Nv0Iqzq7eDBNFm7XJ+jeZkzNCb+xMlEVJswA74E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.18 06/11] x86/speculation/mmio: Enable CPU Fill buffer clearing on idle
Date:   Tue, 14 Jun 2022 20:40:43 +0200
Message-Id: <20220614183722.451816914@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
References: <20220614183720.861582392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 99a83db5a605137424e1efe29dc0573d6a5b6316 upstream

When the CPU is affected by Processor MMIO Stale Data vulnerabilities,
Fill Buffer Stale Data Propagator (FBSDP) can propagate stale data out
of Fill buffer to uncore buffer when CPU goes idle. Stale data can then
be exploited with other variants using MMIO operations.

Mitigate it by clearing the Fill buffer before entering idle state.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Co-developed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -434,6 +434,14 @@ static void __init mmio_select_mitigatio
 		static_branch_enable(&mmio_stale_data_clear);
 
 	/*
+	 * If Processor-MMIO-Stale-Data bug is present and Fill Buffer data can
+	 * be propagated to uncore buffers, clearing the Fill buffers on idle
+	 * is required irrespective of SMT state.
+	 */
+	if (!(ia32_cap & ARCH_CAP_FBSDP_NO))
+		static_branch_enable(&mds_idle_clear);
+
+	/*
 	 * Check if the system has the right microcode.
 	 *
 	 * CPU Fill buffer clear mitigation is enumerated by either an explicit
@@ -1225,6 +1233,8 @@ static void update_indir_branch_cond(voi
 /* Update the static key controlling the MDS CPU buffer clear in idle */
 static void update_mds_branch_idle(void)
 {
+	u64 ia32_cap = x86_read_arch_cap_msr();
+
 	/*
 	 * Enable the idle clearing if SMT is active on CPUs which are
 	 * affected only by MSBDS and not any other MDS variant.
@@ -1236,10 +1246,12 @@ static void update_mds_branch_idle(void)
 	if (!boot_cpu_has_bug(X86_BUG_MSBDS_ONLY))
 		return;
 
-	if (sched_smt_active())
+	if (sched_smt_active()) {
 		static_branch_enable(&mds_idle_clear);
-	else
+	} else if (mmio_mitigation == MMIO_MITIGATION_OFF ||
+		   (ia32_cap & ARCH_CAP_FBSDP_NO)) {
 		static_branch_disable(&mds_idle_clear);
+	}
 }
 
 #define MDS_MSG_SMT "MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.\n"


