Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6678145102F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242680AbhKOSnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242472AbhKOSlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:41:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAA92632F1;
        Mon, 15 Nov 2021 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999494;
        bh=nisjMkk05ddDslovjW33PaKMkAa4TEgO4qZhmM7OoRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/0JfmwZMP6LZDknTxXpTWY76SwfPPxpWXSsPEZrWngBkARe24RLM0V/RWQLvgC3b
         hzcXk8k3fn61PLsYoGp2+exqKSxWpSwm/hz9dtJ5trxc5eG6yI+sM6Z5s02p9ZKuOH
         AHysp+316wPgS0EDbsYmyQlGcNXji3Oe3bfUk8kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Feng <fengli@smartx.com>,
        Xiao Ni <xni@redhat.com>, Song Liu <songliubraving@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 284/849] md: update superblock after changing rdev flags in state_store
Date:   Mon, 15 Nov 2021 17:56:07 +0100
Message-Id: <20211115165429.878948404@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 6c0c3d0d905aa..e89eb467f1429 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2976,7 +2976,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
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
@@ -2991,7 +2995,6 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (rdev->raid_disk >= 0)
 			err = -EBUSY;
 		else {
-			struct mddev *mddev = rdev->mddev;
 			err = 0;
 			if (mddev_is_clustered(mddev))
 				err = md_cluster_ops->remove_disk(mddev, rdev);
@@ -3008,10 +3011,12 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
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
@@ -3037,9 +3042,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
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
@@ -3118,6 +3125,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
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



