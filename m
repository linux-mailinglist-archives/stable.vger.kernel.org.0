Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E8B20BFB
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEPQAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:00:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43084 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727097AbfEPP6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:48 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImK-0006zk-3p; Thu, 16 May 2019 16:58:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001ST-U1; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.546555821@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 76/86] x86/speculation/mds: Add SMT warning message
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 39226ef02bfb43248b7db12a4fdccb39d95318e3 upstream.

MDS is vulnerable with SMT.  Make that clear with a one-time printk
whenever SMT first gets enabled.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/bugs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -712,6 +712,9 @@ static void update_indir_branch_cond(voi
 		static_branch_disable(&switch_to_cond_stibp);
 }
 
+#undef pr_fmt
+#define pr_fmt(fmt) fmt
+
 /* Update the static key controlling the MDS CPU buffer clear in idle */
 static void update_mds_branch_idle(void)
 {
@@ -732,6 +735,8 @@ static void update_mds_branch_idle(void)
 		static_branch_disable(&mds_idle_clear);
 }
 
+#define MDS_MSG_SMT "MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.\n"
+
 void arch_smt_update(void)
 {
 	/* Enhanced IBRS implies STIBP. No update required. */
@@ -755,6 +760,8 @@ void arch_smt_update(void)
 	switch (mds_mitigation) {
 	case MDS_MITIGATION_FULL:
 	case MDS_MITIGATION_VMWERV:
+		if (sched_smt_active() && !boot_cpu_has(X86_BUG_MSBDS_ONLY))
+			pr_warn_once(MDS_MSG_SMT);
 		update_mds_branch_idle();
 		break;
 	case MDS_MITIGATION_OFF:
@@ -1134,6 +1141,7 @@ static void __init l1tf_select_mitigatio
 	setup_force_cpu_cap(X86_FEATURE_L1TF_PTEINV);
 }
 #undef pr_fmt
+#define pr_fmt(fmt) fmt
 
 #ifdef CONFIG_SYSFS
 

