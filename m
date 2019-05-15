Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95C71F266
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbfEOLM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729526AbfEOLM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B560420644;
        Wed, 15 May 2019 11:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918745;
        bh=JlkSNfWB5CXyq0ERJMelWM8ac/C1kds6pM/n61D6YHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMmm/1/LDDHYRP9kQYqRgKdI3NGFjLJjNJVn2Dpe7rMJyJ2DS5n/RzsGY4QBNiig2
         ZlLZtNwQ0Ev3sAHNQsl1SvJnVswTHCx0IAEcA2I7gZB+rwNq7nlifR136gRIquO+iL
         X3Zn6VNLoyvnt+Q/UAXABieCEW7nkWRz7rCJEZXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jikos@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jon Masters <jcm@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Price <steven.price@arm.com>,
        Phil Auld <pauld@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 247/266] cpu/speculation: Add mitigations= cmdline option
Date:   Wed, 15 May 2019 12:55:54 +0200
Message-Id: <20190515090731.364702401@linuxfoundation.org>
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

commit 98af8452945c55652de68536afdde3b520fec429 upstream.

Keeping track of the number of mitigations for all the CPU speculation
bugs has become overwhelming for many users.  It's getting more and more
complicated to decide which mitigations are needed for a given
architecture.  Complicating matters is the fact that each arch tends to
have its own custom way to mitigate the same vulnerability.

Most users fall into a few basic categories:

a) they want all mitigations off;

b) they want all reasonable mitigations on, with SMT enabled even if
   it's vulnerable; or

c) they want all reasonable mitigations on, with SMT disabled if
   vulnerable.

Define a set of curated, arch-independent options, each of which is an
aggregation of existing options:

- mitigations=off: Disable all mitigations.

- mitigations=auto: [default] Enable all the default mitigations, but
  leave SMT enabled, even if it's vulnerable.

- mitigations=auto,nosmt: Enable all the default mitigations, disabling
  SMT if needed by a mitigation.

Currently, these options are placeholders which don't actually do
anything.  They will be fleshed out in upcoming patches.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jiri Kosina <jkosina@suse.cz> (on x86)
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Phil Auld <pauld@redhat.com>
Link: https://lkml.kernel.org/r/b07a8ef9b7c5055c3a4637c87d07c296d5016fe0.1555085500.git.jpoimboe@redhat.com
[bwh: Backported to 4.4:
 - Drop the auto,nosmt option which we can't support
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |   19 +++++++++++++++++++
 include/linux/cpu.h                 |   17 +++++++++++++++++
 kernel/cpu.c                        |   13 +++++++++++++
 3 files changed, 49 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2173,6 +2173,25 @@ bytes respectively. Such letter suffixes
 			in the "bleeding edge" mini2440 support kernel at
 			http://repo.or.cz/w/linux-2.6/mini2440.git
 
+	mitigations=
+			Control optional mitigations for CPU vulnerabilities.
+			This is a set of curated, arch-independent options, each
+			of which is an aggregation of existing arch-specific
+			options.
+
+			off
+				Disable all optional CPU mitigations.  This
+				improves system performance, but it may also
+				expose users to several CPU vulnerabilities.
+
+			auto (default)
+				Mitigate all CPU vulnerabilities, but leave SMT
+				enabled, even if it's vulnerable.  This is for
+				users who don't want to be surprised by SMT
+				getting disabled across kernel upgrades, or who
+				have other ways of avoiding SMT-based attacks.
+				This is the default behavior.
+
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
 			parameter allows control of the logging verbosity for
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -296,4 +296,21 @@ bool cpu_wait_death(unsigned int cpu, in
 bool cpu_report_death(void);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
+/*
+ * These are used for a global "mitigations=" cmdline option for toggling
+ * optional CPU mitigations.
+ */
+enum cpu_mitigations {
+	CPU_MITIGATIONS_OFF,
+	CPU_MITIGATIONS_AUTO,
+};
+
+extern enum cpu_mitigations cpu_mitigations;
+
+/* mitigations=off */
+static inline bool cpu_mitigations_off(void)
+{
+	return cpu_mitigations == CPU_MITIGATIONS_OFF;
+}
+
 #endif /* _LINUX_CPU_H_ */
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -842,3 +842,16 @@ void init_cpu_online(const struct cpumas
 {
 	cpumask_copy(to_cpumask(cpu_online_bits), src);
 }
+
+enum cpu_mitigations cpu_mitigations = CPU_MITIGATIONS_AUTO;
+
+static int __init mitigations_parse_cmdline(char *arg)
+{
+	if (!strcmp(arg, "off"))
+		cpu_mitigations = CPU_MITIGATIONS_OFF;
+	else if (!strcmp(arg, "auto"))
+		cpu_mitigations = CPU_MITIGATIONS_AUTO;
+
+	return 0;
+}
+early_param("mitigations", mitigations_parse_cmdline);


