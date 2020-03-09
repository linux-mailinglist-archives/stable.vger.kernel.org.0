Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5325D17E794
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 19:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgCISxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 14:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727334AbgCISxi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 14:53:38 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42C920873;
        Mon,  9 Mar 2020 18:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583780018;
        bh=kvuAI/Vozd00PsdHf/FUFsMDhGfZK9Vl9tnI719Fyro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VE6Ww+mBqGCV0Z8kVRtp+xFKCtdfbMwl4Q5bX9dbbhLP8/mVgiMUY6HoMdFAqlMyl
         cefPMwig8bT7cKGCyamyN4KS3AU5/F9Qs8YsrNOAmQ8Gsx2iQxwLS7MU18emJfnnUN
         a9A2QOcGaG6psXrwAVyFeWYVflUxwkWhbA7zxv1o=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] tools: Let O= makes handle a relative path with -C option
Date:   Mon,  9 Mar 2020 15:53:18 -0300
Message-Id: <20200309185323.22583-2-acme@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200309185323.22583-1-acme@kernel.org>
References: <20200309185323.22583-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

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
index 7902a5681fc8..b8fc7d972be9 100644
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
index ded7a950dc40..6d2f3a1b2249 100644
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
-- 
2.21.1

