Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BB81F3674
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 10:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgFIIxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 04:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgFIIxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 04:53:52 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA102C05BD43;
        Tue,  9 Jun 2020 01:53:51 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jia0z-0005c7-5J; Tue, 09 Jun 2020 10:53:49 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id B86F81C0475;
        Tue,  9 Jun 2020 10:53:48 +0200 (CEST)
Date:   Tue, 09 Jun 2020 08:53:48 -0000
From:   "tip-bot2 for Anthony Steinhauser" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/speculation: PR_SPEC_FORCE_DISABLE enforcement
 for indirect branches.
Cc:     Anthony Steinhauser <asteinhauser@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <159169282861.17951.10677906045770425307.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     4d8df8cbb9156b0a0ab3f802b80cb5db57acc0bf
Gitweb:        https://git.kernel.org/tip/4d8df8cbb9156b0a0ab3f802b80cb5db57acc0bf
Author:        Anthony Steinhauser <asteinhauser@google.com>
AuthorDate:    Sun, 07 Jun 2020 05:44:19 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 Jun 2020 10:50:55 +02:00

x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for indirect branches.

Currently, it is possible to enable indirect branch speculation even after
it was force-disabled using the PR_SPEC_FORCE_DISABLE option. Moreover, the
PR_GET_SPECULATION_CTRL command gives afterwards an incorrect result
(force-disabled when it is in fact enabled). This also is inconsistent
vs. STIBP and the documention which cleary states that
PR_SPEC_FORCE_DISABLE cannot be undone.

Fix this by actually enforcing force-disabled indirect branch
speculation. PR_SPEC_ENABLE called after PR_SPEC_FORCE_DISABLE now fails
with -EPERM as described in the documentation.

Fixes: 9137bb27e60e ("x86/speculation: Add prctl() control for indirect branch speculation")
Signed-off-by: Anthony Steinhauser <asteinhauser@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/cpu/bugs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 8d57562..56f573a 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1175,11 +1175,14 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 			return 0;
 		/*
 		 * Indirect branch speculation is always disabled in strict
-		 * mode.
+		 * mode. It can neither be enabled if it was force-disabled
+		 * by a  previous prctl call.
+
 		 */
 		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
 		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED ||
+		    task_spec_ib_force_disable(task))
 			return -EPERM;
 		task_clear_spec_ib_disable(task);
 		task_update_spec_tif(task);
