Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476742A585E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731524AbgKCUsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:48:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731521AbgKCUsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E7D22404;
        Tue,  3 Nov 2020 20:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436512;
        bh=XpVGLq94+KKOiYrxhWttVWeedqtom3bFNP9WqutPqzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbgb9COxxFf44OtXKjUetUeVpioJqWMkOex9+ecgqVEiQwEik5L9ITKPmQg8ePNxY
         5ylGW2o2Vu3ph52KksEYK6oHl+80m2nXucFoucffxcEUI2nWkPct8DjCVmf8kgWleP
         haAOzuFC0e8MoflvVSYQk7Sa63wXSSnCuAsQZKT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>, bpf@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.9 282/391] rcu-tasks: Enclose task-list scan in rcu_read_lock()
Date:   Tue,  3 Nov 2020 21:35:33 +0100
Message-Id: <20201103203406.066176422@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit f747c7e15d7bc71a967a94ceda686cf2460b69e8 upstream.

The rcu_tasks_trace_postgp() function uses for_each_process_thread()
to scan the task list without the benefit of RCU read-side protection,
which can result in use-after-free errors on task_struct structures.
This error was missed because the TRACE01 rcutorture scenario enables
lockdep, but also builds with CONFIG_PREEMPT_NONE=y.  In this situation,
preemption is disabled everywhere, so lockdep thinks everywhere can
be a legitimate RCU reader.  This commit therefore adds the needed
rcu_read_lock() and rcu_read_unlock().

Note that this bug can occur only after an RCU Tasks Trace CPU stall
warning, which by default only happens after a grace period has extended
for ten minutes (yes, not a typo, minutes).

Fixes: 4593e772b502 ("rcu-tasks: Add stall warnings for RCU Tasks Trace")
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: <bpf@vger.kernel.org>
Cc: <stable@vger.kernel.org> # 5.7.x
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcu/tasks.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1078,9 +1078,11 @@ static void rcu_tasks_trace_postgp(struc
 		if (ret)
 			break;  // Count reached zero.
 		// Stall warning time, so make a list of the offenders.
+		rcu_read_lock();
 		for_each_process_thread(g, t)
 			if (READ_ONCE(t->trc_reader_special.b.need_qs))
 				trc_add_holdout(t, &holdouts);
+		rcu_read_unlock();
 		firstreport = true;
 		list_for_each_entry_safe(t, g, &holdouts, trc_holdout_list) {
 			if (READ_ONCE(t->trc_reader_special.b.need_qs))


