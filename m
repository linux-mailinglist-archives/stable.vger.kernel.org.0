Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBB3272D41
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgIUQif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729114AbgIUQiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:38:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 590D4238EE;
        Mon, 21 Sep 2020 16:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706303;
        bh=OB6E9YQNC9G0IHnrJsWk7F4uIibOH09LZsdA+Y2YVpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LatMboJNzKwE7Ee88Dbu4oIfD2icof3Ry4UGsSUuaShpyNm+EFFEUuBRjfiD7qoRw
         txVuiLbCd0yR5c2g2QpKCqPkfAf9wxy5Vk3stE8O15Cmk972pVg1ezR/582ILYWt8x
         CEZgiDx4+u8G2QW4BOknl4NtPT8t1Y1ZvH1PQeVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4.14 46/94] RDMA/rxe: Fix the parent sysfs read when the interface has 15 chars
Date:   Mon, 21 Sep 2020 18:27:33 +0200
Message-Id: <20200921162037.664354069@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -1178,7 +1178,7 @@ static ssize_t parent_show(struct device
 	struct rxe_dev *rxe = container_of(device, struct rxe_dev,
 					   ib_dev.dev);
 
-	return snprintf(buf, 16, "%s\n", rxe_parent_name(rxe, 1));
+	return scnprintf(buf, PAGE_SIZE, "%s\n", rxe_parent_name(rxe, 1));
 }
 
 static DEVICE_ATTR_RO(parent);


