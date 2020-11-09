Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB4A2ABBF1
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbgKINcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731246AbgKINHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:07:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B8122076E;
        Mon,  9 Nov 2020 13:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927224;
        bh=GFIFI44qs4r6l4lmcWfvQhJQNiQN67Chm1RWxlpTfHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zC2IEcZDI5OM/i/dV8dRmg2muWa3XS9LXuCYcUcsVMEShRBHjx1DEMH6MJQ2p2KFr
         iJnJfuzShGRthJQIz8at2NGhvRa+mbrC9sLIZHDCoAXEq0J5QBP9ttmk1u0WeWX9Ez
         cFQYhiovPIS4SJJXzNXfRXhqLjQtwm6r5Jj+rWUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddy Wu <eddy_wu@trendmicro.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 36/48] fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent
Date:   Mon,  9 Nov 2020 13:55:45 +0100
Message-Id: <20201109125018.531280982@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddy Wu <itseddy0402@gmail.com>

commit b4e00444cab4c3f3fec876dc0cccc8cbb0d1a948 upstream.

current->group_leader->exit_signal may change during copy_process() if
current->real_parent exits.

Move the assignment inside tasklist_lock to avoid the race.

Signed-off-by: Eddy Wu <eddy_wu@trendmicro.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1833,14 +1833,9 @@ static __latent_entropy struct task_stru
 	/* ok, now we should be set up.. */
 	p->pid = pid_nr(pid);
 	if (clone_flags & CLONE_THREAD) {
-		p->exit_signal = -1;
 		p->group_leader = current->group_leader;
 		p->tgid = current->tgid;
 	} else {
-		if (clone_flags & CLONE_PARENT)
-			p->exit_signal = current->group_leader->exit_signal;
-		else
-			p->exit_signal = (clone_flags & CSIGNAL);
 		p->group_leader = p;
 		p->tgid = p->pid;
 	}
@@ -1885,9 +1880,14 @@ static __latent_entropy struct task_stru
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
 		p->parent_exec_id = current->parent_exec_id;
+		if (clone_flags & CLONE_THREAD)
+			p->exit_signal = -1;
+		else
+			p->exit_signal = current->group_leader->exit_signal;
 	} else {
 		p->real_parent = current;
 		p->parent_exec_id = current->self_exec_id;
+		p->exit_signal = (clone_flags & CSIGNAL);
 	}
 
 	klp_copy_process(p);


