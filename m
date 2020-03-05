Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC78179FBB
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 07:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgCEGDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 01:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgCEGDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 01:03:08 -0500
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 456A0208CD;
        Thu,  5 Mar 2020 06:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583388187;
        bh=XW2ZNSFlFmMVeYr0rjiUOC93TZvwKYxKJYjlF/01hdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAOY8gEF3weg5zbUQESI7T9fEbk+NiKoEOYFZAS3Q7E5furtEWQwONyMw5mxRQvzf
         VXJXkOU0DZvl5XmbDLSBAblv/ubo+0iZ9O/ljmHYmeIusQIxLYQI4gdtMl6Lme5DSt
         O3KtHGaIHWr5t+yeS92QMnEz5Y58DFnY9uPIJB34=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [BUGFIX PATCH] tools: Let O= makes handle a relative path with -C option
Date:   Thu,  5 Mar 2020 15:03:03 +0900
Message-Id: <158338818292.25448.7161196505598269976.stgit@devnote2>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <9e7beb31-b41f-9e95-c92b-1829e420af77@infradead.org>
References: <9e7beb31-b41f-9e95-c92b-1829e420af77@infradead.org>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When I compiled tools/bootconfig from top directory with
-C option, the O= option didn't work correctly if I passed
a relative path.

  $ make O=./builddir/ -C tools/bootconfig/
  make: Entering directory '/home/mhiramat/ksrc/linux/tools/bootconfig'
  ../scripts/Makefile.include:4: *** O=./builddir/ does not exist.  Stop.
  make: Leaving directory '/home/mhiramat/ksrc/linux/tools/bootconfig'

The O= directory existence check failed because the check
script ran in the build target directory instead of the
directory where I ran the make command.

To fix that, once change directory to $(PWD) and check O=
directory, since the PWD is set to where the make command
runs.

Fixes: c883122acc0d ("perf tools: Let O= makes handle relative paths")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 tools/scripts/Makefile.include |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

