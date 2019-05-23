Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4B3288B1
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391708AbfEWT2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391700AbfEWT2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:28:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2C9E206BA;
        Thu, 23 May 2019 19:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639683;
        bh=uu3IdUy+7dfGB7tzNOlP2lRoWgO/DVyjNyZ5vA0JBLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qV05Vab54YEMUrkIwq5AHxtWj/dGWjMBCPowLRyyDtfUEhX4Nox5qCfDhZn7xwi1D
         Nf9ksQXip+i/cGxbwFH1juv1UMiiXF07IAhMd6k7NRbnQ70cybo2bjqRSUjy9Khzry
         HTnegCa2Cht9UqCNX+kITAJ5HUo96HuLmOWpd7VA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.1 056/122] RDMA/ipoib: Allow user space differentiate between valid dev_port
Date:   Thu, 23 May 2019 21:06:18 +0200
Message-Id: <20190523181712.155165635@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

commit b79656ed44c6865e17bcd93472ec39488bcc4984 upstream.

Systemd triggers the following warning during IPoIB device load:

 mlx5_core 0000:00:0c.0 ib0: "systemd-udevd" wants to know my dev_id.
        Should it look at dev_port instead?
        See Documentation/ABI/testing/sysfs-class-net for more info.

This is caused due to user space attempt to differentiate old systems
without dev_port and new systems with dev_port. In case dev_port will be
zero, the systemd will try to read dev_id instead.

There is no need to print a warning in such case, because it is valid
situation and it is needed to ensure systemd compatibility with old
kernels.

Link: https://github.com/systemd/systemd/blob/master/src/udev/udev-builtin-net_id.c#L358
Cc: <stable@vger.kernel.org> # 4.19
Fixes: f6350da41dc7 ("IB/ipoib: Log sysfs 'dev_id' accesses from userspace")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2402,7 +2402,18 @@ static ssize_t dev_id_show(struct device
 {
 	struct net_device *ndev = to_net_dev(dev);
 
-	if (ndev->dev_id == ndev->dev_port)
+	/*
+	 * ndev->dev_port will be equal to 0 in old kernel prior to commit
+	 * 9b8b2a323008 ("IB/ipoib: Use dev_port to expose network interface
+	 * port numbers") Zero was chosen as special case for user space
+	 * applications to fallback and query dev_id to check if it has
+	 * different value or not.
+	 *
+	 * Don't print warning in such scenario.
+	 *
+	 * https://github.com/systemd/systemd/blob/master/src/udev/udev-builtin-net_id.c#L358
+	 */
+	if (ndev->dev_port && ndev->dev_id == ndev->dev_port)
 		netdev_info_once(ndev,
 			"\"%s\" wants to know my dev_id. Should it look at dev_port instead? See Documentation/ABI/testing/sysfs-class-net for more info.\n",
 			current->comm);


