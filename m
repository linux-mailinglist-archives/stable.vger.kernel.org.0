Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5012326B60D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgIOX4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbgIOOba (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6859C22B43;
        Tue, 15 Sep 2020 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179765;
        bh=oPhh2NJPahvZMCpXAiSyGJyx2+YSZOj7l0wRRGhGyp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxgQJZUCKt+o0j5bkJGxfvMzwe29N8E5h4lG2ZZYMCddeJpnMZVbsa/u0FHTzUtGZ
         ub9pPxRcKOKkIC6xrQ0s1/agpAcXAPCGoiqtkVEf6mXJeLZENKbzmK1gGE32FOv7pi
         Uz6ugcOJ6W7G9OUG40hMKeOG+mHY/RDKA4UWvvMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5.4 110/132] RDMA/rxe: Fix the parent sysfs read when the interface has 15 chars
Date:   Tue, 15 Sep 2020 16:13:32 +0200
Message-Id: <20200915140649.633717622@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Zhang <yi.zhang@redhat.com>

commit 60b1af64eb35074a4f2d41cc1e503a7671e68963 upstream.

'parent' sysfs reads will yield '\0' bytes when the interface name has 15
chars, and there will no "\n" output.

To reproduce, create one interface with 15 chars:

 [root@test ~]# ip a s enp0s29u1u7u3c2
 2: enp0s29u1u7u3c2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
     link/ether 02:21:28:57:47:17 brd ff:ff:ff:ff:ff:ff
     inet6 fe80::ac41:338f:5bcd:c222/64 scope link noprefixroute
        valid_lft forever preferred_lft forever
 [root@test ~]# modprobe rdma_rxe
 [root@test ~]# echo enp0s29u1u7u3c2 > /sys/module/rdma_rxe/parameters/add
 [root@test ~]# cat /sys/class/infiniband/rxe0/parent
 enp0s29u1u7u3c2[root@test ~]#
 [root@test ~]# f="/sys/class/infiniband/rxe0/parent"
 [root@test ~]# echo "$(<"$f")"
 -bash: warning: command substitution: ignored null byte in input
 enp0s29u1u7u3c2

Use scnprintf and PAGE_SIZE to fill the sysfs output buffer.

Cc: stable@vger.kernel.org
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20200820153646.31316-1-yi.zhang@redhat.com
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/sw/rxe/rxe_verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1078,7 +1078,7 @@ static ssize_t parent_show(struct device
 	struct rxe_dev *rxe =
 		rdma_device_to_drv_device(device, struct rxe_dev, ib_dev);
 
-	return snprintf(buf, 16, "%s\n", rxe_parent_name(rxe, 1));
+	return scnprintf(buf, PAGE_SIZE, "%s\n", rxe_parent_name(rxe, 1));
 }
 
 static DEVICE_ATTR_RO(parent);


