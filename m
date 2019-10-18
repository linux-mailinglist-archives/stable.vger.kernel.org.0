Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662AEDD2F5
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388418AbfJRWI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388387AbfJRWI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFC402246E;
        Fri, 18 Oct 2019 22:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436538;
        bh=K7ijbg6IVjhRC7/PIpkToO6jKzcs6lrtL1NQcqpfzSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ji/YNXCyHxb/dAsv02RY5q2SvJAMftZojbChAjMtivPQUj+sGWSD8ys9w5NuVrIYn
         yBoBzQvG/262nvNUEUTkGlPqHUTyRpHPWJVF/2s+6FMqj9So2w+V5wjtaHOs0+Xh2P
         XpkcAxAPWM5hdigPJ0QAOYNVVz5eWEiwMjY0ES8w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        James Dingwall <james@dingwall.me.uk>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 41/56] x86/xen: Return from panic notifier
Date:   Fri, 18 Oct 2019 18:07:38 -0400
Message-Id: <20191018220753.10002-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

[ Upstream commit c6875f3aacf2a5a913205accddabf0bfb75cac76 ]

Currently execution of panic() continues until Xen's panic notifier
(xen_panic_event()) is called at which point we make a hypercall that
never returns.

This means that any notifier that is supposed to be called later as
well as significant part of panic() code (such as pstore writes from
kmsg_dump()) is never executed.

There is no reason for xen_panic_event() to be this last point in
execution since panic()'s emergency_restart() will call into
xen_emergency_restart() from where we can perform our hypercall.

Nevertheless, we will provide xen_legacy_crash boot option that will
preserve original behavior during crash. This option could be used,
for example, if running kernel dumper (which happens after panic
notifiers) is undesirable.

Reported-by: James Dingwall <james@dingwall.me.uk>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  4 +++
 arch/x86/xen/enlighten.c                      | 28 +++++++++++++++++--
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 188a7db8501bd..9d8b42afbe4f9 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4873,6 +4873,10 @@
 				the unplug protocol
 			never -- do not unplug even if version check succeeds
 
+	xen_legacy_crash	[X86,XEN]
+			Crash from Xen panic notifier, without executing late
+			panic() code such as dumping handler.
+
 	xen_nopvspin	[X86,XEN]
 			Disables the ticketlock slowpath using Xen PV
 			optimizations.
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 515d5e4414c29..00fc683a20110 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -259,19 +259,41 @@ void xen_reboot(int reason)
 		BUG();
 }
 
+static int reboot_reason = SHUTDOWN_reboot;
+static bool xen_legacy_crash;
 void xen_emergency_restart(void)
 {
-	xen_reboot(SHUTDOWN_reboot);
+	xen_reboot(reboot_reason);
 }
 
 static int
 xen_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
 {
-	if (!kexec_crash_loaded())
-		xen_reboot(SHUTDOWN_crash);
+	if (!kexec_crash_loaded()) {
+		if (xen_legacy_crash)
+			xen_reboot(SHUTDOWN_crash);
+
+		reboot_reason = SHUTDOWN_crash;
+
+		/*
+		 * If panic_timeout==0 then we are supposed to wait forever.
+		 * However, to preserve original dom0 behavior we have to drop
+		 * into hypervisor. (domU behavior is controlled by its
+		 * config file)
+		 */
+		if (panic_timeout == 0)
+			panic_timeout = -1;
+	}
 	return NOTIFY_DONE;
 }
 
+static int __init parse_xen_legacy_crash(char *arg)
+{
+	xen_legacy_crash = true;
+	return 0;
+}
+early_param("xen_legacy_crash", parse_xen_legacy_crash);
+
 static struct notifier_block xen_panic_block = {
 	.notifier_call = xen_panic_event,
 	.priority = INT_MIN
-- 
2.20.1

