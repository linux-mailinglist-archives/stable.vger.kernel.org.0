Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51470106601
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfKVG1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:27:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfKVFuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AF2520717;
        Fri, 22 Nov 2019 05:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401831;
        bh=ixzM77mmAEzKa7tBc5NRii33XANhKZZ0LS4L+LzBBAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SL6V17rwLHmPR2f1WhIsWGInhUj1ukWuEfQ3pVFEX5j8u4YgsX5PJ+7J0eaWsfmcP
         u20EKvGtl8PdeX/xH1K7nxPYk0yv5w6Kbejc5I5bty5Iet6LalReFqqAqonEax3kOt
         AYRKgdNLXKp2YiNcDr/Ot06QeuvQ6Nl5uR5zzlhE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 073/219] btrfs: dev-replace: set result code of cancel by status of scrub
Date:   Fri, 22 Nov 2019 00:46:45 -0500
Message-Id: <20191122054911.1750-66-sashal@kernel.org>
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

