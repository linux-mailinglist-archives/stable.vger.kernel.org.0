Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8065D15C1ED
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgBMP1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729483AbgBMP1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:43 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64014222C2;
        Thu, 13 Feb 2020 15:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607662;
        bh=qtD4kttmnNspxcI9KmmiufATSWlPGV+r4mNd/jnyryw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYXf8AMP0v49S4lFWNaVjz7UJzcnwgmngwtglpSUwVXl/dscV2UL/VJxE2wxw365R
         Slih14ANWQI3fn7Uo/DQSRHQtm/kgs7zwqwjTfAupZPXMSRWH9XjS5Zbtldk7dbM3o
         c+Gy2QuIqZEpGcrOjH909kAzlsttdkLQCczFmlt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Smythies <dsmythies@telus.net>,
        Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 64/96] sched/uclamp: Fix a bug in propagating uclamp value in new cgroups
Date:   Thu, 13 Feb 2020 07:21:11 -0800
Message-Id: <20200213151903.707374301@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

commit 7226017ad37a888915628e59a84a2d1e57b40707 upstream.

When a new cgroup is created, the effective uclamp value wasn't updated
with a call to cpu_util_update_eff() that looks at the hierarchy and
update to the most restrictive values.

Fix it by ensuring to call cpu_util_update_eff() when a new cgroup
becomes online.

Without this change, the newly created cgroup uses the default
root_task_group uclamp values, which is 1024 for both uclamp_{min, max},
which will cause the rq to to be clamped to max, hence cause the
system to run at max frequency.

The problem was observed on Ubuntu server and was reproduced on Debian
and Buildroot rootfs.

By default, Ubuntu and Debian create a cpu controller cgroup hierarchy
and add all tasks to it - which creates enough noise to keep the rq
uclamp value at max most of the time. Imitating this behavior makes the
problem visible in Buildroot too which otherwise looks fine since it's a
minimal userspace.

Fixes: 0b60ba2dd342 ("sched/uclamp: Propagate parent clamps")
Reported-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Doug Smythies <dsmythies@telus.net>
Link: https://lore.kernel.org/lkml/000701d5b965$361b6c60$a2524520$@net/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7090,6 +7090,12 @@ static int cpu_cgroup_css_online(struct
 
 	if (parent)
 		sched_online_group(tg, parent);
+
+#ifdef CONFIG_UCLAMP_TASK_GROUP
+	/* Propagate the effective uclamp value for the new group */
+	cpu_util_update_eff(css);
+#endif
+
 	return 0;
 }
 


