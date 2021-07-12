Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EAE3C53CA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348723AbhGLHz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350697AbhGLHvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 626CA6162B;
        Mon, 12 Jul 2021 07:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076043;
        bh=3BMOUWJejJduW2UzIqWBAgUkmgXjYvjL0s9iYRkbC9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jLtLc2zzHN+7GK2R/qdTDIgBrAGeNvKuxmoo/3D2NjtpoDhyrcqDGYGVceHBuSwQ
         xnpjeAnti5zXKQswo4yHOLl/z+e7ZbOKWOhxRMltMPZ/wc1ylNY2NMbtlqO8plctQ3
         aKbmK9Cxd6qvFyyP6eBFHzZfF5b0u7cNExQ3//9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@ionos.com>,
        Md Haris Iqbal <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 431/800] RDMA/rtrs-srv: Fix memory leak of unfreed rtrs_srv_stats object
Date:   Mon, 12 Jul 2021 08:07:34 +0200
Message-Id: <20210712061012.929319179@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gioh Kim <gi-oh.kim@cloud.ionos.com>

[ Upstream commit 2371c40354509746e4a4dad09a752e027a30f148 ]

When closing a session, currently the rtrs_srv_stats object in the
closing session is freed by kobject release. But if it failed
to create a session by various reasons, it must free the rtrs_srv_stats
object directly because kobject is not created yet.

This problem is found by kmemleak as below:

1. One client machine maps /dev/nullb0 with session name 'bla':
root@test1:~# echo "sessname=bla path=ip:192.168.122.190 \
device_path=/dev/nullb0" > /sys/devices/virtual/rnbd-client/ctl/map_device

2. Another machine failed to create a session with the same name 'bla':
root@test2:~# echo "sessname=bla path=ip:192.168.122.190 \
device_path=/dev/nullb1" > /sys/devices/virtual/rnbd-client/ctl/map_device
-bash: echo: write error: Connection reset by peer

3. The kmemleak on server machine reported an error:
unreferenced object 0xffff888033cdc800 (size 128):
  comm "kworker/2:1", pid 83, jiffies 4295086585 (age 2508.680s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000a72903b2>] __alloc_sess+0x1d4/0x1250 [rtrs_server]
    [<00000000d1e5321e>] rtrs_srv_rdma_cm_handler+0xc31/0xde0 [rtrs_server]
    [<00000000bb2f6e7e>] cma_ib_req_handler+0xdc5/0x2b50 [rdma_cm]
    [<00000000e896235d>] cm_process_work+0x2d/0x100 [ib_cm]
    [<00000000b6866c5f>] cm_req_handler+0x11bc/0x1c40 [ib_cm]
    [<000000005f5dd9aa>] cm_work_handler+0xe65/0x3cf2 [ib_cm]
    [<00000000610151e7>] process_one_work+0x4bc/0x980
    [<00000000541e0f77>] worker_thread+0x78/0x5c0
    [<00000000423898ca>] kthread+0x191/0x1e0
    [<000000005a24b239>] ret_from_fork+0x3a/0x50

Fixes: 39c2d639ca183 ("RDMA/rtrs-srv: Set .release function for rtrs srv device during device init")
Link: https://lore.kernel.org/r/20210528113018.52290-18-jinpu.wang@ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 0fa116cabc44..62f59ccb327c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1481,6 +1481,7 @@ static void free_sess(struct rtrs_srv_sess *sess)
 		kobject_del(&sess->kobj);
 		kobject_put(&sess->kobj);
 	} else {
+		kfree(sess->stats);
 		kfree(sess);
 	}
 }
-- 
2.30.2



