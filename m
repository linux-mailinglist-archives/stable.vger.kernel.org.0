Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7BC7119B04
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbfLJWE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:04:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbfLJWEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2DC321D7D;
        Tue, 10 Dec 2019 22:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015493;
        bh=czWuvlV9URtwlCcqjfP+/2aCPH16Qa+KXq7McMfhOnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClRxLnnxXg9v+V/bPXHnG1XDUJCQzdimEfl15szfMT1tNmv8cq8p/VLEHs8bIdIGT
         BT6RQW0n0Lqwx4Qrno2C6ntWqgIKgcEcVcx+oZiQTbNam85auWA3lK6KPdklata09A
         L1FzL10mXvHjk4Ta0pcJCz8YZa98gB4uv7hojS18=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 094/130] perf probe: Fix to show calling lines of inlined functions
Date:   Tue, 10 Dec 2019 17:02:25 -0500
Message-Id: <20191210220301.13262-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0a5de865563cf..49f9c65f1a9c1 100644
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

