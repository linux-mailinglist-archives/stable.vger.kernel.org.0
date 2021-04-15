Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D15360C9F
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbhDOOwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhDOOvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B733613C1;
        Thu, 15 Apr 2021 14:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498268;
        bh=HPuqvidDJ8JOu/ztHPpa7knjrlZvsLIhK2ifuXy5ccw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fS/hKtD85pivxJxj+bevtXkwY7CLWvPnq1VO6rtb96VrLN1rq+ub3FWmGiahTMxCf
         nUsb1a3Fk/qOQbkLU0uvww4+yIIWFO2MKZGbxWwQqqZa8hD1oRFd9VqDUngISZHO7C
         U+JjUVMNOTcoh3gUM+Ac3kdPlQW5UxhoznyoouFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang.zhang@windriver.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 23/47] workqueue: Move the position of debug_work_activate() in __queue_work()
Date:   Thu, 15 Apr 2021 16:47:15 +0200
Message-Id: <20210415144414.197213846@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

[ Upstream commit 0687c66b5f666b5ad433f4e94251590d9bc9d10e ]

The debug_work_activate() is called on the premise that
the work can be inserted, because if wq be in WQ_DRAINING
status, insert work may be failed.

Fixes: e41e704bc4f4 ("workqueue: improve destroy_workqueue() debuggability")
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 205c3131f8b0..3231088afd73 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1377,7 +1377,6 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 	 */
 	WARN_ON_ONCE(!irqs_disabled());
 
-	debug_work_activate(work);
 
 	/* if draining, only works from the same workqueue are allowed */
 	if (unlikely(wq->flags & __WQ_DRAINING) &&
@@ -1460,6 +1459,7 @@ retry:
 		worklist = &pwq->delayed_works;
 	}
 
+	debug_work_activate(work);
 	insert_work(pwq, work, worklist, work_flags);
 
 	spin_unlock(&pwq->pool->lock);
-- 
2.30.2



