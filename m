Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9EE8FD63F
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfKOGWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbfKOGWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:22:52 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAF9720637;
        Fri, 15 Nov 2019 06:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798971;
        bh=7qrlrb8rSjnvQiBDqWsbVKN+RN131lilHKx8YobWuiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmJucgYo9UjBEgiaUM1u0NQzO/FYvC8Zfp4aPVm7fCaySmMz+ClF2ztOiRInaJt5l
         jvvHMoacz1XktigrXMd9S0fVlhWIl9cuhhw+5YBkrPmp0xhuncWF9amoDqesYLQn7q
         nXU7VoSysyG0b1FDjwgX7HprGYPFzyFaWJ3L8xtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 27/31] cpu/speculation: Uninline and export CPU mitigations helpers
Date:   Fri, 15 Nov 2019 14:20:56 +0800
Message-Id: <20191115062019.904435211@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
References: <20191115062009.813108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@canonical.com>

commit 731dc9df975a5da21237a18c3384f811a7a41cc6 upstream.

A kernel module may need to check the value of the "mitigations=" kernel
command line parameter as part of its setup when the module needs
to perform software mitigations for a CPU flaw.

Uninline and export the helper functions surrounding the cpu_mitigations
enum to allow for their usage from a module.

Lastly, privatize the enum and cpu_mitigations variable since the value of
cpu_mitigations can be checked with the exported helper functions.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cpu.h |   25 ++-----------------------
 kernel/cpu.c        |   27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 24 deletions(-)

--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -287,28 +287,7 @@ static inline int cpuhp_smt_enable(void)
 static inline int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval) { return 0; }
 #endif
 
-/*
- * These are used for a global "mitigations=" cmdline option for toggling
- * optional CPU mitigations.
- */
-enum cpu_mitigations {
-	CPU_MITIGATIONS_OFF,
-	CPU_MITIGATIONS_AUTO,
-	CPU_MITIGATIONS_AUTO_NOSMT,
-};
-
-extern enum cpu_mitigations cpu_mitigations;
-
-/* mitigations=off */
-static inline bool cpu_mitigations_off(void)
-{
-	return cpu_mitigations == CPU_MITIGATIONS_OFF;
-}
-
-/* mitigations=auto,nosmt */
-static inline bool cpu_mitigations_auto_nosmt(void)
-{
-	return cpu_mitigations == CPU_MITIGATIONS_AUTO_NOSMT;
-}
+extern bool cpu_mitigations_off(void);
+extern bool cpu_mitigations_auto_nosmt(void);
 
 #endif /* _LINUX_CPU_H_ */
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2235,7 +2235,18 @@ void __init boot_cpu_hotplug_init(void)
 	this_cpu_write(cpuhp_state.state, CPUHP_ONLINE);
 }
 
-enum cpu_mitigations cpu_mitigations __ro_after_init = CPU_MITIGATIONS_AUTO;
+/*
+ * These are used for a global "mitigations=" cmdline option for toggling
+ * optional CPU mitigations.
+ */
+enum cpu_mitigations {
+	CPU_MITIGATIONS_OFF,
+	CPU_MITIGATIONS_AUTO,
+	CPU_MITIGATIONS_AUTO_NOSMT,
+};
+
+static enum cpu_mitigations cpu_mitigations __ro_after_init =
+	CPU_MITIGATIONS_AUTO;
 
 static int __init mitigations_parse_cmdline(char *arg)
 {
@@ -2252,3 +2263,17 @@ static int __init mitigations_parse_cmdl
 	return 0;
 }
 early_param("mitigations", mitigations_parse_cmdline);
+
+/* mitigations=off */
+bool cpu_mitigations_off(void)
+{
+	return cpu_mitigations == CPU_MITIGATIONS_OFF;
+}
+EXPORT_SYMBOL_GPL(cpu_mitigations_off);
+
+/* mitigations=auto,nosmt */
+bool cpu_mitigations_auto_nosmt(void)
+{
+	return cpu_mitigations == CPU_MITIGATIONS_AUTO_NOSMT;
+}
+EXPORT_SYMBOL_GPL(cpu_mitigations_auto_nosmt);


