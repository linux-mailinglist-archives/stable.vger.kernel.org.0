Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FBE4173F4
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345629AbhIXNBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345126AbhIXM7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DA4D613B1;
        Fri, 24 Sep 2021 12:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487995;
        bh=lrbHMYERLXU/qGcXpigoRnBLMmFoyGeV50UkXrU+G4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2G3ZqP7PGgx0Y+GJ/4yh0r0BdGhCjiZVR5kocy42/CYf5KnZEZObkMmfv6c3PnO+W
         56sTR5T/4KwBhglQLT4ZsWhLRvwBOQ6ELbuOBNpr3yArOtwXw6R0SQLBuv7Pw7sl39
         d2wR3rZ8xA3iM7zDrPksWz5Tkq7Rz2LXoscxPBcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Mel Gorman <mgorman@suse.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Mike Javorski <mike.javorski@gmail.com>,
        Lothar Paltins <lopa@mailbox.org>
Subject: [PATCH 5.14 035/100] SUNRPC: dont pause on incomplete allocation
Date:   Fri, 24 Sep 2021 14:43:44 +0200
Message-Id: <20210924124342.639456329@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit e38b3f20059426a0adbde014ff71071739ab5226 ]

alloc_pages_bulk_array() attempts to allocate at least one page based on
the provided pages, and then opportunistically allocates more if that
can be done without dropping the spinlock.

So if it returns fewer than requested, that could just mean that it
needed to drop the lock.  In that case, try again immediately.

Only pause for a time if no progress could be made.

Reported-and-tested-by: Mike Javorski <mike.javorski@gmail.com>
Reported-and-tested-by: Lothar Paltins <lopa@mailbox.org>
Fixes: f6e70aab9dfe ("SUNRPC: refresh rq_pages using a bulk page allocator")
Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Mel Gorman <mgorman@suse.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc_xprt.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index dbb41821b1b8..cd5a2b186f0d 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -662,7 +662,7 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
 {
 	struct svc_serv *serv = rqstp->rq_server;
 	struct xdr_buf *arg = &rqstp->rq_arg;
-	unsigned long pages, filled;
+	unsigned long pages, filled, ret;
 
 	pages = (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
 	if (pages > RPCSVC_MAXPAGES) {
@@ -672,11 +672,12 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
 		pages = RPCSVC_MAXPAGES;
 	}
 
-	for (;;) {
-		filled = alloc_pages_bulk_array(GFP_KERNEL, pages,
-						rqstp->rq_pages);
-		if (filled == pages)
-			break;
+	for (filled = 0; filled < pages; filled = ret) {
+		ret = alloc_pages_bulk_array(GFP_KERNEL, pages,
+					     rqstp->rq_pages);
+		if (ret > filled)
+			/* Made progress, don't sleep yet */
+			continue;
 
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (signalled() || kthread_should_stop()) {
-- 
2.33.0



