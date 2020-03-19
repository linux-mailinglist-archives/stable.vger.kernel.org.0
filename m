Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C3118B89C
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 15:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgCSOFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 10:05:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60747 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgCSOFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 10:05:11 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jEvmv-0001p8-N1; Thu, 19 Mar 2020 15:04:46 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 5505B1C22A1;
        Thu, 19 Mar 2020 15:04:45 +0100 (CET)
Date:   Thu, 19 Mar 2020 14:04:45 -0000
From:   "tip-bot2 for Masami Hiramatsu" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] tools: Let O= makes handle a relative path with -C option
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <158351957799.3363.15269768530697526765.stgit@devnote2>
References: <158351957799.3363.15269768530697526765.stgit@devnote2>
MIME-Version: 1.0
Message-ID: <158462668507.28353.5229256080954046835.tip-bot2@tip-bot2>
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

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     be40920fbf1003c38ccdc02b571e01a75d890c82
Gitweb:        https://git.kernel.org/tip/be40920fbf1003c38ccdc02b571e01a75d890c82
Author:        Masami Hiramatsu <mhiramat@kernel.org>
AuthorDate:    Sat, 07 Mar 2020 03:32:58 +09:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Fri, 06 Mar 2020 17:08:28 -03:00

tools: Let O= makes handle a relative path with -C option

When I tried to compile tools/perf from the top directory with the -C
option, the O= option didn't work correctly if I passed a relative path:

  $ make O=BUILD -C tools/perf/
  make: Entering directory '/home/mhiramat/ksrc/linux/tools/perf'
    BUILD:   Doing 'make -j8' parallel build
  ../scripts/Makefile.include:4: *** O=/home/mhiramat/ksrc/linux/tools/perf/BUILD does not exist.  Stop.
  make: *** [Makefile:70: all] Error 2
  make: Leaving directory '/home/mhiramat/ksrc/linux/tools/perf'

The O= directory existence check failed because the check script ran in
the build target directory instead of the directory where I ran the make
command.

To fix that, once change directory to $(PWD) and check O= directory,
since the PWD is set to where the make command runs.

Fixes: c883122acc0d ("perf tools: Let O= makes handle relative paths")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/158351957799.3363.15269768530697526765.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile            | 2 +-
 tools/scripts/Makefile.include | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7902a56..b8fc7d9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -35,7 +35,7 @@ endif
 # Only pass canonical directory names as the output directory:
 #
 ifneq ($(O),)
-  FULL_O := $(shell readlink -f $(O) || echo $(O))
+  FULL_O := $(shell cd $(PWD); readlink -f $(O) || echo $(O))
 endif
 
 #
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index ded7a95..6d2f3a1 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 ifneq ($(O),)
 ifeq ($(origin O), command line)
-	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
-	ABSOLUTE_O := $(shell cd $(O) ; pwd)
+	dummy := $(if $(shell cd $(PWD); test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
+	ABSOLUTE_O := $(shell cd $(PWD); cd $(O) ; pwd)
 	OUTPUT := $(ABSOLUTE_O)/$(if $(subdir),$(subdir)/)
 	COMMAND_O := O=$(ABSOLUTE_O)
 ifeq ($(objtree),)
