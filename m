Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06A9111D18
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfLCWuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:50:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729550AbfLCWuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A4CC2084B;
        Tue,  3 Dec 2019 22:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413412;
        bh=Ig6GLgtVxG8RAfqsFCQe+ELgsgqLjsT/38hfFIajrIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdMDyptmaG6czaQbc50rY2NROXgZ9jy2r3dJhyWewuiojIRxYFGRO6QVePbz37LYO
         2hWHK6HAEspK0kpNx5HWtxdpQEz0DZzcPVw10mq6ygd6RyNH+CJ6md3QBlQQcF8oyx
         KzZvH61SuxWfcJ6/7YF2LUNtssntMl0ce+gR3jGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 117/321] btrfs: Check for missing device before bio submission in btrfs_map_bio
Date:   Tue,  3 Dec 2019 23:33:03 +0100
Message-Id: <20191203223433.233907706@linuxfoundation.org>
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



