Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2882ACDC5
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732752AbgKJDyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732790AbgKJDyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E4482080A;
        Tue, 10 Nov 2020 03:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980478;
        bh=MuUFQjytzdImRGQQgf24CJp/Rkji6rxTwI5chX3Bluo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3Z2hhcJY2CAIAI+BEtDVCZTtKxeBwmpdBl71fj/skXpkKr+E/Mqfaa0yepv5BatQ
         bGbwkS+TeOQbGw5qrLywtmqvrAD5pbaAvv7rlWE2i8pKfyKGtbgBfGHCFNX3D97jDk
         KLZQVK7CJrAk0kXZI/6K0te4uyoncq9UdLkhVObo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eddy Wu <itseddy0402@gmail.com>, Eddy Wu <eddy_wu@trendmicro.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 55/55] fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent
Date:   Mon,  9 Nov 2020 22:53:18 -0500
Message-Id: <20201110035318.423757-55-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddy Wu <itseddy0402@gmail.com>

[ Upstream commit b4e00444cab4c3f3fec876dc0cccc8cbb0d1a948 ]

current->group_leader->exit_signal may change during copy_process() if
current->real_parent exits.

Move the assignment inside tasklist_lock to avoid the race.

Signed-off-by: Eddy Wu <eddy_wu@trendmicro.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8934886d16549..5fe09d4e6d6a0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2167,14 +2167,9 @@ static __latent_entropy struct task_struct *copy_process(
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
@@ -2218,9 +2213,14 @@ static __latent_entropy struct task_struct *copy_process(
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
-- 
2.27.0

