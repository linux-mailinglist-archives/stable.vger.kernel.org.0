Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6101C119D3C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbfLJWgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:36:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730166AbfLJWeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:34:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E44A2077B;
        Tue, 10 Dec 2019 22:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017252;
        bh=K/yGSRCiMcC8vZYUp1qETucf02tyGYGSAGexTmkVrYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfLgilM0PS3QEAV6iTtOgx9E9G31TNCcLm0BS4cDr7+beBsHcKKH29/P0Qr/nS+LN
         ISPQpKqLrl/ZplStZri6E9OF5xwpWFz7v+vvWOTx9a6PlKSfIK/LNQRoEAgh0nHGqc
         U37DHtggx+LOSyPXlcuKIxXajjiBkcZQRZTHbAes=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 47/71] perf probe: Return a better scope DIE if there is no best scope
Date:   Tue, 10 Dec 2019 17:32:52 -0500
Message-Id: <20191210223316.14988-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223316.14988-1-sashal@kernel.org>
References: <20191210223316.14988-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit c701636aeec4c173208697d68da6e4271125564b ]

Make find_best_scope() returns innermost DIE at given address if there
is no best matched scope DIE. Since Gcc sometimes generates intuitively
strange line info which is out of inlined function address range, we
need this fixup.

Without this, sometimes perf probe failed to probe on a line inside an
inlined function:

  # perf probe -D ksys_open:3
  Failed to find scope of probe point.
    Error: Failed to add events.

With this fix, 'perf probe' can probe it:

  # perf probe -D ksys_open:3
  p:probe/ksys_open _text+25707308
  p:probe/ksys_open_1 _text+25710596
  p:probe/ksys_open_2 _text+25711114
  p:probe/ksys_open_3 _text+25711343
  p:probe/ksys_open_4 _text+25714058
  p:probe/ksys_open_5 _text+2819653
  p:probe/ksys_open_6 _text+2819701

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Link: http://lore.kernel.org/lkml/157291300887.19771.14936015360963292236.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-finder.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index d917f83e8e855..5ca8836b16e74 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -746,6 +746,16 @@ static int find_best_scope_cb(Dwarf_Die *fn_die, void *data)
 	return 0;
 }
 
+/* Return innermost DIE */
+static int find_inner_scope_cb(Dwarf_Die *fn_die, void *data)
+{
+	struct find_scope_param *fsp = data;
+
+	memcpy(fsp->die_mem, fn_die, sizeof(Dwarf_Die));
+	fsp->found = true;
+	return 1;
+}
+
 /* Find an appropriate scope fits to given conditions */
 static Dwarf_Die *find_best_scope(struct probe_finder *pf, Dwarf_Die *die_mem)
 {
@@ -757,8 +767,13 @@ static Dwarf_Die *find_best_scope(struct probe_finder *pf, Dwarf_Die *die_mem)
 		.die_mem = die_mem,
 		.found = false,
 	};
+	int ret;
 
-	cu_walk_functions_at(&pf->cu_die, pf->addr, find_best_scope_cb, &fsp);
+	ret = cu_walk_functions_at(&pf->cu_die, pf->addr, find_best_scope_cb,
+				   &fsp);
+	if (!ret && !fsp.found)
+		cu_walk_functions_at(&pf->cu_die, pf->addr,
+				     find_inner_scope_cb, &fsp);
 
 	return fsp.found ? die_mem : NULL;
 }
-- 
2.20.1

