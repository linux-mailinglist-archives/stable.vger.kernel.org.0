Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9791F2A2
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbfEOLKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729391AbfEOLKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:10:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D152220843;
        Wed, 15 May 2019 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918619;
        bh=GbpUk4r4PtP7gKqjhb0KZaStS70Io0Byd3pEUMZQV6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPjMXSd01ATzgpMAhCu6EPxwOtpjkxgOBRGKTRu82FGtw1gAGp/j2HcQGn7P61AYY
         svvW15m7he5GilpGY4EQr8XNVVEx0m/mR/VJL92/CXptQWJVI3yd6+M3It/u+Gb3FV
         8IL3yDooA5BG9+B6IB5+kB4OBnIY1CZMYheg5pQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "WoodhouseDavid" <dwmw@amazon.co.uk>,
        Andi Kleen <ak@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "SchauflerCasey" <casey.schaufler@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 200/266] x86/speculation: Propagate information about RSB filling mitigation to sysfs
Date:   Wed, 15 May 2019 12:55:07 +0200
Message-Id: <20190515090729.720560936@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -779,10 +779,11 @@ static ssize_t cpu_show_common(struct de
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
 


