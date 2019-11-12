Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599A7F9E8C
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfKLXwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:52:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57300 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726960AbfKLXuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:35 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvd-0008I7-Lk; Tue, 12 Nov 2019 23:50:33 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-000573-K7; Tue, 12 Nov 2019 23:50:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Borislav Petkov" <bp@suse.de>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Tony Luck" <tony.luck@intel.com>,
        "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>
Date:   Tue, 12 Nov 2019 23:48:06 +0000
Message-ID: <lsq.1573602477.93544792@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 09/25] x86/tsx: Add "auto" option to the tsx= cmdline
  parameter
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.77-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 7531a3596e3272d1f6841e0d601a614555dc6b65 upstream.

Platforms which are not affected by X86_BUG_TAA may want the TSX feature
enabled. Add "auto" option to the TSX cmdline parameter. When tsx=auto
disable TSX when X86_BUG_TAA is present, otherwise enable TSX.

More details on X86_BUG_TAA can be found here:
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/tsx_async_abort.html

 [ bp: Extend the arg buffer to accommodate "auto\0". ]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
[bwh: Backported to 4.4: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/kernel-parameters.txt | 3 +++
 arch/x86/kernel/cpu/tsx.c           | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3602,6 +3602,9 @@ bytes respectively. Such letter suffixes
 				update. This new MSR allows for the reliable
 				deactivation of the TSX functionality.)
 
+			auto	- Disable TSX if X86_BUG_TAA is present,
+				  otherwise enable TSX on the system.
+
 			Not specifying this option is equivalent to tsx=off.
 
 			See Documentation/hw-vuln/tsx_async_abort.rst
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -75,7 +75,7 @@ static bool __init tsx_ctrl_is_supported
 
 void __init tsx_init(void)
 {
-	char arg[4] = {};
+	char arg[5] = {};
 	int ret;
 
 	if (!tsx_ctrl_is_supported())
@@ -87,6 +87,11 @@ void __init tsx_init(void)
 			tsx_ctrl_state = TSX_CTRL_ENABLE;
 		} else if (!strcmp(arg, "off")) {
 			tsx_ctrl_state = TSX_CTRL_DISABLE;
+		} else if (!strcmp(arg, "auto")) {
+			if (boot_cpu_has_bug(X86_BUG_TAA))
+				tsx_ctrl_state = TSX_CTRL_DISABLE;
+			else
+				tsx_ctrl_state = TSX_CTRL_ENABLE;
 		} else {
 			tsx_ctrl_state = TSX_CTRL_DISABLE;
 			pr_err("tsx: invalid option, defaulting to off\n");

