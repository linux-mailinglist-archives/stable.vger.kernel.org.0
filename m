Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3F335BDAE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbhDLIw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238426AbhDLItq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE7A461350;
        Mon, 12 Apr 2021 08:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217324;
        bh=n/7MHTp6tYd7007gylry+xCIh7YKgDN4hJmNcnE/37g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uu9w+x2MbLv1NxwJbgl8VHGiYHyLNrAJ8D37OFwmbGJcChFGzz3V0o0uzYkA0fcc1
         2wr87QdkbgoIJtDzcVne4g2pWSYgbcGVwMssfo7DC+GNqwYRz7LJXKueALFbOKrBXa
         8VmelZDBQ7rmit7I8TiDL1Y8u9RcIhUDTgW2dcN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang.zhang@windriver.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/111] workqueue: Move the position of debug_work_activate() in __queue_work()
Date:   Mon, 12 Apr 2021 10:41:02 +0200
Message-Id: <20210412084007.056688641@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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
index 29c36c029062..5d7092e32912 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1411,7 +1411,6 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 	 */
 	lockdep_assert_irqs_disabled();
 
-	debug_work_activate(work);
 
 	/* if draining, only works from the same workqueue are allowed */
 	if (unlikely(wq->flags & __WQ_DRAINING) &&
@@ -1493,6 +1492,7 @@ retry:
 		worklist = &pwq->delayed_works;
 	}
 
+	debug_work_activate(work);
 	insert_work(pwq, work, worklist, work_flags);
 
 out:
-- 
2.30.2



