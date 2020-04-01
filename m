Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FC719B32A
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbgDAQom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388037AbgDAQom (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:44:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC312063A;
        Wed,  1 Apr 2020 16:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759481;
        bh=njbwwtwH2gQSrWyiV6cvvDdtJ368sq8JCDsnpEetON0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCAIBmcyRFd9bDfa9/3pKCmplLhgBJiZVbdQBsGjXhpG4/Vs8kJ19ccrHmFHlJKic
         wEgp0dedrzcxUswsCPM5jdUzXEfJ6xqS6cPkIQdYdOvBXANQgkoYJKY+/m40ZEVWQN
         6D4QFNikkWWUO8r2ThjgFH9RpVoaBvzqe0X/STIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
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
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 094/148] tools: Let O= makes handle a relative path with -C option
Date:   Wed,  1 Apr 2020 18:18:06 +0200
Message-Id: <20200401161601.969120213@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit be40920fbf1003c38ccdc02b571e01a75d890c82 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/Makefile            |    2 +-
 tools/scripts/Makefile.include |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

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


