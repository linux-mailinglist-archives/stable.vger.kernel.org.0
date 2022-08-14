Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7671E592265
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241542AbiHNPrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241600AbiHNPpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:45:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137D6BC36;
        Sun, 14 Aug 2022 08:34:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37F6A60CF1;
        Sun, 14 Aug 2022 15:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB027C4347C;
        Sun, 14 Aug 2022 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491265;
        bh=5J3CrasuJ+H3IhnQusuUS3vDZ0zL0c+C2iD72KLsHps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZi5/QxuLhNPAti1Sk9ufaQ4UL9hPieMHMyQgvpx+xhBpxJv5/duZ5rsI82X3Ktp/
         0SHSs/Pf3TD4NaVeEavp+4cUDMUR5k664U5SlDHi9tlVtgp3rce/4lemyu9o7kgici
         bEBnDUu4yIBi45aRtZVQNa6OfGPh9IkcCCbTjb+v+9R7iDctiXPJvsWHcV7Hdl1UpT
         fFTYITB8A3AMPSDgZoxwcyeewWRCwDAH9h97zoXpS/e578UlA/G7qyQtMW0V25lf2L
         RwCicvNiS5LfmZNbk17OZuNJ2tzCGwSjFA9sO1ORJQQq0tCDJKBGQa4myKRGvbxXQ5
         ybJwPjSE6aqYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 42/46] md: Notify sysfs sync_completed in md_reap_sync_thread()
Date:   Sun, 14 Aug 2022 11:32:43 -0400
Message-Id: <20220814153247.2378312-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 9973f0fa7d20269fe6fefe6333997fb5914449c1 ]

The mdadm test 07layouts randomly produces a kernel hung task deadlock.
The deadlock is caused by the suspend_lo/suspend_hi files being set by
the mdadm background process during reshape and not being cleared
because the process hangs. (Leaving aside the issue of the fragility of
freezing kernel tasks by buggy userspace processes...)

When the background mdadm process hangs it, is waiting (without a
timeout) on a change to the sync_completed file signalling that the
reshape has completed. The process is woken up a couple times when
the reshape finishes but it is woken up before MD_RECOVERY_RUNNING
is cleared so sync_completed_show() reports 0 instead of "none".

To fix this, notify the sysfs file in md_reap_sync_thread() after
MD_RECOVERY_RUNNING has been cleared. This wakes up mdadm and causes
it to continue and write to suspend_lo/suspend_hi to allow IO to
continue.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bf1c5c0e472e..4be9b23019c7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9467,6 +9467,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	wake_up(&resync_wait);
 	/* flag recovery needed just to double check */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	md_new_event(mddev);
 	if (mddev->event_work.func)
-- 
2.35.1

