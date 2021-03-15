Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBD033BADF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbhCOOKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234241AbhCOODG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77FE064EFD;
        Mon, 15 Mar 2021 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816986;
        bh=qWN0tpeZyplYUIYgezzOy80IpLdTww9WSjmeKYer3P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDXewo+JV7FQRwvN7xZ/XIZH835RvAPKqYuS3I1jgrU7OtbFq2VNhYPnwZF3xncc4
         mJ1wbFtWUcW/bedJHLfTfrAqV1jsENdhHHVwKRqCZgw0F4NOJAWHg48E8R2E02G+ov
         uvR57c71CGxyuQd8cIb1NB3ntZmFYxKqvcOE3iPA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 245/306] SUNRPC: Set memalloc_nofs_save() for sync tasks
Date:   Mon, 15 Mar 2021 14:55:08 +0100
Message-Id: <20210315135515.919800930@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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
index cf702a5f7fe5..39ed0e0afe6d 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -963,8 +963,11 @@ void rpc_execute(struct rpc_task *task)
 
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



