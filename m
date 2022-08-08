Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28E658C0AA
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243397AbiHHBxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243674AbiHHBve (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:51:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E336D1A043;
        Sun,  7 Aug 2022 18:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 14BB8CE0F6E;
        Mon,  8 Aug 2022 01:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E90C433D6;
        Mon,  8 Aug 2022 01:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922707;
        bh=duFYzGOIIixBva0Q9jgqi225EbafyGawSTxEWc9V+Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyWstiBHC22YzPcOhqJo9wfzmvA3+IkeMZgoNx43nT8F21RF13RiUkkUjZ1Rkl+zJ
         WkNHeALRCQ9OZBp3BKoM20SpxfeBB+QdklSM3DXY3RsL5/Mi7C6Na51CRczA0m9mqX
         oXpBoGfWaUQkuNKRf2twzrs5xLVJKpkIIlA7/jwhpY51fNq6vIcbMbmV+V8DQAB4UP
         66gvj6irAAswTGm2GE2yBS3kgbzRpx+t4ampJls4wocJ5qdEny3uT1amQKGLVNKYBQ
         D0uLm/T4p75no04nPY66wn0oHhb+fM8l/Gc7OV816jKAGfN5Jvh6cceI7ti2YXxcGE
         fBIbettZuK9ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+358c9ab4c93da7b7238c@syzkaller.appspotmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 28/29] PM: hibernate: defer device probing when resuming from hibernation
Date:   Sun,  7 Aug 2022 21:37:38 -0400
Message-Id: <20220808013741.316026-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013741.316026-1-sashal@kernel.org>
References: <20220808013741.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 8386c414e27caba8501119948e9551e52b527f59 ]

syzbot is reporting hung task at misc_open() [1], for there is a race
window of AB-BA deadlock which involves probe_count variable. Currently
wait_for_device_probe() from snapshot_open() from misc_open() can sleep
forever with misc_mtx held if probe_count cannot become 0.

When a device is probed by hub_event() work function, probe_count is
incremented before the probe function starts, and probe_count is
decremented after the probe function completed.

There are three cases that can prevent probe_count from dropping to 0.

  (a) A device being probed stopped responding (i.e. broken/malicious
      hardware).

  (b) A process emulating a USB device using /dev/raw-gadget interface
      stopped responding for some reason.

  (c) New device probe requests keeps coming in before existing device
      probe requests complete.

The phenomenon syzbot is reporting is (b). A process which is holding
system_transition_mutex and misc_mtx is waiting for probe_count to become
0 inside wait_for_device_probe(), but the probe function which is called
 from hub_event() work function is waiting for the processes which are
blocked at mutex_lock(&misc_mtx) to respond via /dev/raw-gadget interface.

This patch mitigates (b) by deferring wait_for_device_probe() from
snapshot_open() to snapshot_write() and snapshot_ioctl(). Please note that
the possibility of (b) remains as long as any thread which is emulating a
USB device via /dev/raw-gadget interface can be blocked by uninterruptible
blocking operations (e.g. mutex_lock()).

Please also note that (a) and (c) are not addressed. Regarding (c), we
should change the code to wait for only one device which contains the
image for resuming from hibernation. I don't know how to address (a), for
use of timeout for wait_for_device_probe() might result in loss of user
data in the image. Maybe we should require the userland to wait for the
image device before opening /dev/snapshot interface.

Link: https://syzkaller.appspot.com/bug?extid=358c9ab4c93da7b7238c [1]
Reported-by: syzbot <syzbot+358c9ab4c93da7b7238c@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+358c9ab4c93da7b7238c@syzkaller.appspotmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/user.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index 740723bb3885..13cca2e2c2bc 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -26,6 +26,7 @@
 
 #include "power.h"
 
+static bool need_wait;
 
 static struct snapshot_data {
 	struct snapshot_handle handle;
@@ -78,7 +79,7 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 		 * Resuming.  We may need to wait for the image device to
 		 * appear.
 		 */
-		wait_for_device_probe();
+		need_wait = true;
 
 		data->swap = -1;
 		data->mode = O_WRONLY;
@@ -168,6 +169,11 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
 	ssize_t res;
 	loff_t pg_offp = *offp & ~PAGE_MASK;
 
+	if (need_wait) {
+		wait_for_device_probe();
+		need_wait = false;
+	}
+
 	lock_system_sleep();
 
 	data = filp->private_data;
@@ -244,6 +250,11 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 	loff_t size;
 	sector_t offset;
 
+	if (need_wait) {
+		wait_for_device_probe();
+		need_wait = false;
+	}
+
 	if (_IOC_TYPE(cmd) != SNAPSHOT_IOC_MAGIC)
 		return -ENOTTY;
 	if (_IOC_NR(cmd) > SNAPSHOT_IOC_MAXNR)
-- 
2.35.1

