Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892571EDAC
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbfEOLMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729740AbfEOLMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63CF520644;
        Wed, 15 May 2019 11:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918734;
        bh=5PWgMwe3g2N4wvJmSC0DarTOdojbvAXmIDNwIx+bIgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J18AXwdm6C4DVdVLW1nXxtnBcWsvbwKwnhc+aM6q0EBbdW8SHDG3fD0QIyV3tm6Gy
         24FwPl//p9VWs09rbM/+uH/an76s6HsoKGbWlQaR4A5FfFPVR6+TWXTsN0uIkXXkRG
         3tzbYxsiSFmtF4hw2ytF2e+YA9BEHxL7Qm3KyXnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tyler Hicks <tyhicks@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 244/266] x86/speculation/mds: Add SMT warning message
Date:   Wed, 15 May 2019 12:55:51 +0200
Message-Id: <20190515090731.260623959@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 39226ef02bfb43248b7db12a4fdccb39d95318e3 upstream.

MDS is vulnerable with SMT.  Make that clear with a one-time printk
whenever SMT first gets enabled.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -646,6 +646,9 @@ static void update_indir_branch_cond(voi
 		static_branch_disable(&switch_to_cond_stibp);
 }
 
+#undef pr_fmt
+#define pr_fmt(fmt) fmt
+
 /* Update the static key controlling the MDS CPU buffer clear in idle */
 static void update_mds_branch_idle(void)
 {
@@ -666,6 +669,8 @@ static void update_mds_branch_idle(void)
 		static_branch_disable(&mds_idle_clear);
 }
 
+#define MDS_MSG_SMT "MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.\n"
+
 void arch_smt_update(void)
 {
 	/* Enhanced IBRS implies STIBP. No update required. */
@@ -689,6 +694,8 @@ void arch_smt_update(void)
 	switch (mds_mitigation) {
 	case MDS_MITIGATION_FULL:
 	case MDS_MITIGATION_VMWERV:
+		if (sched_smt_active() && !boot_cpu_has(X86_BUG_MSBDS_ONLY))
+			pr_warn_once(MDS_MSG_SMT);
 		update_mds_branch_idle();
 		break;
 	case MDS_MITIGATION_OFF:
@@ -1069,6 +1076,7 @@ static void __init l1tf_select_mitigatio
 	setup_force_cpu_cap(X86_FEATURE_L1TF_PTEINV);
 }
 #undef pr_fmt
+#define pr_fmt(fmt) fmt
 
 #ifdef CONFIG_SYSFS
 


