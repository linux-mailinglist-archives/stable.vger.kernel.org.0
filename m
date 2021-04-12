Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3638235C0C6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241378AbhDLJP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240965AbhDLJLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0B04613A3;
        Mon, 12 Apr 2021 09:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218450;
        bh=DF/lz2vT1oh+WXNnBjaQ+scZsXybX5ZDB1HNslqX6gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szh29L16PuZ57xqXl/ki2O9w9cTCTyRsVXfsPn4AUDbrgftZ2veLlwHyeOWuLUTK2
         w5sPLtX/Has95TmVG+wM7JKnVlcXCugZPEb2T+M/bHdILjgLaj7J5xIfnkGCetIJr/
         TZk/kYVyJSdReMuoEma/ZG3uJjoqygt8XgFvqOuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang.zhang@windriver.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 168/210] workqueue: Move the position of debug_work_activate() in __queue_work()
Date:   Mon, 12 Apr 2021 10:41:13 +0200
Message-Id: <20210412084021.623305757@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
index 894bb885b40b..6326a872510b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1412,7 +1412,6 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 	 */
 	lockdep_assert_irqs_disabled();
 
-	debug_work_activate(work);
 
 	/* if draining, only works from the same workqueue are allowed */
 	if (unlikely(wq->flags & __WQ_DRAINING) &&
@@ -1494,6 +1493,7 @@ retry:
 		worklist = &pwq->delayed_works;
 	}
 
+	debug_work_activate(work);
 	insert_work(pwq, work, worklist, work_flags);
 
 out:
-- 
2.30.2



