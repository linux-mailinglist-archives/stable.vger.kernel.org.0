Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F29E3B7B03
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 02:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhF3Agu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 20:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235594AbhF3Agt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 20:36:49 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F97C061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 17:34:21 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id 5-20020ad45b850000b02902986d9b7d2fso193612qvp.15
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 17:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2XuTKmc5MiUcD3IttpZN1adwmf1E7UnKBnnfEh9asIE=;
        b=S4++qrlNREHISaDmUEHXPnvjr5JNiG3QxU1bd+U22BonKWasfFWISE4WFqMwbiGsro
         6FV0Vigj6cEo/YqiKaKGHFuTi5/GP3dFtgMn8pensTVybHIYMx5SCT98p5ax0lbpG6Lv
         NLmuLCLzBfMKL7t9zvocmdamq68VheY3xHWzI21GwZdQb99+LfuVabJayksQua8TW3Cd
         14UhcfOX2pvTuJ3r3FkM1pLZhRd6msii8QkXPNiy6ONLo0oq9zoDuChUl1OwHfr6QVgY
         mHG2dkeQUKtw6xd8Vd1/hGT5WHOVtb5J89HVi2MDGVsZJw4iByvzvejICUUp+Gki6hg/
         FX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2XuTKmc5MiUcD3IttpZN1adwmf1E7UnKBnnfEh9asIE=;
        b=Urw/EeI+PGeXBJFbqmk+RY8dS9BbR1mPon2uHopfwqeD9Ld0lJg6r9oefGpxKaHr+Y
         vt1HBHiRZrUWjYOWEQdyxS9gV5NCL9uaFcosocwO1gtcY0zbydjx6XArXI5pFiPZbDJG
         17x9GUgrbTO/3jxZEbbmW2gDQpxXRq5f1caDjJ8fVCm7sRaAxXnLMj9Pe+7YZHJa14FI
         Yq3KWXF/Z89+ZXc+sIgxeiAMN0XxN+aJM518vXhlUcoWWR8QVEuwHNGFYj99uKAY88up
         5uu0aPggtzsZe8pqGk/KrHMwqkQfcYIq/fI+DmZMUGcmeFazt6PbIo7SPnnr6qMiP2sm
         Pxlw==
X-Gm-Message-State: AOAM5305xiJZj2iHK83ROEMlfg83I+FT8Owg12dyXLY5w06hJ7GL7wxs
        sqIccJnqy6wpUibLONOQmw3R/aqvao56OeR8
X-Google-Smtp-Source: ABdhPJxYfIl/RsKi8Q1Y3mmzLWSHsPkK3ATLJmVUt286PIPfoCoSEuWaEF6ttquZPkAXgO/wXL2J9ADhN52OnMoR
X-Received: from paulburton.mtv.corp.google.com ([2620:15c:280:201:1517:9bca:ad4d:3b49])
 (user=paulburton job=sendgmr) by 2002:a0c:f885:: with SMTP id
 u5mr34153484qvn.28.1625013260689; Tue, 29 Jun 2021 17:34:20 -0700 (PDT)
Date:   Tue, 29 Jun 2021 17:34:06 -0700
In-Reply-To: <20210630003406.4013668-1-paulburton@google.com>
Message-Id: <20210630003406.4013668-2-paulburton@google.com>
Mime-Version: 1.0
References: <20210630003406.4013668-1-paulburton@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 2/2] tracing: Resize tgid_map to PID_MAX_LIMIT, not PID_MAX_DEFAULT
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

Currently tgid_map is sized at PID_MAX_DEFAULT entries, which means that
on systems where pid_max is configured higher than PID_MAX_DEFAULT the
ftrace record-tgid option doesn't work so well. Any tasks with PIDs
higher than PID_MAX_DEFAULT are simply not recorded in tgid_map, and
don't show up in the saved_tgids file.

In particular since systemd v243 & above configure pid_max to its
highest possible 1<<22 value by default on 64 bit systems this renders
the record-tgids option of little use.

Increase the size of tgid_map to PID_MAX_LIMIT instead, allowing it to
cover the full range of PIDs up to the maximum value of pid_max.

On 64 bit systems this will increase the size of tgid_map from 256KiB to
16MiB. Whilst this 64x increase in memory overhead sounds significant 64
bit systems are presumably best placed to accommodate it, and since
tgid_map is only allocated when the record-tgid option is actually used
presumably the user would rather it spends sufficient memory to actually
record the tgids they expect.

The size of tgid_map will also increase for CONFIG_BASE_SMALL=y
configurations, but these seem unlikely to be systems upon which people
are running ftrace with record-tgid anyway.

Signed-off-by: Paul Burton <paulburton@google.com>
Fixes: d914ba37d714 ("tracing: Add support for recording tgid of tasks")
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: <stable@vger.kernel.org>
---
 kernel/trace/trace.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9570667310bcc..c893c0c2754f8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2460,7 +2460,7 @@ void trace_find_cmdline(int pid, char comm[])
 
 int trace_find_tgid(int pid)
 {
-	if (unlikely(!tgid_map || !pid || pid > PID_MAX_DEFAULT))
+	if (unlikely(!tgid_map || !pid || pid > PID_MAX_LIMIT))
 		return 0;
 
 	return tgid_map[pid];
@@ -2472,7 +2472,7 @@ static int trace_save_tgid(struct task_struct *tsk)
 	if (!tsk->pid)
 		return 1;
 
-	if (unlikely(!tgid_map || tsk->pid > PID_MAX_DEFAULT))
+	if (unlikely(!tgid_map || tsk->pid > PID_MAX_LIMIT))
 		return 0;
 
 	tgid_map[tsk->pid] = tsk->tgid;
@@ -5194,7 +5194,7 @@ int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 
 	if (mask == TRACE_ITER_RECORD_TGID) {
 		if (!tgid_map)
-			tgid_map = kvcalloc(PID_MAX_DEFAULT + 1,
+			tgid_map = kvcalloc(PID_MAX_LIMIT + 1,
 					   sizeof(*tgid_map),
 					   GFP_KERNEL);
 		if (!tgid_map) {
@@ -5610,7 +5610,7 @@ static void *saved_tgids_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	int pid = ++(*pos);
 
-	if (pid > PID_MAX_DEFAULT)
+	if (pid > PID_MAX_LIMIT)
 		return NULL;
 
 	return &tgid_map[pid];
@@ -5618,7 +5618,7 @@ static void *saved_tgids_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *saved_tgids_start(struct seq_file *m, loff_t *pos)
 {
-	if (!tgid_map || *pos > PID_MAX_DEFAULT)
+	if (!tgid_map || *pos > PID_MAX_LIMIT)
 		return NULL;
 
 	return &tgid_map[*pos];
-- 
2.32.0.93.g670b81a890-goog

