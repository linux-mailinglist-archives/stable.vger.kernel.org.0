Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7413B7B01
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 02:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhF3Agq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 20:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235456AbhF3Agp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 20:36:45 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C475EC061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 17:34:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a4-20020a25f5040000b029054df41d5cceso1463969ybe.18
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 17:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=EzPaScwUubSRz3YLFbBEVgjUC7R/UR9eloiiDUGtRi8=;
        b=S7TBI94l8clCQeeMdulVExy1SHCtXED/se2J7cXW8DTJw3IjXqOONlGpcBBmm7A22C
         9JhxRAaNd/zMIuqrKYXtsvQaaZuqrUJo0zss1vuHOhOPsfOjIFEY1GDUt2Zz4wYICZtx
         SRUOpynmq8TRlIIaGQQ50N+LwXLr0kzvK6fgGnIF0RDbGS78o20Rh4FeBoE9lGk0P6dh
         AwI7gfEN+YccAuRwWvtKJch8kbjgC7Hy7u3WmT+s9HiH6wSvZzUTt7ZjzZ9AawiPW4Fi
         AIe153llj61l9qAVffmfBGpCD5ThlvE2lOfbZ4S8SJ+LFcXd0+vMl9QLj9q6CBhsxSZq
         hsYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=EzPaScwUubSRz3YLFbBEVgjUC7R/UR9eloiiDUGtRi8=;
        b=jBBaXDTe5gOnMcVijEh+MYpJW0+mIb7BGZXndaLR+rWqvmojngu3zg1plPHNpJXVJ0
         Z91ReOphk4F1eva3D2JkUYHdFGyTpd9KXuzi/bXmFJ7MySEkXg9C/DnuzfN4XiLEvuz1
         ML8FFUJkwu/iXcdcyDS9Xg9rRVuh4rmrVQnPCVEnd1Vwz+QykcG2OwskcLLFJLl/bkfd
         ihcTduEiAFvgJ2+xu/lULH63+2kI34WQj1P6L+gec8fSJC78pEXlrs7F2HeLoxOd0cKR
         mqDSnNpnmjOhYYl6JaZdtg+gRcXXphpSppXjYGIpXjhK0QxGOcHrQxo9STKqtvSMVcW7
         JO2g==
X-Gm-Message-State: AOAM533FG45oGBQqlst4IgpzaO0f5hsc3F5n1/9Dv7GL/82HLAtUuW2J
        Zv8sPunKmC+kubz+9Nd0Z6NcAu/0VK81/Khx
X-Google-Smtp-Source: ABdhPJy1LGw05qpeX8ewnRHiyyf0hr4XcIzghqPtvXNpWiMPvxggz/lEW3Pi1FGfi9LCUdSRGuw8ULSLyUvlJMj2
X-Received: from paulburton.mtv.corp.google.com ([2620:15c:280:201:1517:9bca:ad4d:3b49])
 (user=paulburton job=sendgmr) by 2002:a25:dac9:: with SMTP id
 n192mr25469824ybf.37.1625013255034; Tue, 29 Jun 2021 17:34:15 -0700 (PDT)
Date:   Tue, 29 Jun 2021 17:34:05 -0700
Message-Id: <20210630003406.4013668-1-paulburton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
From:   Paul Burton <paulburton@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paul Burton <paulburton@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The tgid_map array records a mapping from pid to tgid, where the index
of an entry within the array is the pid & the value stored at that index
is the tgid.

The saved_tgids_next() function iterates over pointers into the tgid_map
array & dereferences the pointers which results in the tgid, but then it
passes that dereferenced value to trace_find_tgid() which treats it as a
pid & does a further lookup within the tgid_map array. It seems likely
that the intent here was to skip over entries in tgid_map for which the
recorded tgid is zero, but instead we end up skipping over entries for
which the thread group leader hasn't yet had its own tgid recorded in
tgid_map.

A minimal fix would be to remove the call to trace_find_tgid, turning:

  if (trace_find_tgid(*ptr))

into:

  if (*ptr)

..but it seems like this logic can be much simpler if we simply let
seq_read() iterate over the whole tgid_map array & filter out empty
entries by returning SEQ_SKIP from saved_tgids_show(). Here we take that
approach, removing the incorrect logic here entirely.

Signed-off-by: Paul Burton <paulburton@google.com>
Fixes: d914ba37d714 ("tracing: Add support for recording tgid of tasks")
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: <stable@vger.kernel.org>
---
 kernel/trace/trace.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d23a09d3eb37b..9570667310bcc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5608,37 +5608,20 @@ static const struct file_operations tracing_readme_fops = {
 
 static void *saved_tgids_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	int *ptr = v;
+	int pid = ++(*pos);
 
-	if (*pos || m->count)
-		ptr++;
-
-	(*pos)++;
-
-	for (; ptr <= &tgid_map[PID_MAX_DEFAULT]; ptr++) {
-		if (trace_find_tgid(*ptr))
-			return ptr;
-	}
+	if (pid > PID_MAX_DEFAULT)
+		return NULL;
 
-	return NULL;
+	return &tgid_map[pid];
 }
 
 static void *saved_tgids_start(struct seq_file *m, loff_t *pos)
 {
-	void *v;
-	loff_t l = 0;
-
-	if (!tgid_map)
+	if (!tgid_map || *pos > PID_MAX_DEFAULT)
 		return NULL;
 
-	v = &tgid_map[0];
-	while (l <= *pos) {
-		v = saved_tgids_next(m, v, &l);
-		if (!v)
-			return NULL;
-	}
-
-	return v;
+	return &tgid_map[*pos];
 }
 
 static void saved_tgids_stop(struct seq_file *m, void *v)
@@ -5647,9 +5630,14 @@ static void saved_tgids_stop(struct seq_file *m, void *v)
 
 static int saved_tgids_show(struct seq_file *m, void *v)
 {
-	int pid = (int *)v - tgid_map;
+	int *entry = (int *)v;
+	int pid = entry - tgid_map;
+	int tgid = *entry;
+
+	if (tgid == 0)
+		return SEQ_SKIP;
 
-	seq_printf(m, "%d %d\n", pid, trace_find_tgid(pid));
+	seq_printf(m, "%d %d\n", pid, tgid);
 	return 0;
 }
 

base-commit: 62fb9874f5da54fdb243003b386128037319b219
-- 
2.32.0.93.g670b81a890-goog

