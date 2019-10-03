Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B344CA274
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbfJCQFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729193AbfJCQFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:05:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75215215EA;
        Thu,  3 Oct 2019 16:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118724;
        bh=lTc6DFAiAPGMPxNE/on0ezBOoV5GI9L/+6b0widIlG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+gP5jZDPnbFmMJv4Gpu9nS1z6a+vkObcGrNUYJMeX6xAnWY/x7xt5Y4Div/8u8E4
         gYOXnUZrW6geQ1tArC0QniVgX/gBcDm1SB9VRciWY3NKqqVQbfc3F+tXCuPlrXGIbk
         iu+Wz5zZ2bSLuC8RkaUB6nbLCQKqXEYdPS8ucGRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Wu <tomwu@mellanox.com>,
        Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 077/129] nvmet: fix data units read and written counters in SMART log
Date:   Thu,  3 Oct 2019 17:53:20 +0200
Message-Id: <20191003154353.906756915@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Wu <tomwu@mellanox.com>

[ Upstream commit 3bec2e3754becebd4c452999adb49bc62c575ea4 ]

In nvme spec 1.3 there is a definition for data write/read counters
from SMART log, (See section 5.14.1.2):
	This value is reported in thousands (i.e., a value of 1
	corresponds to 1000 units of 512 bytes read) and is rounded up.

However, in nvme target where value is reported with actual units,
but not thousands of units as the spec requires.

Signed-off-by: Tom Wu <tomwu@mellanox.com>
Reviewed-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index cdb7752dcbb79..446f61ba018d7 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -47,9 +47,11 @@ static u16 nvmet_get_smart_log_nsid(struct nvmet_req *req,
 	}
 
 	host_reads = part_stat_read(ns->bdev->bd_part, ios[READ]);
-	data_units_read = part_stat_read(ns->bdev->bd_part, sectors[READ]);
+	data_units_read = DIV_ROUND_UP(part_stat_read(ns->bdev->bd_part,
+		sectors[READ]), 1000);
 	host_writes = part_stat_read(ns->bdev->bd_part, ios[WRITE]);
-	data_units_written = part_stat_read(ns->bdev->bd_part, sectors[WRITE]);
+	data_units_written = DIV_ROUND_UP(part_stat_read(ns->bdev->bd_part,
+		sectors[WRITE]), 1000);
 
 	put_unaligned_le64(host_reads, &slog->host_reads[0]);
 	put_unaligned_le64(data_units_read, &slog->data_units_read[0]);
@@ -75,11 +77,11 @@ static u16 nvmet_get_smart_log_all(struct nvmet_req *req,
 	rcu_read_lock();
 	list_for_each_entry_rcu(ns, &ctrl->subsys->namespaces, dev_link) {
 		host_reads += part_stat_read(ns->bdev->bd_part, ios[READ]);
-		data_units_read +=
-			part_stat_read(ns->bdev->bd_part, sectors[READ]);
+		data_units_read += DIV_ROUND_UP(
+			part_stat_read(ns->bdev->bd_part, sectors[READ]), 1000);
 		host_writes += part_stat_read(ns->bdev->bd_part, ios[WRITE]);
-		data_units_written +=
-			part_stat_read(ns->bdev->bd_part, sectors[WRITE]);
+		data_units_written += DIV_ROUND_UP(
+			part_stat_read(ns->bdev->bd_part, sectors[WRITE]), 1000);
 
 	}
 	rcu_read_unlock();
-- 
2.20.1



