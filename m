Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A40137DAB
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgAKKAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:00:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729133AbgAKKAD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:00:03 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB972082E;
        Sat, 11 Jan 2020 10:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736803;
        bh=b9feuh1X62L8XNcbF6YOz/POC/CpMDvqh3CP6FF44Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2IurvZzG2VG0oqg6ZttlKKszmibchZODIiMNpMigCCAmu8TvKv/pzyCXkJPlxXB+
         IMaepXqWJqDw53ryFNRruYH9G572dsx3GTD6pZW4CznN0T1V2UzY3Xrg+WEkzIb2Re
         AfQidJaD5wnugpeqgI/gRB6RrQC9rhpl5zSlWLxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/91] IB/mlx4: Follow mirror sequence of device add during device removal
Date:   Sat, 11 Jan 2020 10:49:04 +0100
Message-Id: <20200111094847.033591288@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 89f988d93c62384758b19323c886db917a80c371 ]

Current code device add sequence is:

ib_register_device()
ib_mad_init()
init_sriov_init()
register_netdev_notifier()

Therefore, the remove sequence should be,

unregister_netdev_notifier()
close_sriov()
mad_cleanup()
ib_unregister_device()

However it is not above.
Hence, make do above remove sequence.

Fixes: fa417f7b520ee ("IB/mlx4: Add support for IBoE")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20191212091214.315005-3-leon@kernel.org
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7ccf7225f75a..adc46b809ef2 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -3031,16 +3031,17 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 	ibdev->ib_active = false;
 	flush_workqueue(wq);
 
-	mlx4_ib_close_sriov(ibdev);
-	mlx4_ib_mad_cleanup(ibdev);
-	ib_unregister_device(&ibdev->ib_dev);
-	mlx4_ib_diag_cleanup(ibdev);
 	if (ibdev->iboe.nb.notifier_call) {
 		if (unregister_netdevice_notifier(&ibdev->iboe.nb))
 			pr_warn("failure unregistering notifier\n");
 		ibdev->iboe.nb.notifier_call = NULL;
 	}
 
+	mlx4_ib_close_sriov(ibdev);
+	mlx4_ib_mad_cleanup(ibdev);
+	ib_unregister_device(&ibdev->ib_dev);
+	mlx4_ib_diag_cleanup(ibdev);
+
 	mlx4_qp_release_range(dev, ibdev->steer_qpn_base,
 			      ibdev->steer_qpn_count);
 	kfree(ibdev->ib_uc_qpns_bitmap);
-- 
2.20.1



