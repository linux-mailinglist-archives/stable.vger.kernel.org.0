Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3C4BA96E
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbfIVTPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394605AbfIVS4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:56:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4220721BE5;
        Sun, 22 Sep 2019 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178598;
        bh=Iz/rm/WQRpcIwAOXL0oPExQ24VLEz8gHHqZ2wCq1jig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGqVVwzXz8AsSUqjv1zYsEyyC/JHG4W//N1cnY7mwTwYZjDGsvTAJpjn7Z6L4gSdt
         ERC7ogwxwVre51GiHddWr4+JU2Ot2+lXv1aavMtVETcLq1nXE++8MwRP+6Xa0RBLzd
         h5lMIFWPqYCRs3Fd3Gmi5nNU1SfAautz3UWZZIyU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 102/128] closures: fix a race on wakeup from closure_sync
Date:   Sun, 22 Sep 2019 14:53:52 -0400
Message-Id: <20190922185418.2158-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

