Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B7EFA401
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfKMB5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:57:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729757AbfKMB5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E75972053B;
        Wed, 13 Nov 2019 01:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610241;
        bh=JzuVXnbANtHScJdB3rqEe/ae8c7To3o2P+Dk19lLAnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwTsFSYbhMBPSyhZ2V9UT25VOfugXm+ourbaCgXcM6ElqiIpM26GFdYY7ZdLOuw+d
         6KTHTslY0Ncy6AIfdC/jGt39UOfgzU4ux1atQvjmmvkSjrCsdwcqmzhT7LMMcRqZI+
         Y4otyWZGJrxO6b8Bs/JRcOkiIR5XWhv1S1xS+woc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.com>, Jeff Mahoney <jeffm@suse.com>,
        Shaohua Li <shli@fb.com>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 041/115] md: allow metadata updates while suspending an array - fix
Date:   Tue, 12 Nov 2019 20:55:08 -0500
Message-Id: <20191113015622.11592-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.com>

[ Upstream commit 059421e041eb461fb2b3e81c9adaec18ef03ca3c ]

Commit 35bfc52187f6 ("md: allow metadata update while suspending.")
added support for allowing md_check_recovery() to still perform
metadata updates while the array is entering the 'suspended' state.
This is needed to allow the processes of entering the state to
complete.

Unfortunately, the patch doesn't really work.  The test for
"mddev->suspended" at the start of md_check_recovery() means that the
function doesn't try to do anything at all while entering suspend.

This patch moves the code of updating the metadata while suspending to
*before* the test on mddev->suspended.

Reported-by: Jeff Mahoney <jeffm@suse.com>
Fixes: 35bfc52187f6 ("md: allow metadata update while suspending.")
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e529cef5483a8..b942c74f1ce83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8736,6 +8736,18 @@ static void md_start_sync(struct work_struct *ws)
  */
 void md_check_recovery(struct mddev *mddev)
 {
+	if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags) && mddev->sb_flags) {
+		/* Write superblock - thread that called mddev_suspend()
+		 * holds reconfig_mutex for us.
+		 */
+		set_bit(MD_UPDATING_SB, &mddev->flags);
+		smp_mb__after_atomic();
+		if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags))
+			md_update_sb(mddev, 0);
+		clear_bit_unlock(MD_UPDATING_SB, &mddev->flags);
+		wake_up(&mddev->sb_wait);
+	}
+
 	if (mddev->suspended)
 		return;
 
@@ -8896,16 +8908,6 @@ void md_check_recovery(struct mddev *mddev)
 	unlock:
 		wake_up(&mddev->sb_wait);
 		mddev_unlock(mddev);
-	} else if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags) && mddev->sb_flags) {
-		/* Write superblock - thread that called mddev_suspend()
-		 * holds reconfig_mutex for us.
-		 */
-		set_bit(MD_UPDATING_SB, &mddev->flags);
-		smp_mb__after_atomic();
-		if (test_bit(MD_ALLOW_SB_UPDATE, &mddev->flags))
-			md_update_sb(mddev, 0);
-		clear_bit_unlock(MD_UPDATING_SB, &mddev->flags);
-		wake_up(&mddev->sb_wait);
 	}
 }
 EXPORT_SYMBOL(md_check_recovery);
-- 
2.20.1

