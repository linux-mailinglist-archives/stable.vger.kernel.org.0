Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB322ABA16
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732928AbgKINPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:15:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731747AbgKINPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B0F20663;
        Mon,  9 Nov 2020 13:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927732;
        bh=9BZkkRYeoLO3NL6o/mrCxp7EIqeom7WzrhpCxzTC3w0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QiTqq+6qTZlzncS7twOHvnvGPxOa9+86ZecDvebGwQGJ1J/+HioifTlsxGnU5rPa
         otok+zubvKsCh+IE/OgLvcaQE0hMZAIXRKBgDMiOQLnANfijD8iWfM7X1KGmXWb3B4
         VkqQp/+01wSsetH6zRbVxTIGbgKOlwT72GnPJCPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddy Wu <eddy_wu@trendmicro.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 65/85] fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent
Date:   Mon,  9 Nov 2020 13:56:02 +0100
Message-Id: <20201109125025.691526755@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
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
@@ -2100,14 +2100,9 @@ static __latent_entropy struct task_stru
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
-			p->exit_signal = args->exit_signal;
 		p->group_leader = p;
 		p->tgid = p->pid;
 	}
@@ -2152,9 +2147,14 @@ static __latent_entropy struct task_stru
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
+		p->exit_signal = args->exit_signal;
 	}
 
 	klp_copy_process(p);


