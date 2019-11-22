Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E9A1065F5
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfKVFub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbfKVFua (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D39282070A;
        Fri, 22 Nov 2019 05:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401829;
        bh=Ig6GLgtVxG8RAfqsFCQe+ELgsgqLjsT/38hfFIajrIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2u/orVw4eWwRUsL15jfmo11VQwPJtk181UfXq939KtYBpC28Y8ru84TUIBIwb720
         N2MUSOcnQRz831BItJIrg67Ccjtjel9/nq9TTNIoOEofWjfeQ1i5bvOLqPMJSpVNUJ
         VW6ZwKbA8twmq8L2uw1hIgEwjXLj/N+eejxHX0YQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 071/219] btrfs: Check for missing device before bio submission in btrfs_map_bio
Date:   Fri, 22 Nov 2019 00:46:43 -0500
Message-Id: <20191122054911.1750-64-sashal@kernel.org>
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

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit fc8a168aa9ab1680c2bd52bf9db7c994e0f2524f ]

Before btrfs_map_bio submits all stripe bios it does a number of checks
to ensure the device for every stripe is present. However, it doesn't do
a DEV_STATE_MISSING check, instead this is relegated to the lower level
btrfs_schedule_bio (in the async submission case, sync submission
doesn't check DEV_STATE_MISSING at all). Additionally
btrfs_schedule_bios does the duplicate device->bdev check which has
already been performed in btrfs_map_bio.

This patch moves the DEV_STATE_MISSING check in btrfs_map_bio and
removes the duplicate device->bdev check. Doing so ensures that no bio
cloning/submission happens for both async/sync requests in the face of
missing device. This makes the async io submission path slightly shorter
in terms of instruction count. No functional changes.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a8297e7489d98..f84c18e86c816 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6106,12 +6106,6 @@ static noinline void btrfs_schedule_bio(struct btrfs_device *device,
 	int should_queue = 1;
 	struct btrfs_pending_bios *pending_bios;
 
-	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state) ||
-	    !device->bdev) {
-		bio_io_error(bio);
-		return;
-	}
-
 	/* don't bother with additional async steps for reads, right now */
 	if (bio_op(bio) == REQ_OP_READ) {
 		btrfsic_submit_bio(bio);
@@ -6240,7 +6234,8 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 
 	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
 		dev = bbio->stripes[dev_nr].dev;
-		if (!dev || !dev->bdev ||
+		if (!dev || !dev->bdev || test_bit(BTRFS_DEV_STATE_MISSING,
+						   &dev->dev_state) ||
 		    (bio_op(first_bio) == REQ_OP_WRITE &&
 		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))) {
 			bbio_error(bbio, first_bio, logical);
-- 
2.20.1

