Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DE43C4DE4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243404AbhGLHPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238322AbhGLHOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:14:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6878361360;
        Mon, 12 Jul 2021 07:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073870;
        bh=5b0iAY5F7Q91YLfIK4i8Qn7hc8U7Yr6r9gRXIEuwfiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlHNyi7LPrrbfw28GQzpsFGzmuiIkEILpRb10wokoM89erQr3/6Uv+WH6FSSFpDD0
         6N1LXtoBypxmqw/XI2wVs+SEAGDl86ieHvSdwNSJPV+bEmeEfhpCCGsx0qPQDQYT47
         jVmMP5dODTYPhTcMsm36XuU+soat/zKQhFgbx8w4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 386/700] RDMA/rtrs-srv: Fix memory leak when having multiple sessions
Date:   Mon, 12 Jul 2021 08:07:49 +0200
Message-Id: <20210712061017.450108785@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit 6bb97a2c1aa5278a30d49abb6186d50c34c207e2 ]

Gioh notice memory leak below
unreferenced object 0xffff8880acda2000 (size 2048):
  comm "kworker/4:1", pid 77, jiffies 4295062871 (age 1270.730s)
  hex dump (first 32 bytes):
    00 20 da ac 80 88 ff ff 00 20 da ac 80 88 ff ff  . ....... ......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e85d85b5>] rtrs_srv_rdma_cm_handler+0x8e5/0xa90 [rtrs_server]
    [<00000000e31a988a>] cma_ib_req_handler+0xdc5/0x2b50 [rdma_cm]
    [<000000000eb02c5b>] cm_process_work+0x2d/0x100 [ib_cm]
    [<00000000e1650ca9>] cm_req_handler+0x11bc/0x1c40 [ib_cm]
    [<000000009c28818b>] cm_work_handler+0xe65/0x3cf2 [ib_cm]
    [<000000002b53eaa1>] process_one_work+0x4bc/0x980
    [<00000000da3499fb>] worker_thread+0x78/0x5c0
    [<00000000167127a4>] kthread+0x191/0x1e0
    [<0000000060802104>] ret_from_fork+0x3a/0x50
unreferenced object 0xffff88806d595d90 (size 8):
  comm "kworker/4:1H", pid 131, jiffies 4295062972 (age 1269.720s)
  hex dump (first 8 bytes):
    62 6c 61 00 6b 6b 6b a5                          bla.kkk.
  backtrace:
    [<000000004447d253>] kstrdup+0x2e/0x60
    [<0000000047259793>] kobject_set_name_vargs+0x2f/0xb0
    [<00000000c2ee3bc8>] dev_set_name+0xab/0xe0
    [<000000002b6bdfb1>] rtrs_srv_create_sess_files+0x260/0x290 [rtrs_server]
    [<0000000075d87bd7>] rtrs_srv_info_req_done+0x71b/0x960 [rtrs_server]
    [<00000000ccdf1bb5>] __ib_process_cq+0x94/0x100 [ib_core]
    [<00000000cbcb60cb>] ib_cq_poll_work+0x32/0xc0 [ib_core]
    [<000000002b53eaa1>] process_one_work+0x4bc/0x980
    [<00000000da3499fb>] worker_thread+0x78/0x5c0
    [<00000000167127a4>] kthread+0x191/0x1e0
    [<0000000060802104>] ret_from_fork+0x3a/0x50
unreferenced object 0xffff88806d6bb100 (size 256):
  comm "kworker/4:1H", pid 131, jiffies 4295062972 (age 1269.720s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 00 59 4d 86 ff ff ff ff  .........YM.....
  backtrace:
    [<00000000a18a11e4>] device_add+0x74d/0xa00
    [<00000000a915b95f>] rtrs_srv_create_sess_files.cold+0x49/0x1fe [rtrs_server]
    [<0000000075d87bd7>] rtrs_srv_info_req_done+0x71b/0x960 [rtrs_server]
    [<00000000ccdf1bb5>] __ib_process_cq+0x94/0x100 [ib_core]
    [<00000000cbcb60cb>] ib_cq_poll_work+0x32/0xc0 [ib_core]
    [<000000002b53eaa1>] process_one_work+0x4bc/0x980
    [<00000000da3499fb>] worker_thread+0x78/0x5c0
    [<00000000167127a4>] kthread+0x191/0x1e0
    [<0000000060802104>] ret_from_fork+0x3a/0x50

The problem is we increase device refcount by get_device in process_info_req
for each path, but only does put_deice for last path, which lead to
memory leak.

To fix it, it also calls put_device when dev_ref is not 0.

Fixes: e2853c49477d1 ("RDMA/rtrs-srv-sysfs: fix missing put_device")
Link: https://lore.kernel.org/r/20210528113018.52290-19-jinpu.wang@ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 126a96e75c62..e499f64ae608 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -211,6 +211,7 @@ rtrs_srv_destroy_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 		device_del(&srv->dev);
 		put_device(&srv->dev);
 	} else {
+		put_device(&srv->dev);
 		mutex_unlock(&srv->paths_mutex);
 	}
 }
-- 
2.30.2



