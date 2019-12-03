Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3784F111D1B
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfLCWuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729731AbfLCWuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA09D20656;
        Tue,  3 Dec 2019 22:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413418;
        bh=ixzM77mmAEzKa7tBc5NRii33XANhKZZ0LS4L+LzBBAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wDHlWWjvE00zLBHRIeyiqpEpqUh8YWs+nGMZ8PkZRpIweZ2AwN/rckcRIZXR1ohaQ
         g0ArDOQEn9x7kJvXvEfJytNAAVE6jniQ9WwlumvhDrwgBpl37Hq3rj5jul5ZGseD6R
         42BPpQpdmwaXkfp0cJhvJck78ewkQ84axiBtpNVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/321] btrfs: dev-replace: set result code of cancel by status of scrub
Date:   Tue,  3 Dec 2019 23:33:05 +0100
Message-Id: <20191203223433.348700452@linuxfoundation.org>
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

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit b47dda2ef6d793b67fd5979032dcd106e3f0a5c9 ]

The device-replace needs to check the result code of the scrub workers
in btrfs_dev_replace_cancel and distinguish if successful cancel
operation and when the there was no operation running.

If btrfs_scrub_cancel() fails, return
BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED so that user can try
to cancel the replace again.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ update changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/dev-replace.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 23b13fbecdc22..96763805787ed 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -810,16 +810,23 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		btrfs_dev_replace_write_unlock(dev_replace);
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
-		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 		tgt_device = dev_replace->tgtdev;
 		src_device = dev_replace->srcdev;
 		btrfs_dev_replace_write_unlock(dev_replace);
-		btrfs_scrub_cancel(fs_info);
-		/* btrfs_dev_replace_finishing() will handle the cleanup part */
-		btrfs_info_in_rcu(fs_info,
-			"dev_replace from %s (devid %llu) to %s canceled",
-			btrfs_dev_name(src_device), src_device->devid,
-			btrfs_dev_name(tgt_device));
+		ret = btrfs_scrub_cancel(fs_info);
+		if (ret < 0) {
+			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED;
+		} else {
+			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
+			/*
+			 * btrfs_dev_replace_finishing() will handle the
+			 * cleanup part
+			 */
+			btrfs_info_in_rcu(fs_info,
+				"dev_replace from %s (devid %llu) to %s canceled",
+				btrfs_dev_name(src_device), src_device->devid,
+				btrfs_dev_name(tgt_device));
+		}
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
 		/*
-- 
2.20.1



