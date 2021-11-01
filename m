Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEB044174D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhKAJfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232693AbhKAJcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:32:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1BD4610E8;
        Mon,  1 Nov 2021 09:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758672;
        bh=nUkxP9PjnMQ51Mt88YruVMXVJUtGq3QtWY+WgKFYxTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLSELxIrSEs7jeOdUQ8KtaO6Df09xSarXPJXQ633HAgAuh4T3gzDE3+jmyeZjjBgC
         OGa7iwO8L+AJN6zQwEESctsdyK9hvpxZiBDNZyAnsd0FXXrTMmGIPKcyVP5sFAN0J2
         SUDWS/w0F+pq7ShFlz2YX96gJsbFDbx4bAm+K8KA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.10 10/77] ext4: fix possible UAF when remounting r/o a mmp-protected file system
Date:   Mon,  1 Nov 2021 10:16:58 +0100
Message-Id: <20211101082514.121077773@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 61bb4a1c417e5b95d9edb4f887f131de32e419cb upstream.

After commit 618f003199c6 ("ext4: fix memory leak in
ext4_fill_super"), after the file system is remounted read-only, there
is a race where the kmmpd thread can exit, causing sbi->s_mmp_tsk to
point at freed memory, which the call to ext4_stop_mmpd() can trip
over.

Fix this by only allowing kmmpd() to exit when it is stopped via
ext4_stop_mmpd().

Link: https://lore.kernel.org/r/20210707002433.3719773-1-tytso@mit.edu
Reported-by: Ye Bin <yebin10@huawei.com>
Bug-Report-Link: <20210629143603.2166962-1-yebin10@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mmp.c   |   31 +++++++++++++++----------------
 fs/ext4/super.c |    6 +++++-
 2 files changed, 20 insertions(+), 17 deletions(-)

--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -156,7 +156,12 @@ static int kmmpd(void *data)
 	memcpy(mmp->mmp_nodename, init_utsname()->nodename,
 	       sizeof(mmp->mmp_nodename));
 
-	while (!kthread_should_stop()) {
+	while (!kthread_should_stop() && !sb_rdonly(sb)) {
+		if (!ext4_has_feature_mmp(sb)) {
+			ext4_warning(sb, "kmmpd being stopped since MMP feature"
+				     " has been disabled.");
+			goto wait_to_exit;
+		}
 		if (++seq > EXT4_MMP_SEQ_MAX)
 			seq = 1;
 
@@ -177,16 +182,6 @@ static int kmmpd(void *data)
 			failed_writes++;
 		}
 
-		if (!(le32_to_cpu(es->s_feature_incompat) &
-		    EXT4_FEATURE_INCOMPAT_MMP)) {
-			ext4_warning(sb, "kmmpd being stopped since MMP feature"
-				     " has been disabled.");
-			goto exit_thread;
-		}
-
-		if (sb_rdonly(sb))
-			break;
-
 		diff = jiffies - last_update_time;
 		if (diff < mmp_update_interval * HZ)
 			schedule_timeout_interruptible(mmp_update_interval *
@@ -207,7 +202,7 @@ static int kmmpd(void *data)
 				ext4_error_err(sb, -retval,
 					       "error reading MMP data: %d",
 					       retval);
-				goto exit_thread;
+				goto wait_to_exit;
 			}
 
 			mmp_check = (struct mmp_struct *)(bh_check->b_data);
@@ -221,7 +216,7 @@ static int kmmpd(void *data)
 				ext4_error_err(sb, EBUSY, "abort");
 				put_bh(bh_check);
 				retval = -EBUSY;
-				goto exit_thread;
+				goto wait_to_exit;
 			}
 			put_bh(bh_check);
 		}
@@ -244,7 +239,13 @@ static int kmmpd(void *data)
 
 	retval = write_mmp_block(sb, bh);
 
-exit_thread:
+wait_to_exit:
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!kthread_should_stop())
+			schedule();
+	}
+	set_current_state(TASK_RUNNING);
 	return retval;
 }
 
@@ -391,5 +392,3 @@ failed:
 	brelse(bh);
 	return 1;
 }
-
-
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5932,7 +5932,6 @@ static int ext4_remount(struct super_blo
 				 */
 				ext4_mark_recovery_complete(sb, es);
 			}
-			ext4_stop_mmpd(sbi);
 		} else {
 			/* Make sure we can mount this feature set readwrite */
 			if (ext4_has_feature_readonly(sb) ||
@@ -6046,6 +6045,9 @@ static int ext4_remount(struct super_blo
 	if (!test_opt(sb, BLOCK_VALIDITY) && sbi->s_system_blks)
 		ext4_release_system_zone(sb);
 
+	if (!ext4_has_feature_mmp(sb) || sb_rdonly(sb))
+		ext4_stop_mmpd(sbi);
+
 	/*
 	 * Some options can be enabled by ext4 and/or by VFS mount flag
 	 * either way we need to make sure it matches in both *flags and
@@ -6078,6 +6080,8 @@ restore_opts:
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(to_free[i]);
 #endif
+	if (!ext4_has_feature_mmp(sb) || sb_rdonly(sb))
+		ext4_stop_mmpd(sbi);
 	kfree(orig_data);
 	return err;
 }


