Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4443ED491
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhHPNEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236496AbhHPNEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:04:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26C306328A;
        Mon, 16 Aug 2021 13:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119014;
        bh=ylIgMX0d71mHanTE42tEKc6OrR6RVV4T/Cg4FrNgD74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahLkP7Fx2sXcvku3MafYiuBKfMOZyxzrbN+MbGpn+CWHDAQR9wAMX6jsS8KgPFneH
         E0LGE51+3hcE4p5WG8rgWpiJQTeNoHikTXk3yf1To3V6RQCJt0uhP83MTGbpb9vXVa
         4M6FnctQW01bB2KNKl8f9dUP+fDul5oIT2Pfjlis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.4 07/62] ceph: reduce contention in ceph_check_delayed_caps()
Date:   Mon, 16 Aug 2021 15:01:39 +0200
Message-Id: <20210816125428.454602515@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.de>

commit bf2ba432213fade50dd39f2e348085b758c0726e upstream.

Function ceph_check_delayed_caps() is called from the mdsc->delayed_work
workqueue and it can be kept looping for quite some time if caps keep
being added back to the mdsc->cap_delay_list.  This may result in the
watchdog tainting the kernel with the softlockup flag.

This patch breaks this loop if the caps have been recently (i.e. during
the loop execution).  Any new caps added to the list will be handled in
the next run.

Also, allow schedule_delayed() callers to explicitly set the delay value
instead of defaulting to 5s, so we can ensure that it runs soon
afterward if it looks like there is more work.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/46284
Signed-off-by: Luis Henriques <lhenriques@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c       |   17 ++++++++++++++++-
 fs/ceph/mds_client.c |   25 ++++++++++++++++---------
 fs/ceph/super.h      |    2 +-
 3 files changed, 33 insertions(+), 11 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4053,12 +4053,20 @@ bad:
 
 /*
  * Delayed work handler to process end of delayed cap release LRU list.
+ *
+ * If new caps are added to the list while processing it, these won't get
+ * processed in this run.  In this case, the ci->i_hold_caps_max will be
+ * returned so that the work can be scheduled accordingly.
  */
-void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
+unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 {
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 	int flags = CHECK_CAPS_NODELAY;
+	struct ceph_mount_options *opt = mdsc->fsc->mount_options;
+	unsigned long delay_max = opt->caps_wanted_delay_max * HZ;
+	unsigned long loop_start = jiffies;
+	unsigned long delay = 0;
 
 	dout("check_delayed_caps\n");
 	while (1) {
@@ -4068,6 +4076,11 @@ void ceph_check_delayed_caps(struct ceph
 		ci = list_first_entry(&mdsc->cap_delay_list,
 				      struct ceph_inode_info,
 				      i_cap_delay_list);
+		if (time_before(loop_start, ci->i_hold_caps_max - delay_max)) {
+			dout("%s caps added recently.  Exiting loop", __func__);
+			delay = ci->i_hold_caps_max;
+			break;
+		}
 		if ((ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
 		    time_before(jiffies, ci->i_hold_caps_max))
 			break;
@@ -4084,6 +4097,8 @@ void ceph_check_delayed_caps(struct ceph
 		}
 	}
 	spin_unlock(&mdsc->cap_delay_lock);
+
+	return delay;
 }
 
 /*
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4049,22 +4049,29 @@ static void maybe_recover_session(struct
 }
 
 /*
- * delayed work -- periodically trim expired leases, renew caps with mds
+ * delayed work -- periodically trim expired leases, renew caps with mds.  If
+ * the @delay parameter is set to 0 or if it's more than 5 secs, the default
+ * workqueue delay value of 5 secs will be used.
  */
-static void schedule_delayed(struct ceph_mds_client *mdsc)
+static void schedule_delayed(struct ceph_mds_client *mdsc, unsigned long delay)
 {
-	int delay = 5;
-	unsigned hz = round_jiffies_relative(HZ * delay);
-	schedule_delayed_work(&mdsc->delayed_work, hz);
+	unsigned long max_delay = HZ * 5;
+
+	/* 5 secs default delay */
+	if (!delay || (delay > max_delay))
+		delay = max_delay;
+	schedule_delayed_work(&mdsc->delayed_work,
+			      round_jiffies_relative(delay));
 }
 
 static void delayed_work(struct work_struct *work)
 {
-	int i;
 	struct ceph_mds_client *mdsc =
 		container_of(work, struct ceph_mds_client, delayed_work.work);
+	unsigned long delay;
 	int renew_interval;
 	int renew_caps;
+	int i;
 
 	dout("mdsc delayed_work\n");
 
@@ -4119,7 +4126,7 @@ static void delayed_work(struct work_str
 	}
 	mutex_unlock(&mdsc->mutex);
 
-	ceph_check_delayed_caps(mdsc);
+	delay = ceph_check_delayed_caps(mdsc);
 
 	ceph_queue_cap_reclaim_work(mdsc);
 
@@ -4127,7 +4134,7 @@ static void delayed_work(struct work_str
 
 	maybe_recover_session(mdsc);
 
-	schedule_delayed(mdsc);
+	schedule_delayed(mdsc, delay);
 }
 
 int ceph_mdsc_init(struct ceph_fs_client *fsc)
@@ -4600,7 +4607,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph
 			  mdsc->mdsmap->m_epoch);
 
 	mutex_unlock(&mdsc->mutex);
-	schedule_delayed(mdsc);
+	schedule_delayed(mdsc, 0);
 	return;
 
 bad_unlock:
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1064,7 +1064,7 @@ extern void ceph_flush_snaps(struct ceph
 extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
 extern void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 			    struct ceph_mds_session *session);
-extern void ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
+extern unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
 extern void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc);
 extern int  ceph_drop_caps_for_unlink(struct inode *inode);
 extern int ceph_encode_inode_release(void **p, struct inode *inode,


