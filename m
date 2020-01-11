Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C9E1380A3
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731479AbgAKKc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731348AbgAKKc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:32:28 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A4A920880;
        Sat, 11 Jan 2020 10:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738748;
        bh=jpqiTu4Vr8eMbp5uH9Vomf7i+fxQLjfnRDi+IJs+3zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8TYDmvDCeapAIHF3mJp2r8mG+MeBxZ0Za1cZG2qrIcqE4fXEiBQbRzlbKHIfHCit
         9SlJUGiIE1si+VdpSdDAzFvp257mCCUvVXP+4LmQ/v5pvOMk4OvuzfiEzZHsUk/JN4
         8U749555qqBUKrNBYxsP93CUnJq50DCjTA0DXnTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        David Jeffery <djeffery@redhat.com>,
        John Pittman <jpittman@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/165] sbitmap: only queue kybers wait callback if not already active
Date:   Sat, 11 Jan 2020 10:50:49 +0100
Message-Id: <20200111094935.853087757@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Jeffery <djeffery@redhat.com>

[ Upstream commit df034c93f15ee71df231ff9fe311d27ff08a2a52 ]

Under heavy loads where the kyber I/O scheduler hits the token limits for
its scheduling domains, kyber can become stuck.  When active requests
complete, kyber may not be woken up leaving the I/O requests in kyber
stuck.

This stuck state is due to a race condition with kyber and the sbitmap
functions it uses to run a callback when enough requests have completed.
The running of a sbt_wait callback can race with the attempt to insert the
sbt_wait.  Since sbitmap_del_wait_queue removes the sbt_wait from the list
first then sets the sbq field to NULL, kyber can see the item as not on a
list but the call to sbitmap_add_wait_queue will see sbq as non-NULL. This
results in the sbt_wait being inserted onto the wait list but ws_active
doesn't get incremented.  So the sbitmap queue does not know there is a
waiter on a wait list.

Since sbitmap doesn't think there is a waiter, kyber may never be
informed that there are domain tokens available and the I/O never advances.
With the sbt_wait on a wait list, kyber believes it has an active waiter
so cannot insert a new waiter when reaching the domain's full state.

This race can be fixed by only adding the sbt_wait to the queue if the
sbq field is NULL.  If sbq is not NULL, there is already an action active
which will trigger the re-running of kyber.  Let it run and add the
sbt_wait to the wait list if still needing to wait.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Reported-by: John Pittman <jpittman@redhat.com>
Tested-by: John Pittman <jpittman@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/sbitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 969e5400a615..ee3ce1494568 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -667,8 +667,8 @@ void sbitmap_add_wait_queue(struct sbitmap_queue *sbq,
 	if (!sbq_wait->sbq) {
 		sbq_wait->sbq = sbq;
 		atomic_inc(&sbq->ws_active);
+		add_wait_queue(&ws->wait, &sbq_wait->wait);
 	}
-	add_wait_queue(&ws->wait, &sbq_wait->wait);
 }
 EXPORT_SYMBOL_GPL(sbitmap_add_wait_queue);
 
-- 
2.20.1



