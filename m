Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C0737CB5E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242633AbhELQfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241701AbhELQ1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 524D961428;
        Wed, 12 May 2021 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834918;
        bh=FnV7ww8KXpESLpPrKCpJtJBuHdlb7RWXZ+gZw6rRHyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrhXTARqbRJQHhC1xWP+YldQ4rH8SzhP33dR4VyorBjeLggnHYn4+2pGLfk6Wj4Le
         bPmLobCIOTobrVdepA6Tv6iyRTtv1hoSRl60Z8XTSrU88UvXoY7g00vtSzVNoKYIpy
         RNIKOoyQt5ik/Tv6sStBHaW+4w+yIhO8Z+DPiLrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 5.12 136/677] Revert "tools/power turbostat: adjust for temperature offset"
Date:   Wed, 12 May 2021 16:43:02 +0200
Message-Id: <20210512144841.753832409@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Len Brown <len.brown@intel.com>

commit b2b94be787bf47eedd5890a249f3318bf9f1f1d5 upstream.

This reverts commit 6ff7cb371c4bea3dba03a56d774da925e78a5087.

Apparently the TCC offset should not be used to adjust what temperature
we show the user after all.

(on most systems, TCC offset is 0, FWIW)

Fixes: 6ff7cb371c4b

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/power/x86/turbostat/turbostat.c |   62 ++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 29 deletions(-)

--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4822,33 +4822,12 @@ double discover_bclk(unsigned int family
  * below this value, including the Digital Thermal Sensor (DTS),
  * Package Thermal Management Sensor (PTM), and thermal event thresholds.
  */
-int read_tcc_activation_temp()
+int set_temperature_target(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 {
 	unsigned long long msr;
-	unsigned int tcc, target_c, offset_c;
-
-	/* Temperature Target MSR is Nehalem and newer only */
-	if (!do_nhm_platform_info)
-		return 0;
-
-	if (get_msr(base_cpu, MSR_IA32_TEMPERATURE_TARGET, &msr))
-		return 0;
+	unsigned int target_c_local;
+	int cpu;
 
-	target_c = (msr >> 16) & 0xFF;
-
-	offset_c = (msr >> 24) & 0xF;
-
-	tcc = target_c - offset_c;
-
-	if (!quiet)
-		fprintf(outf, "cpu%d: MSR_IA32_TEMPERATURE_TARGET: 0x%08llx (%d C) (%d default - %d offset)\n",
-			base_cpu, msr, tcc, target_c, offset_c);
-
-	return tcc;
-}
-
-int set_temperature_target(struct thread_data *t, struct core_data *c, struct pkg_data *p)
-{
 	/* tcc_activation_temp is used only for dts or ptm */
 	if (!(do_dts || do_ptm))
 		return 0;
@@ -4857,18 +4836,43 @@ int set_temperature_target(struct thread
 	if (!(t->flags & CPU_IS_FIRST_THREAD_IN_CORE) || !(t->flags & CPU_IS_FIRST_CORE_IN_PACKAGE))
 		return 0;
 
+	cpu = t->cpu_id;
+	if (cpu_migrate(cpu)) {
+		fprintf(outf, "Could not migrate to CPU %d\n", cpu);
+		return -1;
+	}
+
 	if (tcc_activation_temp_override != 0) {
 		tcc_activation_temp = tcc_activation_temp_override;
-		fprintf(outf, "Using cmdline TCC Target (%d C)\n", tcc_activation_temp);
+		fprintf(outf, "cpu%d: Using cmdline TCC Target (%d C)\n",
+			cpu, tcc_activation_temp);
 		return 0;
 	}
 
-	tcc_activation_temp = read_tcc_activation_temp();
-	if (tcc_activation_temp)
-		return 0;
+	/* Temperature Target MSR is Nehalem and newer only */
+	if (!do_nhm_platform_info)
+		goto guess;
+
+	if (get_msr(base_cpu, MSR_IA32_TEMPERATURE_TARGET, &msr))
+		goto guess;
+
+	target_c_local = (msr >> 16) & 0xFF;
+
+	if (!quiet)
+		fprintf(outf, "cpu%d: MSR_IA32_TEMPERATURE_TARGET: 0x%08llx (%d C)\n",
+			cpu, msr, target_c_local);
+
+	if (!target_c_local)
+		goto guess;
+
+	tcc_activation_temp = target_c_local;
+
+	return 0;
 
+guess:
 	tcc_activation_temp = TJMAX_DEFAULT;
-	fprintf(outf, "Guessing tjMax %d C, Please use -T to specify\n", tcc_activation_temp);
+	fprintf(outf, "cpu%d: Guessing tjMax %d C, Please use -T to specify\n",
+		cpu, tcc_activation_temp);
 
 	return 0;
 }


