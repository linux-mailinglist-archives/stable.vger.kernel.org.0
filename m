Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E221065F7
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfKVFuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:50:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727743AbfKVFub (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1800C2071B;
        Fri, 22 Nov 2019 05:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401830;
        bh=ak0oafLdw9C8TV8kEB7ReTBdXAP8KMKwZSruFOSqZQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uw4HWBmQK2KhYnFeV8N5eSq/lPQnl6fNVBxCVnbmr3cZMUkxbn9LS+dfDzegh51He
         6hb2R+6uxVQptECpME7Jd50cPlZ2HnxUXMdH67tsEaAXwTRm6iH4mMn8n0lCrP1umI
         ujEoUblDsZlfxjpVDlBORzRJ6v9468T2P7o8fEV4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 072/219] btrfs: fix ncopies raid_attr for RAID56
Date:   Fri, 22 Nov 2019 00:46:44 -0500
Message-Id: <20191122054911.1750-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

[ Upstream commit da612e31aee51bd13231c78a47c714b543bd3ad8 ]

RAID5 and RAID6 profile store one copy of the data, not 2 or 3. These
values are not yet used anywhere so there's no change.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f84c18e86c816..5bbcdcff68a9e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -96,7 +96,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_min	= 2,
 		.tolerated_failures = 1,
 		.devs_increment	= 1,
-		.ncopies	= 2,
+		.ncopies	= 1,
 		.raid_name	= "raid5",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID5,
 		.mindev_error	= BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
@@ -108,7 +108,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_min	= 3,
 		.tolerated_failures = 2,
 		.devs_increment	= 1,
-		.ncopies	= 3,
+		.ncopies	= 1,
 		.raid_name	= "raid6",
 		.bg_flag	= BTRFS_BLOCK_GROUP_RAID6,
 		.mindev_error	= BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
-- 
2.20.1

