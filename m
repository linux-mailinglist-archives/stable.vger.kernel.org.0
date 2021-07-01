Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A983B8EF9
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 10:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbhGAInW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 04:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbhGAInV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 04:43:21 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1211C0617AD
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 01:40:51 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id b6-20020a05620a1186b02903b429a7ee4bso3106276qkk.4
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 01:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5iHoNZMOeP6TxsWwP/0krCRRwCbLGs4FQeU+EZRnVpw=;
        b=FMpj5JxuvGNfBzF6vXgu2ty+hfpspeI/EDm3LJYTsJoaCNE3k6TVARsbPBxXFX4nWm
         1HoNvamktFRK3begTvvzpfatrEad5S90Acr/VAL1gvywFra+8hYcXivsK0/KDNEQmoL+
         Vfqp6Ej0zCR4SHWdJKdm0irz/YBGo4kKOJyhXv7XrFMuCtX7xJfrRIGY7RGmQMtl2ifu
         dm8fMDH76QKCAL5NJBWJXdxOoqNHMBdk5/w03UE3OnrblaMwURXPUro8tyjfXesNsIeB
         tJIHFJqgIgZzyVsNbxUVFSlBS3fFw7lBxxoX5x3NbOv5OZ4Xm2qPiN7EUtBzyqiN9TXX
         oSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5iHoNZMOeP6TxsWwP/0krCRRwCbLGs4FQeU+EZRnVpw=;
        b=DLi/mJ2fkj/actBQtMXHqTV4iiPWvdnqJkMdglDvV1uCLcAHiGqQyPvHUjsFv+bFlP
         xl2RhoQ5H5TYTJrUAVESftLIMqMCSKrzUmWuhtgIX4m3oxgFfz8ROARQcHIJ2VrVkpO3
         /t2azuI3xfCCVkDs3o3KKGra8J2Ex7HaQ++S8dYtz0ghjP5IwjIVhdUk5e60RpTSS48K
         7uahgTZKWy2KsVyGLplAVUUR+nIim6DYsh3EUnTGo8zF+GIwA/BNx63Q8CcCeb5dFkp5
         lMirqfjipQOw2z8dgUjXv7isRP3sw3VPBH6xHlIO/DWCHsdOCVNb33tW9Ly8yEC4MLFm
         qatw==
X-Gm-Message-State: AOAM531gjXe9NnvrmSazICcH/RdrhOxDSELFBwsZ6OHkWUs22x2BrlYU
        sGoPqWOr0dxGtAZa6eUMIzyyl72eag==
X-Google-Smtp-Source: ABdhPJzh0BWd6kKdTshLd8GOa6BvrBKw2SUY1e5kpAyenT4O3KV55wn97GNSQeSm1oacAHDSzUhCAtKGzg==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:15:13:8b0e:c57f:ff29:7e4])
 (user=elver job=sendgmr) by 2002:ad4:4ba4:: with SMTP id i4mr34049163qvw.42.1625128850422;
 Thu, 01 Jul 2021 01:40:50 -0700 (PDT)
Date:   Thu,  1 Jul 2021 10:38:43 +0200
Message-Id: <20210701083842.580466-1-elver@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2] perf: Require CAP_KILL if sigtrap is requested
From:   Marco Elver <elver@google.com>
To:     elver@google.com, peterz@infradead.org
Cc:     tglx@linutronix.de, mingo@kernel.org, kasan-dev@googlegroups.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org,
        linux-perf-users@vger.kernel.org, ebiederm@xmission.com,
        omosnace@redhat.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If perf_event_open() is called with another task as target and
perf_event_attr::sigtrap is set, and the target task's user does not
match the calling user, also require the CAP_KILL capability.

Otherwise, with the CAP_PERFMON capability alone it would be possible
for a user to send SIGTRAP signals via perf events to another user's
tasks. This could potentially result in those tasks being terminated if
they cannot handle SIGTRAP signals.

Note: The check complements the existing capability check, but is not
supposed to supersede the ptrace_may_access() check. At a high level we
now have:

	capable of CAP_PERFMON and (CAP_KILL if sigtrap)
		OR
	ptrace_may_access() // also checks for same thread-group and uid

Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
Cc: <stable@vger.kernel.org> # 5.13+
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Drop kill_capable() and just check CAP_KILL (reported by Ondrej Mosnacek).
* Use ns_capable(__task_cred(task)->user_ns, CAP_KILL) to check for
  capability in target task's ns (reported by Ondrej Mosnacek).
---
 kernel/events/core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fe88d6eea3c2..43c99695dc3f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12152,10 +12152,23 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	if (task) {
+		bool is_capable;
+
 		err = down_read_interruptible(&task->signal->exec_update_lock);
 		if (err)
 			goto err_file;
 
+		is_capable = perfmon_capable();
+		if (attr.sigtrap) {
+			/*
+			 * perf_event_attr::sigtrap sends signals to the other
+			 * task. Require the current task to have CAP_KILL.
+			 */
+			rcu_read_lock();
+			is_capable &= ns_capable(__task_cred(task)->user_ns, CAP_KILL);
+			rcu_read_unlock();
+		}
+
 		/*
 		 * Preserve ptrace permission check for backwards compatibility.
 		 *
@@ -12165,7 +12178,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * perf_event_exit_task() that could imply).
 		 */
 		err = -EACCES;
-		if (!perfmon_capable() && !ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
+		if (!is_capable && !ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
 			goto err_cred;
 	}
 
-- 
2.32.0.93.g670b81a890-goog

