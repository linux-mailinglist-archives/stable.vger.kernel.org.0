Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9AE869DB
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405497AbfHHTLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405511AbfHHTLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:11:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 812012184E;
        Thu,  8 Aug 2019 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291494;
        bh=aA4NlhqRdzaZLnxk3Me8hAUpVSOE5IDr/BhVKV2QNNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o02omHFrmEKFldU3VWj4Fi2HYELlK34ZGHOTBaDVXku4e2vtrf4yXlT8uWzW//1rn
         07FRdCm6wLs6O8s8Ub7jFbql96P+vmg0ZAG5co8QHlrwtE3HKVPPplNua9gYNtO7hG
         P5bBBswcfoEgqgAi/SvDhvo4b/HYlNzLrSeLxzzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 4.14 28/33] cgroup: Call cgroup_release() before __exit_signal()
Date:   Thu,  8 Aug 2019 21:05:35 +0200
Message-Id: <20190808190455.054993030@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.582417307@linuxfoundation.org>
References: <20190808190453.582417307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 6b115bf58e6f013ca75e7115aabcbd56c20ff31d upstream.

cgroup_release() calls cgroup_subsys->release() which is used by the
pids controller to uncharge its pid.  We want to use it to manage
iteration of dying tasks which requires putting it before
__unhash_process().  Move cgroup_release() above __exit_signal().
While this makes it uncharge before the pid is freed, pid is RCU freed
anyway and the window is very narrow.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -193,6 +193,7 @@ repeat:
 	rcu_read_unlock();
 
 	proc_flush_task(p);
+	cgroup_release(p);
 
 	write_lock_irq(&tasklist_lock);
 	ptrace_release_task(p);
@@ -218,7 +219,6 @@ repeat:
 	}
 
 	write_unlock_irq(&tasklist_lock);
-	cgroup_release(p);
 	release_thread(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);
 


