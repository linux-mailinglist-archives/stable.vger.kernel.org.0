Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9A9450DA3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbhKOSAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239388AbhKOR6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:58:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75D7860EFE;
        Mon, 15 Nov 2021 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997726;
        bh=mu5fg9tannO9mpNdoAYG+qO218C8foEct7l+6i7jQXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnDFdgMg7q1kZCvEXL5FNAarXTwH/froySiLde4s5Vm1TBMLmSP1vUG6zriWE7pUM
         fAXJTDBIbm74nCgfSM0exa+0Hd72BcX5y+CBwYHRdt4PWOgn1aJoSboH9SQ8hf+gPr
         Ffqeh8MHSt3d4lumLYvOD289R0lEWwaGfGp4vSIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Feng <fengli@smartx.com>,
        Xiao Ni <xni@redhat.com>, Song Liu <songliubraving@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/575] md: update superblock after changing rdev flags in state_store
Date:   Mon, 15 Nov 2021 17:59:05 +0100
Message-Id: <20211115165351.318274386@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 8b9e2291e355a0eafdd5b1e21a94a6659f24b351 ]

When the in memory flag is changed, we need to persist the change in the
rdev superblock flags. This is needed for "writemostly" and "failfast".

Reviewed-by: Li Feng <fengli@smartx.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f16f190546ef3..7871e7dcd4836 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3024,7 +3024,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	 *  -write_error - clears WriteErrorSeen
 	 *  {,-}failfast - set/clear FailFast
 	 */
+
+	struct mddev *mddev = rdev->mddev;
 	int err = -EINVAL;
+	bool need_update_sb = false;
+
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
 		md_error(rdev->mddev, rdev);
 		if (test_bit(Faulty, &rdev->flags))
@@ -3039,7 +3043,6 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (rdev->raid_disk >= 0)
 			err = -EBUSY;
 		else {
-			struct mddev *mddev = rdev->mddev;
 			err = 0;
 			if (mddev_is_clustered(mddev))
 				err = md_cluster_ops->remove_disk(mddev, rdev);
@@ -3056,10 +3059,12 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	} else if (cmd_match(buf, "writemostly")) {
 		set_bit(WriteMostly, &rdev->flags);
 		mddev_create_serial_pool(rdev->mddev, rdev, false);
+		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "-writemostly")) {
 		mddev_destroy_serial_pool(rdev->mddev, rdev, false);
 		clear_bit(WriteMostly, &rdev->flags);
+		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "blocked")) {
 		set_bit(Blocked, &rdev->flags);
@@ -3085,9 +3090,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		err = 0;
 	} else if (cmd_match(buf, "failfast")) {
 		set_bit(FailFast, &rdev->flags);
+		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "-failfast")) {
 		clear_bit(FailFast, &rdev->flags);
+		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "-insync") && rdev->raid_disk >= 0 &&
 		   !test_bit(Journal, &rdev->flags)) {
@@ -3166,6 +3173,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		clear_bit(ExternalBbl, &rdev->flags);
 		err = 0;
 	}
+	if (need_update_sb)
+		md_update_sb(mddev, 1);
 	if (!err)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
 	return err ? err : len;
-- 
2.33.0



