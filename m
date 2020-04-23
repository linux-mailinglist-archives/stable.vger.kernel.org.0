Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158DA1B68B5
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgDWXRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:17:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49344 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728337AbgDWXGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:43 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvS-0004hK-Cg; Fri, 24 Apr 2020 00:06:34 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvP-00E6nr-MS; Fri, 24 Apr 2020 00:06:31 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Or Gerlitz" <ogerlitz@mellanox.com>,
        "Moni Shoua" <monis@mellanox.com>,
        "Roland Dreier" <roland@purestorage.com>
Date:   Fri, 24 Apr 2020 00:05:37 +0100
Message-ID: <lsq.1587683028.190449561@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 110/245] IB/mlx4: Avoid executing gid task when
 device is being removed
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Moni Shoua <monis@mellanox.com>

commit 4bf9715f184969dc703bde7be94919995024a6a9 upstream.

When device is being removed (e.g during VPI port link type change
from ETH to IB), tasks for gid table changes should not be executed.

Flush the current queue of tasks and block further tasks from entering the queue.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/hw/mlx4/main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1395,6 +1395,9 @@ static void update_gids_task(struct work
 	int err;
 	struct mlx4_dev	*dev = gw->dev->dev;
 
+	if (!gw->dev->ib_active)
+		return;
+
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
 		pr_warn("update gid table failed %ld\n", PTR_ERR(mailbox));
@@ -1425,6 +1428,9 @@ static void reset_gids_task(struct work_
 	int err;
 	struct mlx4_dev	*dev = gw->dev->dev;
 
+	if (!gw->dev->ib_active)
+		return;
+
 	mailbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(mailbox)) {
 		pr_warn("reset gid table failed\n");
@@ -2363,6 +2369,9 @@ static void mlx4_ib_remove(struct mlx4_d
 	struct mlx4_ib_dev *ibdev = ibdev_ptr;
 	int p;
 
+	ibdev->ib_active = false;
+	flush_workqueue(wq);
+
 	mlx4_ib_close_sriov(ibdev);
 	mlx4_ib_mad_cleanup(ibdev);
 	ib_unregister_device(&ibdev->ib_dev);

