Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4753733B916
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhCOOFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229743AbhCOOBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 906E164F0C;
        Mon, 15 Mar 2021 14:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816838;
        bh=fg8Q1EYWAk3JgG7ZOKsNwOrprZ0nqJY0OgF5mVDigTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfD6YL/Xdyo/HbNZyZ9gp0v6RPetwkqDH3FDB5OI1LIOvjxY3u7zRQ1sotEK+ZSEu
         oYCJF6bdIBVxPc79mkXI/cafNDLnujavBzSXpPW1NGDiiqqwMzZckBJF58yipDpo0K
         vnAAgXiaT3i25edOnfHYrdiiYrUmq8gJWGY7qrTo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/168] SUNRPC: Set memalloc_nofs_save() for sync tasks
Date:   Mon, 15 Mar 2021 14:56:17 +0100
Message-Id: <20210315135555.106561418@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit f0940f4b3284a00f38a5d42e6067c2aaa20e1f2e ]

We could recurse into NFS doing memory reclaim while sending a sync task,
which might result in a deadlock.  Set memalloc_nofs_save for sync task
execution.

Fixes: a1231fda7e94 ("SUNRPC: Set memalloc_nofs_save() on all rpciod/xprtiod jobs")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sched.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 7afbf15bcbd9..4beb6d2957c3 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -990,8 +990,11 @@ void rpc_execute(struct rpc_task *task)
 
 	rpc_set_active(task);
 	rpc_make_runnable(rpciod_workqueue, task);
-	if (!is_async)
+	if (!is_async) {
+		unsigned int pflags = memalloc_nofs_save();
 		__rpc_execute(task);
+		memalloc_nofs_restore(pflags);
+	}
 }
 
 static void rpc_async_schedule(struct work_struct *work)
-- 
2.30.1



