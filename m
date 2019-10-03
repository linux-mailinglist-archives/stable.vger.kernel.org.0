Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37DCCA6B6
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732438AbfJCQqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392934AbfJCQqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:46:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB9802070B;
        Thu,  3 Oct 2019 16:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121197;
        bh=Iz/rm/WQRpcIwAOXL0oPExQ24VLEz8gHHqZ2wCq1jig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyGYDJR6c+hy8pByW54y3l/yY+15uZoZkrSPN76b058IC6fR7c+0RqOCt9oyGbDkQ
         ZJeELNXm05PqtUlnPbsQcvehQPfNtC+AFPJmjzZmAW9eFz5VgYjzXycc+Zb8caSxUs
         O6S5SbmJ8Jtc1rId6+Z4oajpFGuWcbGCZ8euFTCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 191/344] closures: fix a race on wakeup from closure_sync
Date:   Thu,  3 Oct 2019 17:52:36 +0200
Message-Id: <20191003154559.039135993@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Overstreet <kent.overstreet@gmail.com>

[ Upstream commit a22a9602b88fabf10847f238ff81fde5f906fef7 ]

The race was when a thread using closure_sync() notices cl->s->done == 1
before the thread calling closure_put() calls wake_up_process(). Then,
it's possible for that thread to return and exit just before
wake_up_process() is called - so we're trying to wake up a process that
no longer exists.

rcu_read_lock() is sufficient to protect against this, as there's an rcu
barrier somewhere in the process teardown path.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Acked-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/closure.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 73f5319295bc9..c12cd809ab193 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -105,8 +105,14 @@ struct closure_syncer {
 
 static void closure_sync_fn(struct closure *cl)
 {
-	cl->s->done = 1;
-	wake_up_process(cl->s->task);
+	struct closure_syncer *s = cl->s;
+	struct task_struct *p;
+
+	rcu_read_lock();
+	p = READ_ONCE(s->task);
+	s->done = 1;
+	wake_up_process(p);
+	rcu_read_unlock();
 }
 
 void __sched __closure_sync(struct closure *cl)
-- 
2.20.1



