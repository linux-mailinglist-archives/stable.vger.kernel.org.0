Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD9B20C28
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfEPQCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:02:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42808 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0006zd-Eh; Thu, 16 May 2019 16:58:38 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001Oz-Fs; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "SchauflerCasey" <casey.schaufler@intel.com>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "WoodhouseDavid" <dwmw@amazon.co.uk>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.633578387@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 33/86] x86/speculation: Propagate information about
 RSB filling mitigation to sysfs
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

From: Jiri Kosina <jkosina@suse.cz>

commit bb4b3b7762735cdaba5a40fd94c9303d9ffa147a upstream.

If spectrev2 mitigation has been enabled, RSB is filled on context switch
in order to protect from various classes of spectrev2 attacks.

If this mitigation is enabled, say so in sysfs for spectrev2.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc:  "WoodhouseDavid" <dwmw@amazon.co.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc:  "SchauflerCasey" <casey.schaufler@intel.com>
Link: https://lkml.kernel.org/r/nycvar.YFH.7.76.1809251438580.15880@cbobk.fhfr.pm
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/bugs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -841,10 +841,11 @@ static ssize_t cpu_show_common(struct de
 		return sprintf(buf, "Mitigation: __user pointer sanitization\n");
 
 	case X86_BUG_SPECTRE_V2:
-		ret = sprintf(buf, "%s%s%s%s%s\n", spectre_v2_strings[spectre_v2_enabled],
+		ret = sprintf(buf, "%s%s%s%s%s%s\n", spectre_v2_strings[spectre_v2_enabled],
 			       boot_cpu_has(X86_FEATURE_USE_IBPB) ? ", IBPB" : "",
 			       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
 			       (x86_spec_ctrl_base & SPEC_CTRL_STIBP) ? ", STIBP" : "",
+			       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
 			       spectre_v2_module_string());
 		return ret;
 

