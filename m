Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF06449911F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353896AbiAXUJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:09:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60202 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347024AbiAXUDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:03:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2917B6132F;
        Mon, 24 Jan 2022 20:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011F9C340E5;
        Mon, 24 Jan 2022 20:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054625;
        bh=QaemAATjchbPUysn33dPWc1b6QtCHkameZcT4eNz62Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQ2QXWbLVwr5rGoQlktUwy+Rz/7dZeGoaV60VVH53ZWi02PgZ4uHogrUuiH9mD13j
         KYOYXls8hLOsQriXgR27YtSnc0b+HkCgUXgC+15xB84O6DhLx7KpEopt4qKZ+cfFyf
         xD525ErRjqLoiTPd9ReTWGQlU7JPWM9+IuWipoww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <arbn@yandex-team.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 450/563] cputime, cpuacct: Include guest time in user time in cpuacct.stat
Date:   Mon, 24 Jan 2022 19:43:35 +0100
Message-Id: <20220124184040.016661631@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <arbn@yandex-team.com>

commit 9731698ecb9c851f353ce2496292ff9fcea39dff upstream.

cpuacct.stat in no-root cgroups shows user time without guest time
included int it. This doesn't match with user time shown in root
cpuacct.stat and /proc/<pid>/stat. This also affects cgroup2's cpu.stat
in the same way.

Make account_guest_time() to add user time to cgroup's cpustat to
fix this.

Fixes: ef12fefabf94 ("cpuacct: add per-cgroup utime/stime statistics")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211115164607.23784-1-arbn@yandex-team.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cputime.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -147,10 +147,10 @@ void account_guest_time(struct task_stru
 
 	/* Add guest time to cpustat. */
 	if (task_nice(p) > 0) {
-		cpustat[CPUTIME_NICE] += cputime;
+		task_group_account_field(p, CPUTIME_NICE, cputime);
 		cpustat[CPUTIME_GUEST_NICE] += cputime;
 	} else {
-		cpustat[CPUTIME_USER] += cputime;
+		task_group_account_field(p, CPUTIME_USER, cputime);
 		cpustat[CPUTIME_GUEST] += cputime;
 	}
 }


