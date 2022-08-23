Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B801A59D979
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348940AbiHWJRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349686AbiHWJQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:16:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1264E870BD;
        Tue, 23 Aug 2022 01:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D094B81C4C;
        Tue, 23 Aug 2022 08:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6414C433D6;
        Tue, 23 Aug 2022 08:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243545;
        bh=MrWX07tsnUvzSzDyKHxZReNNiPHWtCGNB4A0lNM0qb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16Cpz7SX72askWAFOgS9C3s5MwRffoD/DuK+SsVaL0xxEfSjOKqKYzRzI0PhLhdlD
         1LZLYjDlw3jP46ice7A9OL0tKkOZm/CK/yGEEUE2O0a1XXsqvvQfEcbYuEqHx5hOs/
         Fj2KZMd9IY5uMzEWLkTIPGyMXi0Bm5rgLgAOCAjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 311/365] md: Notify sysfs sync_completed in md_reap_sync_thread()
Date:   Tue, 23 Aug 2022 10:03:32 +0200
Message-Id: <20220823080131.186923522@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 660c52d48256..522b3d6b8c46 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9466,6 +9466,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	wake_up(&resync_wait);
 	/* flag recovery needed just to double check */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	md_new_event();
 	if (mddev->event_work.func)
-- 
2.35.1



