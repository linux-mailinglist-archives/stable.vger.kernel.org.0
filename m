Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED98F12C94F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732278AbfL2SE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:04:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732220AbfL2RwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB133222C2;
        Sun, 29 Dec 2019 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641928;
        bh=pLsgxWNJvbghniWp7z7nohCuoUtmIhEYAlzHukQh+TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrjFiHe+hyPDEsv1yL02fBHp5Ypty8NREEbxH3rBo5Vm7LyX+mLpD1aYZyWErBJGC
         l6wXO4GtMHN4Vrhgn7opQ1VPWkUsmUy4XMDzdv8mnvdKvs30wF91niOetnZ1LNWoqh
         rw1kjjw+CYwfQfSAYh0zOML+TAPPLWLdIIN5rFr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Honglei Wang <honglei.wang@oracle.com>,
        Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 269/434] cgroup: freezer: dont change task and cgroups status unnecessarily
Date:   Sun, 29 Dec 2019 18:25:22 +0100
Message-Id: <20191229172719.806673971@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Honglei Wang <honglei.wang@oracle.com>

[ Upstream commit 742e8cd3e1ba6f19cad6d912f8d469df5557d0fd ]

It's not necessary to adjust the task state and revisit the state
of source and destination cgroups if the cgroups are not in freeze
state and the task itself is not frozen.

And in this scenario, it wakes up the task who's not supposed to be
ready to run.

Don't do the unnecessary task state adjustment can help stop waking
up the task without a reason.

Signed-off-by: Honglei Wang <honglei.wang@oracle.com>
Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/freezer.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
index 8cf010680678..3984dd6b8ddb 100644
--- a/kernel/cgroup/freezer.c
+++ b/kernel/cgroup/freezer.c
@@ -230,6 +230,15 @@ void cgroup_freezer_migrate_task(struct task_struct *task,
 	if (task->flags & PF_KTHREAD)
 		return;
 
+	/*
+	 * It's not necessary to do changes if both of the src and dst cgroups
+	 * are not freezing and task is not frozen.
+	 */
+	if (!test_bit(CGRP_FREEZE, &src->flags) &&
+	    !test_bit(CGRP_FREEZE, &dst->flags) &&
+	    !task->frozen)
+		return;
+
 	/*
 	 * Adjust counters of freezing and frozen tasks.
 	 * Note, that if the task is frozen, but the destination cgroup is not
-- 
2.20.1



