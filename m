Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E222624B517
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgHTKST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729486AbgHTKRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:17:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B231E2078D;
        Thu, 20 Aug 2020 10:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918640;
        bh=jqX5GocdlkyARVdF0q7LJBQWlacRZIf0cSo2DDLoUeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNn0rHewDTJM6+jvfbpv7T0i9/NzhfALQNcSWmnJQLcqApaBPW0o3E2ccXZabMn/z
         ExbvPvqRjDh6MxHD/CioT3QE17//ajrNV4/xTt+oT8xXNHHynPjsAfVoSYtDPszzZR
         xdoBdYVZO9pbfF3yXQlGPoy53rE2w2JA9OyaHSHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 014/149] rds: Prevent kernel-infoleak in rds_notify_queue_get()
Date:   Thu, 20 Aug 2020 11:21:31 +0200
Message-Id: <20200820092126.382688459@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit bbc8a99e952226c585ac17477a85ef1194501762 upstream.

rds_notify_queue_get() is potentially copying uninitialized kernel stack
memory to userspace since the compiler may leave a 4-byte hole at the end
of `cmsg`.

In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`, which
unfortunately does not always initialize that 4-byte hole. Fix it by using
memset() instead.

Cc: stable@vger.kernel.org
Fixes: f037590fff30 ("rds: fix a leak of kernel memory")
Fixes: bdbe6fbc6a2f ("RDS: recv.c")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rds/recv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -301,12 +301,13 @@ static int rds_still_queued(struct rds_s
 int rds_notify_queue_get(struct rds_sock *rs, struct msghdr *msghdr)
 {
 	struct rds_notifier *notifier;
-	struct rds_rdma_notify cmsg = { 0 }; /* fill holes with zero */
+	struct rds_rdma_notify cmsg;
 	unsigned int count = 0, max_messages = ~0U;
 	unsigned long flags;
 	LIST_HEAD(copy);
 	int err = 0;
 
+	memset(&cmsg, 0, sizeof(cmsg));	/* fill holes with zero */
 
 	/* put_cmsg copies to user space and thus may sleep. We can't do this
 	 * with rs_lock held, so first grab as many notifications as we can stuff


