Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD4C3B956C
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 19:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhGAR0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 13:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbhGAR0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 13:26:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49556C061762
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 10:24:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v184-20020a257ac10000b02904f84a5c5297so9631740ybc.16
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 10:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W+yNXXd/sg5bPnMG2widlIL5j/blFdFa+1fW6PCvTrY=;
        b=Bhfx27LQ0RjZ0y8IYfAXVvXGTR4DzeM+8nLGds/UaofotENeKPUTQCxkK47YTSnf/q
         HZ5DWFhZQm8E1S1GP0987jeT2DZDblhWqmL0xsApweZRVdBg2aOhl/lE0tknIpfEX+om
         AZ+8woXC6FLAffO+mgr344d+UIu8XdkQ2RbQuAol84DEs9FcOa53Xq6XsXoxlD3Ej790
         4JER2lVCiHR6Xw2+V/ZWDAVr2XGpMq2dsKgrzNOHDHbaaK/y2TzmqWk8lxCXrtdW7qkz
         DiZEO6d0uLWLprV38Pb9mc/p8UIwcOVbGV005Esz7nFpzL/fwscRKJyUa4Y913JRBF3F
         ElKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W+yNXXd/sg5bPnMG2widlIL5j/blFdFa+1fW6PCvTrY=;
        b=U29OZjMfk3pnhLTl6Hr3k0wzANR0d62A+NQoOYIh9KUqEaVXfGrGy6YMpjIpfWMV4P
         eeUxBedtG2xkRwQTQe3r1x1yXj5h+83Xy1rWJB4yWSh3E6MZY20GdLWPxAXZhoA4zY2Z
         mJFQG/tiy+YtZqUctokF8OFjpZMf9wnHm+63De+uHuqVY9Wr7InAGjgpY9xXZqMK7JKe
         NIF8k6nnXyzDS52zINA/hNFFNb+LGL+PFGNzIrkMvPYFbDxPyQ0GmeO3yKf0YAvA34Md
         mZRqk+QaMHYi4nLw8NpO5FPH6Caz5TKM3nrgwI8DWkbD8APU44r+rK6A77GvwB7bYr50
         EWfA==
X-Gm-Message-State: AOAM530gsDUYRot8o9uxmOV6O6Hy/lf7XilMWXDxtCREB7/X4QRdmYe/
        qDqjfnapnV+Q5ieLkEtC4+PwypGz489y7aBp
X-Google-Smtp-Source: ABdhPJyz7zVQc6WT9tGwAUSqYMLpintRtDgSOaOx3pqUXRNAodmPXxTpYoG+FPVO9E9Fb2d/4z1tud7OxUX/wY6+
X-Received: from paulburton.mtv.corp.google.com ([2620:15c:280:201:558a:406a:d453:dbe5])
 (user=paulburton job=sendgmr) by 2002:a25:a225:: with SMTP id
 b34mr1015554ybi.485.1625160253483; Thu, 01 Jul 2021 10:24:13 -0700 (PDT)
Date:   Thu,  1 Jul 2021 10:24:06 -0700
In-Reply-To: <20210701095525.400839d3@oasis.local.home>
Message-Id: <20210701172407.889626-1-paulburton@google.com>
Mime-Version: 1.0
References: <20210701095525.400839d3@oasis.local.home>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 1/2] tracing: Simplify & fix saved_tgids logic
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
Changes in v2:
- Add comments describing why we know tgid_map is non-NULL in
  saved_tgids_next() & saved_tgids_start().
---
 kernel/trace/trace.c | 45 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d23a09d3eb37..7a37c9e36b88 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5608,37 +5608,23 @@ static const struct file_operations tracing_readme_fops = {
 
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
+	// We already know that tgid_map is non-NULL here because the v
+	// argument is by definition a non-NULL pointer into tgid_map returned
+	// by saved_tgids_start() or an earlier call to saved_tgids_next().
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
@@ -5647,9 +5633,18 @@ static void saved_tgids_stop(struct seq_file *m, void *v)
 
 static int saved_tgids_show(struct seq_file *m, void *v)
 {
-	int pid = (int *)v - tgid_map;
+	int *entry = (int *)v;
+	int pid, tgid;
+
+	// We already know that tgid_map is non-NULL here because the v
+	// argument is by definition a non-NULL pointer into tgid_map returned
+	// by saved_tgids_start() or saved_tgids_next().
+	pid = entry - tgid_map;
+	tgid = *entry;
+	if (tgid == 0)
+		return SEQ_SKIP;
 
-	seq_printf(m, "%d %d\n", pid, trace_find_tgid(pid));
+	seq_printf(m, "%d %d\n", pid, tgid);
 	return 0;
 }
 

base-commit: 62fb9874f5da54fdb243003b386128037319b219
-- 
2.32.0.93.g670b81a890-goog

