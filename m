Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5C919B11D
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388147AbgDAQcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388222AbgDAQcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:32:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C959220658;
        Wed,  1 Apr 2020 16:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758727;
        bh=fuZdubD077dq0B7HOwQ6mfwjuba+ZeVl7JU27HhDW0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOMgxWa1StBgNapMiGuf45C5TWFQ9SV3ZfC1vfqcAYZKXnq4skx5kaeBWqAQhpvlt
         miyLhkU5c2U2UOrGP9Hem6cs5QMV1TSHMrrmRpsRx38pjas59saMMng3+7zx/Bj4Qi
         crjdiq15v9tgoRH5jp5GeFtwYe5MJhPsMIU0NXDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.4 56/91] perf probe: Do not depend on dwfl_module_addrsym()
Date:   Wed,  1 Apr 2020 18:17:52 +0200
Message-Id: <20200401161532.691187361@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 1efde2754275dbd9d11c6e0132a4f09facf297ab upstream.

Do not depend on dwfl_module_addrsym() because it can fail on user-space
shared libraries.

Actually, same bug was fixed by commit 664fee3dc379 ("perf probe: Do not
use dwfl_module_addrsym if dwarf_diename finds symbol name"), but commit
07d369857808 ("perf probe: Fix wrong address verification) reverted to
get actual symbol address from symtab.

This fixes it again by getting symbol address from DIE, and only if the
DIE has only address range, it uses dwfl_module_addrsym().

Fixes: 07d369857808 ("perf probe: Fix wrong address verification)
Reported-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Link: http://lore.kernel.org/lkml/158281812176.476.14164573830975116234.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/probe-finder.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -608,14 +608,19 @@ static int convert_to_trace_point(Dwarf_
 		return -EINVAL;
 	}
 
-	/* Try to get actual symbol name from symtab */
-	symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
+	if (dwarf_entrypc(sp_die, &eaddr) == 0) {
+		/* If the DIE has entrypc, use it. */
+		symbol = dwarf_diename(sp_die);
+	} else {
+		/* Try to get actual symbol name and address from symtab */
+		symbol = dwfl_module_addrsym(mod, paddr, &sym, NULL);
+		eaddr = sym.st_value;
+	}
 	if (!symbol) {
 		pr_warning("Failed to find symbol at 0x%lx\n",
 			   (unsigned long)paddr);
 		return -ENOENT;
 	}
-	eaddr = sym.st_value;
 
 	tp->offset = (unsigned long)(paddr - eaddr);
 	tp->address = (unsigned long)paddr;


