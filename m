Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295BFDD486
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfJRWZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbfJRWEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E58B222CC;
        Fri, 18 Oct 2019 22:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436276;
        bh=QhHN1i/apWtfsJxZ56V2XWINw49Kv7/OXH9TlRgBoH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4YClWMPFGWDJ9dzKaO+hc85WM3CHUA2gtLIbsPbJ85D2WDfXPhrPW3pyPKqh6yZD
         ySHBIHCxiXW9syoF9jQGTy60A+EGV4UJtVVrd5QRLjtwH4f3QjXwxheshkMi+WhHud
         /6YcvRUM2MA1sunZmuXfTBtHUK4Wjq9WlYJM2k0w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        James Dingwall <james@dingwall.me.uk>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 55/89] x86/xen: Return from panic notifier
Date:   Fri, 18 Oct 2019 18:02:50 -0400
Message-Id: <20191018220324.8165-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
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
index 4c1971960afa3..5ea005c9e2d60 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5267,6 +5267,10 @@
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
index 750f46ad018a0..205b1176084f5 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -269,19 +269,41 @@ void xen_reboot(int reason)
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

