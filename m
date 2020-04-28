Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333A41BC7C4
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgD1S0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbgD1S0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:26:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 034C42173E;
        Tue, 28 Apr 2020 18:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098397;
        bh=xh5jasGP+qlz4q1zVydQmxu/W7eq4W6XizMxpF9rPFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2oXbecdZaYvQOjfInc1oslhOej23y+WEMzPVEq+B3IRgxDwRNu3KaeDFNpfYmurn
         M6MaRzpjLr+IVqDMN66nqUAtBbKOjxqSEUW4pud5R5Guxj1EloLa15fOUp3iOh1MNj
         Xv+DFX5hqeERwsQPugeejkcQk3/hEex7fWjsQysc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Waiman Long <longman@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, NeilBrown <neilb@suse.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 023/167] ipc/util.c: sysvipc_find_ipc() should increase position index
Date:   Tue, 28 Apr 2020 20:23:19 +0200
Message-Id: <20200428182228.105979287@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 89163f93c6f969da5811af5377cc10173583123b ]

If seq_file .next function does not change position index, read after
some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/b7a20945-e315-8bb0-21e6-3875c14a8494@virtuozzo.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/util.c b/ipc/util.c
index fe61df53775ac..2d70f25f64b83 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -764,13 +764,13 @@ static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
 			total++;
 	}
 
+	*new_pos = pos + 1;
 	if (total >= ids->in_use)
 		return NULL;
 
 	for (; pos < ipc_mni; pos++) {
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
-			*new_pos = pos + 1;
 			rcu_read_lock();
 			ipc_lock_object(ipc);
 			return ipc;
-- 
2.20.1



