Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA843DA522
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbhG2N6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238315AbhG2N6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99C6760F4A;
        Thu, 29 Jul 2021 13:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567078;
        bh=iV3Yb5axYYsQ5pqiV/xMJrY0IaK3V+phWVfNomDkOlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZTpIVM9w6ktfK4Ym3H5Iy9vgYj7I0aovuI8WzWkSUNo8w+8NnuNISFpzwvodO6RJ
         sIX8Hwm4XPtKAKTTciYbNYco7VlpjIwlqWlh8ScCD6uvVR/pQLhGvINrf6l0USIOGp
         jDZ3oW2XUxf4MMLhFHlO+ww6X37FwwE6vSnpV24A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Xu, Yanfei" <yanfei.xu@windriver.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/24] rcu-tasks: Dont delete holdouts within trc_inspect_reader()
Date:   Thu, 29 Jul 2021 15:54:31 +0200
Message-Id: <20210729135137.616116362@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
References: <20210729135137.267680390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 1d10bf55d85d34eb73dd8263635f43fd72135d2d ]

As Yanfei pointed out, although invoking trc_del_holdout() is safe
from the viewpoint of the integrity of the holdout list itself,
the put_task_struct() invoked by trc_del_holdout() can result in
use-after-free errors due to later accesses to this task_struct structure
by the RCU Tasks Trace grace-period kthread.

This commit therefore removes this call to trc_del_holdout() from
trc_inspect_reader() in favor of the grace-period thread's existing call
to trc_del_holdout(), thus eliminating that particular class of
use-after-free errors.

Reported-by: "Xu, Yanfei" <yanfei.xu@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 73bbe792fe1e..208acb286ec2 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -879,10 +879,9 @@ static bool trc_inspect_reader(struct task_struct *t, void *arg)
 		in_qs = likely(!t->trc_reader_nesting);
 	}
 
-	// Mark as checked.  Because this is called from the grace-period
-	// kthread, also remove the task from the holdout list.
+	// Mark as checked so that the grace-period kthread will
+	// remove it from the holdout list.
 	t->trc_reader_checked = true;
-	trc_del_holdout(t);
 
 	if (in_qs)
 		return true;  // Already in quiescent state, done!!!
-- 
2.30.2



