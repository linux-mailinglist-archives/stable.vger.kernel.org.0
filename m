Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1D0147B36
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbgAXJlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:41:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731809AbgAXJlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:41:45 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49C3820718;
        Fri, 24 Jan 2020 09:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858905;
        bh=sDI6lGzmww86chtQAgCBVr2HYzxBsS5wuFzI9E7yLr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5yCG5lRNop9QGPcgkpRExKJ7WNaOaMzM8gcakZRVj0rqhFtKvY9oCmEE5fSrryP7
         8p3mVCiwklwFuAv3WePZGtp+dApN7UcsOciBBBWaXAAWU/w+N9j7I1kJmFEmNzW1M7
         3PfNIoNdrcVYI5f+XU8PzBygjXKN5eQ5uN5S3RSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/102] workqueue: Add RCU annotation for pwq list walk
Date:   Fri, 24 Jan 2020 10:31:28 +0100
Message-Id: <20200124092819.804917979@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 49e9d1a9faf2f71fdfd80a30697ee9a15070626d ]

An additional check has been recently added to ensure that a RCU related lock
is held while the RCU list is iterated.
The `pwqs' are sometimes iterated without a RCU lock but with the &wq->mutex
acquired leading to a warning.

Teach list_for_each_entry_rcu() that the RCU usage is okay if &wq->mutex
is acquired during the list traversal.

Fixes: 28875945ba98d ("rcu: Add support for consolidated-RCU reader checking")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 649687622654b..e9c63b79e03f4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -425,7 +425,8 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
  * ignored.
  */
 #define for_each_pwq(pwq, wq)						\
-	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
+	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node,		\
+				lockdep_is_held(&wq->mutex))		\
 		if (({ assert_rcu_or_wq_mutex(wq); false; })) { }	\
 		else
 
-- 
2.20.1



