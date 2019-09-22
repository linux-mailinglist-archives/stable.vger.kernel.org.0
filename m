Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4C7BA6C9
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391418AbfIVSxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404205AbfIVSxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:53:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17C5521D7B;
        Sun, 22 Sep 2019 18:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178384;
        bh=w5vMaPj8DTvAVZi2VQY7kI0VApxM++qJDgNLshmiiWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxuNhXGwRTHyvcSmH4x5HfAyTV9UliOOzYGMSVKDHYCXwO4ANF23spUGA3kwGdz3i
         I+QsiyCXp58O7hAm6S27rZClIaa0mYHqX9Mv6lT4pziAzv1nFrP+SDx5eQ81iQutzT
         fBxyUzwWMdLXHUpehKlagaaQONrD22wXMmhcho40=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Wu <tomwu@mellanox.com>, Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 131/185] nvmet: fix data units read and written counters in SMART log
Date:   Sun, 22 Sep 2019 14:48:29 -0400
Message-Id: <20190922184924.32534-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9f72d515fc4b3..4099093a17343 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -81,9 +81,11 @@ static u16 nvmet_get_smart_log_nsid(struct nvmet_req *req,
 		goto out;
 
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
@@ -111,11 +113,11 @@ static u16 nvmet_get_smart_log_all(struct nvmet_req *req,
 		if (!ns->bdev)
 			continue;
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

