Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C10312C4D1
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfL2RdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbfL2RdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:33:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A780208E4;
        Sun, 29 Dec 2019 17:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640786;
        bh=5/itrn6Nr/PixQUzBml95YTj552i/pvao5+j+0U9oCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVq0v+EAVSVhRIFXv7De2ebF5L4NxLdVxxuHqgc6RAQK6xy4ETEHaRjJ8h6yZmv0Y
         5AhLsMdoPrsUHuFt9/DvIR2RHjw/d6Z5kGhKJuZ6iTjN1lMCz4NTbHoD9iA80YVSje
         RfjWvtbHyLZmDcupcEimwqqcNZbH+05KegQqBx5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/219] perf probe: Fix to show calling lines of inlined functions
Date:   Sun, 29 Dec 2019 18:19:01 +0100
Message-Id: <20191229162529.416335211@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 86c0bf8539e7f46d91bd105e55eda96e0064caef ]

Fix to show calling lines of inlined functions (where an inline function
is called).

die_walk_lines() filtered out the lines inside inlined functions based
on the address. However this also filtered out the lines which call
those inlined functions from the target function.

To solve this issue, check the call_file and call_line attributes and do
not filter out if it matches to the line information.

Without this fix, perf probe -L doesn't show some lines correctly.
(don't see the lines after 17)

  # perf probe -L vfs_read
  <vfs_read@/home/mhiramat/ksrc/linux/fs/read_write.c:0>
        0  ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
        1  {
        2         ssize_t ret;

        4         if (!(file->f_mode & FMODE_READ))
                          return -EBADF;
        6         if (!(file->f_mode & FMODE_CAN_READ))
                          return -EINVAL;
        8         if (unlikely(!access_ok(buf, count)))
                          return -EFAULT;

       11         ret = rw_verify_area(READ, file, pos, count);
       12         if (!ret) {
       13                 if (count > MAX_RW_COUNT)
                                  count =  MAX_RW_COUNT;
       15                 ret = __vfs_read(file, buf, count, pos);
       16                 if (ret > 0) {
                                  fsnotify_access(file);
                                  add_rchar(current, ret);
                          }

With this fix:

  # perf probe -L vfs_read
  <vfs_read@/home/mhiramat/ksrc/linux/fs/read_write.c:0>
        0  ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
        1  {
        2         ssize_t ret;

        4         if (!(file->f_mode & FMODE_READ))
                          return -EBADF;
        6         if (!(file->f_mode & FMODE_CAN_READ))
                          return -EINVAL;
        8         if (unlikely(!access_ok(buf, count)))
                          return -EFAULT;

       11         ret = rw_verify_area(READ, file, pos, count);
       12         if (!ret) {
       13                 if (count > MAX_RW_COUNT)
                                  count =  MAX_RW_COUNT;
       15                 ret = __vfs_read(file, buf, count, pos);
       16                 if (ret > 0) {
       17                         fsnotify_access(file);
       18                         add_rchar(current, ret);
                          }
       20                 inc_syscr(current);
                  }

Fixes: 4cc9cec636e7 ("perf probe: Introduce lines walker interface")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/157241937995.32002.17899884017011512577.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index fc3f3573332d..7ae3106b4e5e 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -768,7 +768,7 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 	Dwarf_Lines *lines;
 	Dwarf_Line *line;
 	Dwarf_Addr addr;
-	const char *fname, *decf = NULL;
+	const char *fname, *decf = NULL, *inf = NULL;
 	int lineno, ret = 0;
 	int decl = 0, inl;
 	Dwarf_Die die_mem, *cu_die;
@@ -812,13 +812,21 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 			 */
 			if (!dwarf_haspc(rt_die, addr))
 				continue;
+
 			if (die_find_inlinefunc(rt_die, addr, &die_mem)) {
+				/* Call-site check */
+				inf = die_get_call_file(&die_mem);
+				if ((inf && !strcmp(inf, decf)) &&
+				    die_get_call_lineno(&die_mem) == lineno)
+					goto found;
+
 				dwarf_decl_line(&die_mem, &inl);
 				if (inl != decl ||
 				    decf != dwarf_decl_file(&die_mem))
 					continue;
 			}
 		}
+found:
 		/* Get source line */
 		fname = dwarf_linesrc(line, NULL, NULL);
 
-- 
2.20.1



