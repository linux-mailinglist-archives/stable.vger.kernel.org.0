Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93103111EE2
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbfLCXF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729722AbfLCWuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7A52084F;
        Tue,  3 Dec 2019 22:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413415;
        bh=ak0oafLdw9C8TV8kEB7ReTBdXAP8KMKwZSruFOSqZQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwfZdm6BemskkcR1IMIXGjDEJr+tRpqHkjLPWYUMB9YskHf4eXYoZzvqCBNTUoZWf
         h5C9bGXJxfqyUi+NDCi44dYi0tVO5truMbjbajRAPB+QcvkDtGQGVrvLvur6wcce1n
         HTrzUEPLB3Y/v+JYGhkKqu7eHC1xTwsBviFGWyug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/321] btrfs: fix ncopies raid_attr for RAID56
Date:   Tue,  3 Dec 2019 23:33:04 +0100
Message-Id: <20191203223433.297773312@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



