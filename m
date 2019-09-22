Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3577BA7C5
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408042AbfIVTAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392587AbfIVTAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:00:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CAA021907;
        Sun, 22 Sep 2019 19:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178802;
        bh=4oyMsZn2PFZxFlfSAjj89JOUHSLgS0K9EA9CcXgbRlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1oIarjqAdGpkk/PChFqzMfCrSaOW3kc66tOPRkJSG1bK/r70f4CvWZqPj7XJlx1wR
         zqMVkn5+uNmGLa7otiSc6dsdVE2XQaPmqLFa8aT1/HcIJ5hibj5Rc2RsPAMKEyf64Z
         twin3sAfJOz/8zmLAA8yF4HtZFxsslprX2NeRkEU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guoqing Jiang <jgq516@gmail.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 21/60] md: don't set In_sync if array is frozen
Date:   Sun, 22 Sep 2019 14:58:54 -0400
Message-Id: <20190922185934.4305-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185934.4305-1-sashal@kernel.org>
References: <20190922185934.4305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <jgq516@gmail.com>

[ Upstream commit 062f5b2ae12a153644c765e7ba3b0f825427be1d ]

When a disk is added to array, the following path is called in mdadm.

Manage_subdevs -> sysfs_freeze_array
               -> Manage_add
               -> sysfs_set_str(&info, NULL, "sync_action","idle")

Then from kernel side, Manage_add invokes the path (add_new_disk ->
validate_super = super_1_validate) to set In_sync flag.

Since In_sync means "device is in_sync with rest of array", and the new
added disk need to resync thread to help the synchronization of data.
And md_reap_sync_thread would call spare_active to set In_sync for the
new added disk finally. So don't set In_sync if array is in frozen.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c1c514792457a..da8708b65356e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1662,8 +1662,15 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 				if (!(le32_to_cpu(sb->feature_map) &
 				      MD_FEATURE_RECOVERY_BITMAP))
 					rdev->saved_raid_disk = -1;
-			} else
-				set_bit(In_sync, &rdev->flags);
+			} else {
+				/*
+				 * If the array is FROZEN, then the device can't
+				 * be in_sync with rest of array.
+				 */
+				if (!test_bit(MD_RECOVERY_FROZEN,
+					      &mddev->recovery))
+					set_bit(In_sync, &rdev->flags);
+			}
 			rdev->raid_disk = role;
 			break;
 		}
-- 
2.20.1

