Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F85413F8FD
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbgAPQx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730974AbgAPQx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C19620730;
        Thu, 16 Jan 2020 16:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193609;
        bh=qgdOWZabXt34xWiRajR8PsmrAsWphHFAb8ZMnR3Iz04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9n3K1vHPw6MjKkLYKzl9coeE4SGCs1pHNzNGkhi7hhOX7j9rcXmpNdLd3F+VYxim
         fsP45elqLdJ/kNORovcF2yftxxG8zv9PgapRBFPynJcAcIyJb3P5KVJgojgQS9vq1T
         NSuBsFBaOsCb5Nrr0nWslzuKxkWoFyo3MaEgCIVY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 147/205] workqueue: Add RCU annotation for pwq list walk
Date:   Thu, 16 Jan 2020 11:42:02 -0500
Message-Id: <20200116164300.6705-147-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 649687622654..e9c63b79e03f 100644
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

