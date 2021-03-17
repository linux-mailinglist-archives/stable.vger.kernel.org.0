Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D3F33E4AA
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhCQBAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230151AbhCQA7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DFCB64FB4;
        Wed, 17 Mar 2021 00:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942756;
        bh=V7IOjocATIMWy4yobgvRr9veE/J1JwSutfeQVJSypk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMfNk/il3IDDnkSR61tDaUVNAClaHmMvR1/WNJX8SyA7PMdnX3XX1x14F02/OdADM
         Kc6KFqecL7/FtOMX1jXtuPUqatYiSYVBEEeA2dBB3GRvkrC7J5ZwX4P0jtS+7otiDF
         4c2ssmfIlaD0szxarJWodHP5WETMuGJn1TuQ9tC2zCJM7eUhfSGyzqcTk5dVKJio1a
         I/n0lqx3M76OmfV7bK8La7lbPb8EwEANz9DDoLs58zmxyzjN3geAnXl4BO0N8B+owc
         b559m8DdG+dob4RAd5j/Y9eXWc0VfZaFJvQQWNbdbilpOul6ljeDN1KAT74CHANUjW
         KzmCALbP4BYwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>, Christoph Hellwig <hch@lst.de>,
        Martin Wilck <mwilck@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/23] block: Suppress uevent for hidden device when removed
Date:   Tue, 16 Mar 2021 20:58:47 -0400
Message-Id: <20210317005850.726479-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005850.726479-1-sashal@kernel.org>
References: <20210317005850.726479-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 9ec491447b90ad6a4056a9656b13f0b3a1e83043 ]

register_disk() suppress uevents for devices with the GENHD_FL_HIDDEN
but enables uevents at the end again in order to announce disk after
possible partitions are created.

When the device is removed the uevents are still on and user land sees
'remove' messages for devices which were never 'add'ed to the system.

  KERNEL[95481.571887] remove   /devices/virtual/nvme-fabrics/ctl/nvme5/nvme0c5n1 (block)

Let's suppress the uevents for GENHD_FL_HIDDEN by not enabling the
uevents at all.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Link: https://lore.kernel.org/r/20210311151917.136091-1-dwagner@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index aee2fa9de1a7..27a410d31087 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -623,10 +623,8 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
-	if (disk->flags & GENHD_FL_HIDDEN) {
-		dev_set_uevent_suppress(ddev, 0);
+	if (disk->flags & GENHD_FL_HIDDEN)
 		return;
-	}
 
 	/* No minors to use for partitions */
 	if (!disk_part_scan_enabled(disk))
-- 
2.30.1

