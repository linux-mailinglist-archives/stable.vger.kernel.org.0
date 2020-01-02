Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB8412ED87
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgABW3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:29:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730020AbgABW3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:29:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 090E922525;
        Thu,  2 Jan 2020 22:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004157;
        bh=cU89cskI6U1lKFmTYYhMVUErIR0hkQHaf0dt4V1+Rx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhQJaWLDx02QGhgpcxoRWbkUvshozfsJMwIV2DW3jy6e12D3/uTHL8JljbOHsfGtK
         +9goOyMqGMnEkTLws6GZinsn+FdcOnM7URKjerYR/a2T8uU2U+o08cBqDUog6/japu
         SyrAZbff2g3F4kuev4+YhuzrxprNcTFh1++Jyg0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 061/171] perf probe: Filter out instances except for inlined subroutine and subprogram
Date:   Thu,  2 Jan 2020 23:06:32 +0100
Message-Id: <20200102220555.346295410@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit da6cb952a89efe24bb76c4971370d485737a2d85 ]

Filter out instances except for inlined_subroutine and subprogram DIE in
die_walk_instances() and die_is_func_instance().

This fixes an issue that perf probe sets some probes on calling address
instead of a target function itself.

When perf probe walks on instances of an abstruct origin (a kind of
function prototype of inlined function), die_walk_instances() can also
pass a GNU_call_site (a GNU extension for call site) to callback. Since
it is not an inlined instance of target function, we have to filter out
when searching a probe point.

Without this patch, perf probe sets probes on call site address too.This
can happen on some function which is marked "inlined", but has actual
symbol. (I'm not sure why GCC mark it "inlined"):

  # perf probe -D vfs_read
  p:probe/vfs_read _text+2500017
  p:probe/vfs_read_1 _text+2499468
  p:probe/vfs_read_2 _text+2499563
  p:probe/vfs_read_3 _text+2498876
  p:probe/vfs_read_4 _text+2498512
  p:probe/vfs_read_5 _text+2498627

With this patch:

Slightly different results, similar tho:

  # perf probe -D vfs_read
  p:probe/vfs_read _text+2498512

Committer testing:

  # uname -a
  Linux quaco 5.3.8-200.fc30.x86_64 #1 SMP Tue Oct 29 14:46:22 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

Before:

  # perf probe -D vfs_read
  p:probe/vfs_read _text+3131557
  p:probe/vfs_read_1 _text+3130975
  p:probe/vfs_read_2 _text+3131047
  p:probe/vfs_read_3 _text+3130380
  p:probe/vfs_read_4 _text+3130000
  # uname -a
  Linux quaco 5.3.8-200.fc30.x86_64 #1 SMP Tue Oct 29 14:46:22 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
  #

After:

  # perf probe -D vfs_read
  p:probe/vfs_read _text+3130000
  #

Fixes: db0d2c6420ee ("perf probe: Search concrete out-of-line instances")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157241937063.32002.11024544873990816590.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 7eec3ae7b3c5..9b482477ddfe 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -322,18 +322,22 @@ bool die_is_func_def(Dwarf_Die *dw_die)
  * @dw_die: a DIE
  *
  * Ensure that this DIE is an instance (which has an entry address).
- * This returns true if @dw_die is a function instance. If not, you need to
- * call die_walk_instances() to find actual instances.
+ * This returns true if @dw_die is a function instance. If not, the @dw_die
+ * must be a prototype. You can use die_walk_instances() to find actual
+ * instances.
  **/
 bool die_is_func_instance(Dwarf_Die *dw_die)
 {
 	Dwarf_Addr tmp;
 	Dwarf_Attribute attr_mem;
+	int tag = dwarf_tag(dw_die);
 
-	/* Actually gcc optimizes non-inline as like as inlined */
-	return !dwarf_func_inline(dw_die) &&
-	       (dwarf_entrypc(dw_die, &tmp) == 0 ||
-		dwarf_attr(dw_die, DW_AT_ranges, &attr_mem) != NULL);
+	if (tag != DW_TAG_subprogram &&
+	    tag != DW_TAG_inlined_subroutine)
+		return false;
+
+	return dwarf_entrypc(dw_die, &tmp) == 0 ||
+		dwarf_attr(dw_die, DW_AT_ranges, &attr_mem) != NULL;
 }
 
 /**
@@ -612,6 +616,9 @@ static int __die_walk_instances_cb(Dwarf_Die *inst, void *data)
 	Dwarf_Die *origin;
 	int tmp;
 
+	if (!die_is_func_instance(inst))
+		return DIE_FIND_CB_CONTINUE;
+
 	attr = dwarf_attr(inst, DW_AT_abstract_origin, &attr_mem);
 	if (attr == NULL)
 		return DIE_FIND_CB_CONTINUE;
-- 
2.20.1



