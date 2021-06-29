Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43B53B7048
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 11:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhF2JuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 05:50:20 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56228 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbhF2JuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 05:50:19 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8192E203C5;
        Tue, 29 Jun 2021 09:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624960071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPX0Meh0V+vU/WN0+CnpfUFks6WEAxIlKLouk3smEHU=;
        b=JRk16IAbi/4Y3IWvG62/cNEPrbENe/I3rgwf0EIx+FiIRlUVPVJh5i8QzKlGdBCe+5o22g
        cuD073h0EYiPy7AaM1AgLY0ovLMiQ3ej3KlVfMJw5A56rfTO+WzaS4+c8VYmN6syiRiBlo
        N7fgsuDMslCVRDjjHDdIvLuZK4zEnDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624960071;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPX0Meh0V+vU/WN0+CnpfUFks6WEAxIlKLouk3smEHU=;
        b=h2f0iVXPi3yOt1lZtwyNCif1YVAuSjrl+kLEPjLdeqSqsbIVKIiuj/Gu0UHTU982fA9fQw
        aqL4N8ay9YJXUdBQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 1155511906;
        Tue, 29 Jun 2021 09:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624960071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPX0Meh0V+vU/WN0+CnpfUFks6WEAxIlKLouk3smEHU=;
        b=JRk16IAbi/4Y3IWvG62/cNEPrbENe/I3rgwf0EIx+FiIRlUVPVJh5i8QzKlGdBCe+5o22g
        cuD073h0EYiPy7AaM1AgLY0ovLMiQ3ej3KlVfMJw5A56rfTO+WzaS4+c8VYmN6syiRiBlo
        N7fgsuDMslCVRDjjHDdIvLuZK4zEnDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624960071;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPX0Meh0V+vU/WN0+CnpfUFks6WEAxIlKLouk3smEHU=;
        b=h2f0iVXPi3yOt1lZtwyNCif1YVAuSjrl+kLEPjLdeqSqsbIVKIiuj/Gu0UHTU982fA9fQw
        aqL4N8ay9YJXUdBQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id cJZNAUfs2mBqawAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Tue, 29 Jun 2021 09:47:51 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id e3d81f62;
        Tue, 29 Jun 2021 09:47:49 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>, stable@vger.kernel.org
Subject: [RFC PATCH v2 2/2] ceph: reduce contention in ceph_check_delayed_caps()
Date:   Tue, 29 Jun 2021 10:47:49 +0100
Message-Id: <20210629094749.25253-3-lhenriques@suse.de>
In-Reply-To: <20210629094749.25253-1-lhenriques@suse.de>
References: <20210629094749.25253-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Function ceph_check_delayed_caps() is called from the mdsc->delayed_work
workqueue and it can be kept looping for quite some time if caps keep
being added back to the mdsc->cap_delay_list.  This may result in the
watchdog tainting the kernel with the softlockup flag.

This patch breaks this loop if the caps have been recently (i.e. during
the loop execution).  Any new caps added to the list will be handled in
the next run.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/46284
Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
 fs/ceph/caps.c       | 17 ++++++++++++++++-
 fs/ceph/mds_client.c |  7 ++++---
 fs/ceph/super.h      |  2 +-
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a5e93b185515..c79b8dff25d7 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4224,11 +4224,19 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 
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
+	struct ceph_mount_options *opt = mdsc->fsc->mount_options;
+	unsigned long delay_max = opt->caps_wanted_delay_max * HZ;
+	unsigned long loop_start = jiffies;
+	unsigned long delay = 0;
 
 	dout("check_delayed_caps\n");
 	spin_lock(&mdsc->cap_delay_lock);
@@ -4236,6 +4244,11 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
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
@@ -4252,6 +4265,8 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 		}
 	}
 	spin_unlock(&mdsc->cap_delay_lock);
+
+	return delay;
 }
 
 /*
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 08c76bf57fb1..5f1bd7f9dce1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4518,11 +4518,12 @@ static void schedule_delayed(struct ceph_mds_client *mdsc, unsigned long delay)
 
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
 
@@ -4562,7 +4563,7 @@ static void delayed_work(struct work_struct *work)
 	}
 	mutex_unlock(&mdsc->mutex);
 
-	ceph_check_delayed_caps(mdsc);
+	delay = ceph_check_delayed_caps(mdsc);
 
 	ceph_queue_cap_reclaim_work(mdsc);
 
@@ -4570,7 +4571,7 @@ static void delayed_work(struct work_struct *work)
 
 	maybe_recover_session(mdsc);
 
-	schedule_delayed(mdsc, 0);
+	schedule_delayed(mdsc, delay);
 }
 
 int ceph_mdsc_init(struct ceph_fs_client *fsc)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 839e6b0239ee..3b5207c82767 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1170,7 +1170,7 @@ extern void ceph_flush_snaps(struct ceph_inode_info *ci,
 extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
 extern void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 			    struct ceph_mds_session *session);
-extern void ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
+extern unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
 extern void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc);
 extern int  ceph_drop_caps_for_unlink(struct inode *inode);
 extern int ceph_encode_inode_release(void **p, struct inode *inode,
