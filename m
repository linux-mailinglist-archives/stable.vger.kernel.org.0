Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0B540A6C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351827AbiFGSUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352183AbiFGSQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0991208A;
        Tue,  7 Jun 2022 10:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB5A4616A3;
        Tue,  7 Jun 2022 17:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA95FC3411F;
        Tue,  7 Jun 2022 17:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624259;
        bh=3ttcGsVjKZvzFTSgSt+g/d8gzLsfqgi8Q3mcukMoIGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4fI8DB33gp7RTeOkmxkg0UtlN6YHPg9U1lscjA3x0ycGp/JpiXwuA5iY78u6FNKH
         c3UdtkUWla5Mx2MHNoy+fGwYVC+1BZ9lNTnJD5r2JT3Lxa3q4WbO9+g6yCXg/5aHY/
         5MokzkeKXoDFnTNhgBjoYnLWi07gLmtYiyt4RWCV2OdAwngxNWSCYE9tizkW1V1Ssj
         DbVkgWHLJXOsA6i6FEENzAOVRp8H18rrGsNcBokEcqzzkZcUWs3dfbBMDVkB8cyzVz
         OLLMYEKsTVMFBAFsmoAkNP8pXMOL3O0qvo1FHMcxPogBRiZX6EBIVyPLKysmK5LszO
         KsqYivxRqLEGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 35/68] md: don't unregister sync_thread with reconfig_mutex held
Date:   Tue,  7 Jun 2022 13:48:01 -0400
Message-Id: <20220607174846.477972-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit 8b48ec23cc51a4e7c8dbaef5f34ebe67e1a80934 ]

Unregister sync_thread doesn't need to hold reconfig_mutex since it
doesn't reconfigure array.

And it could cause deadlock problem for raid5 as follows:

1. process A tried to reap sync thread with reconfig_mutex held after echo
   idle to sync_action.
2. raid5 sync thread was blocked if there were too many active stripes.
3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
   which causes the number of active stripes can't be decreased.
4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
   to hold reconfig_mutex.

More details in the link:
https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t

And add one parameter to md_reap_sync_thread since it could be called by
dm-raid which doesn't hold reconfig_mutex.

Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c |  2 +-
 drivers/md/md.c      | 14 +++++++++-----
 drivers/md/md.h      |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2b26435a6946..a5cc73d8f535 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3730,7 +3730,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev, false);
 		}
 	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
 		return -EBUSY;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 309b3af906ad..e3c1450b9e69 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4842,7 +4842,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 				flush_workqueue(md_misc_wq);
 			if (mddev->sync_thread) {
 				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_reap_sync_thread(mddev);
+				md_reap_sync_thread(mddev, true);
 			}
 			mddev_unlock(mddev);
 		}
@@ -6212,7 +6212,7 @@ static void __md_stop_writes(struct mddev *mddev)
 		flush_workqueue(md_misc_wq);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		md_reap_sync_thread(mddev);
+		md_reap_sync_thread(mddev, true);
 	}
 
 	del_timer_sync(&mddev->safemode_timer);
@@ -9320,7 +9320,7 @@ void md_check_recovery(struct mddev *mddev)
 			 * ->spare_active and clear saved_raid_disk
 			 */
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev, true);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
@@ -9355,7 +9355,7 @@ void md_check_recovery(struct mddev *mddev)
 			goto unlock;
 		}
 		if (mddev->sync_thread) {
-			md_reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev, true);
 			goto unlock;
 		}
 		/* Set RUNNING before clearing NEEDED to avoid
@@ -9428,14 +9428,18 @@ void md_check_recovery(struct mddev *mddev)
 }
 EXPORT_SYMBOL(md_check_recovery);
 
-void md_reap_sync_thread(struct mddev *mddev)
+void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
 {
 	struct md_rdev *rdev;
 	sector_t old_dev_sectors = mddev->dev_sectors;
 	bool is_reshaped = false;
 
+	if (reconfig_mutex_held)
+		mddev_unlock(mddev);
 	/* resync has finished, collect result */
 	md_unregister_thread(&mddev->sync_thread);
+	if (reconfig_mutex_held)
+		mddev_lock_nointr(mddev);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    mddev->degraded != mddev->raid_disks) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6ac283864533..1870864c9fc9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -711,7 +711,7 @@ extern struct md_thread *md_register_thread(
 extern void md_unregister_thread(struct md_thread **threadp);
 extern void md_wakeup_thread(struct md_thread *thread);
 extern void md_check_recovery(struct mddev *mddev);
-extern void md_reap_sync_thread(struct mddev *mddev);
+extern void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held);
 extern int mddev_init_writes_pending(struct mddev *mddev);
 extern bool md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
-- 
2.35.1

