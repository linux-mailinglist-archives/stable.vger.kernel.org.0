Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3ED35BEB6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbhDLJBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238832AbhDLI5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5493E6127A;
        Mon, 12 Apr 2021 08:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217793;
        bh=MWmaNCMF6yGs7d8i/lDwaN/Ia5bmFCUaZrpseqKPWYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sx9e7CUQjKmJUHgoxYpnTOyZUQEHmVwzK6b/CRn2wxF9LRAqXvZ9PxxiR8s3wH8Xi
         3lyytlfkidXdhVYKkOBXf6RqAH2fOWkCfIZ46C7X1vDaYhOgOCsz0bFVSd3lwdR+DD
         S+QBjGGzesG2DuQhrAAhw7MCTxxhr6dRZMnnXd3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang.zhang@windriver.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/188] workqueue: Move the position of debug_work_activate() in __queue_work()
Date:   Mon, 12 Apr 2021 10:41:02 +0200
Message-Id: <20210412084018.543794327@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index 1d99c52cc99a..1e2ca744dadb 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1409,7 +1409,6 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 	 */
 	lockdep_assert_irqs_disabled();
 
-	debug_work_activate(work);
 
 	/* if draining, only works from the same workqueue are allowed */
 	if (unlikely(wq->flags & __WQ_DRAINING) &&
@@ -1491,6 +1490,7 @@ retry:
 		worklist = &pwq->delayed_works;
 	}
 
+	debug_work_activate(work);
 	insert_work(pwq, work, worklist, work_flags);
 
 out:
-- 
2.30.2



