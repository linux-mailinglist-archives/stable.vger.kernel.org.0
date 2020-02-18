Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B5B163187
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgBRUB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbgBRUBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:01:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C7302464E;
        Tue, 18 Feb 2020 20:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056083;
        bh=Tn/SrJ/oXq7x45pUrAWtvbL//v+33hRQW4wAMEPfRO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rf5EiqX91Tol+al3gQiToxUXQqtDX/eTvQjTr0GfEEQJkZFoQpc8NpZCN8nlTqcVo
         cDNWIB/Ei/uO3HRRxVJnhD6tinN0PNhSGIqqkScz/BJPQ0l1OSmQWOzJ758eW1sbYy
         RxUVSwd//T9z9Tw453jKDcbr6jYkxlU1496tuqxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.5 28/80] cgroup: init_tasks shouldnt be linked to the root cgroup
Date:   Tue, 18 Feb 2020 20:54:49 +0100
Message-Id: <20200218190435.137599128@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 0cd9d33ace336bc424fc30944aa3defd6786e4fe upstream.

5153faac18d2 ("cgroup: remove cgroup_enable_task_cg_lists()
optimization") removed lazy initialization of css_sets so that new
tasks are always lniked to its css_set. In the process, it incorrectly
ended up adding init_tasks to root css_set. They show up as PID 0's in
root's cgroup.procs triggering warnings in systemd and generally
confusing people.

Fix it by skip css_set linking for init_tasks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: https://github.com/joanbm
Link: https://github.com/systemd/systemd/issues/14682
Fixes: 5153faac18d2 ("cgroup: remove cgroup_enable_task_cg_lists() optimization")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/cgroup.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5932,11 +5932,14 @@ void cgroup_post_fork(struct task_struct
 
 	spin_lock_irq(&css_set_lock);
 
-	WARN_ON_ONCE(!list_empty(&child->cg_list));
-	cset = task_css_set(current); /* current is @child's parent */
-	get_css_set(cset);
-	cset->nr_tasks++;
-	css_set_move_task(child, NULL, cset, false);
+	/* init tasks are special, only link regular threads */
+	if (likely(child->pid)) {
+		WARN_ON_ONCE(!list_empty(&child->cg_list));
+		cset = task_css_set(current); /* current is @child's parent */
+		get_css_set(cset);
+		cset->nr_tasks++;
+		css_set_move_task(child, NULL, cset, false);
+	}
 
 	/*
 	 * If the cgroup has to be frozen, the new task has too.  Let's set


