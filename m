Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6249354B8FB
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345455AbiFNSoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357532AbiFNSno (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:43:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5065F4C413;
        Tue, 14 Jun 2022 11:42:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9A58B81A49;
        Tue, 14 Jun 2022 18:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C81C3411B;
        Tue, 14 Jun 2022 18:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232155;
        bh=PMA6q2h30lO0FbLSFNjRKTI2OnCZ8zsfL7bXYUgk0RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fiJYhjfmGimB7IuI+350KS8ucBzbtdNVZNGd70Md5ymmW+ws+s0Dw/1a4BRXB1Kvu
         IUR78RSILC6PpSziy5IIS5evt+mPg/ji6syHgCXKYPgA16tFjG3ZPpeGMgLrj6BYth
         riJZRz6wgbhiMBbavtQxcQiD5UsrRDuv7AYz2e54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 15/20] x86/speculation/mmio: Enable CPU Fill buffer clearing on idle
Date:   Tue, 14 Jun 2022 20:40:06 +0200
Message-Id: <20220614183727.045317552@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183723.328825625@linuxfoundation.org>
References: <20220614183723.328825625@linuxfoundation.org>
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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -417,6 +417,14 @@ static void __init mmio_select_mitigatio
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
@@ -1182,6 +1190,8 @@ static void update_indir_branch_cond(voi
 /* Update the static key controlling the MDS CPU buffer clear in idle */
 static void update_mds_branch_idle(void)
 {
+	u64 ia32_cap = x86_read_arch_cap_msr();
+
 	/*
 	 * Enable the idle clearing if SMT is active on CPUs which are
 	 * affected only by MSBDS and not any other MDS variant.
@@ -1193,10 +1203,12 @@ static void update_mds_branch_idle(void)
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


