Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EBD1198D2
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfLJVkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729664AbfLJVeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:34:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0E21205C9;
        Tue, 10 Dec 2019 21:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013675;
        bh=hzr0+RYl1LfimtxMSPA8uEVGYwsm5C0ktaBByI12+1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usi7eIoJcgpkfXL33Hs2LDMY3yG8eJ84CPQATXp9y2YoYRx/8gcBI1dagdYsnqgZG
         UXd8cAtnvLJNAKzdw8ysMSi31VFP+xvzLCkB7RoWgaEAdImw6QmL9MUyZnHBBudi+C
         EnZtT/kOj/SN0DYZygaSxYOYc9717L8Vquoyzpyc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 111/177] perf probe: Walk function lines in lexical blocks
Date:   Tue, 10 Dec 2019 16:31:15 -0500
Message-Id: <20191210213221.11921-111-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit acb6a7047ac2146b723fef69ee1ab6b7143546bf ]

Since some inlined functions are in lexical blocks of given function, we
have to recursively walk through the DIE tree.  Without this fix,
perf-probe -L can miss the inlined functions which is in a lexical block
(like if (..) { func() } case.)

However, even though, to walk the lines in a given function, we don't
need to follow the children DIE of inlined functions because those do
not have any lines in the specified function.

We need to walk though whole trees only if we walk all lines in a given
file, because an inlined function can include another inlined function
in the same file.

Fixes: b0e9cb2802d4 ("perf probe: Fix to search nested inlined functions in CU")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157190836514.1859.15996864849678136353.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 5bbb87f63ecba..6e7cb3537ce01 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -691,10 +691,9 @@ static int __die_walk_funclines_cb(Dwarf_Die *in_die, void *data)
 			if (lw->retval != 0)
 				return DIE_FIND_CB_END;
 		}
+		if (!lw->recursive)
+			return DIE_FIND_CB_SIBLING;
 	}
-	if (!lw->recursive)
-		/* Don't need to search recursively */
-		return DIE_FIND_CB_SIBLING;
 
 	if (addr) {
 		fname = dwarf_decl_file(in_die);
@@ -741,6 +740,10 @@ static int __die_walk_culines_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct __line_walk_param *lw = data;
 
+	/*
+	 * Since inlined function can include another inlined function in
+	 * the same file, we need to walk in it recursively.
+	 */
 	lw->retval = __die_walk_funclines(sp_die, true, lw->callback, lw->data);
 	if (lw->retval != 0)
 		return DWARF_CB_ABORT;
@@ -830,8 +833,9 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 	 */
 	if (rt_die != cu_die)
 		/*
-		 * Don't need walk functions recursively, because nested
-		 * inlined functions don't have lines of the specified DIE.
+		 * Don't need walk inlined functions recursively, because
+		 * inner inlined functions don't have the lines of the
+		 * specified function.
 		 */
 		ret = __die_walk_funclines(rt_die, false, callback, data);
 	else {
-- 
2.20.1

