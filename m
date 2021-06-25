Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764693B46DB
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 17:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhFYPsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 11:48:23 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44476 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhFYPsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 11:48:22 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 19C2521B9C;
        Fri, 25 Jun 2021 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624635961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=iYJr7cKmMYd/Cux85e0fi7gLs7DofWnGamSfIvMEazI=;
        b=O+xW6j7hCynDQ6rKtYlMGdQbANT7dTyfpheYyz+ilkDmElfPymsy3Wss+f2GoId3I9ll7S
        Ax6BYge+sjiGBe5vN8UulVWnIsaXIyZBJhXUG4NjKumhTRRqjgQlelm8N0lIN48DvIjCA+
        1qVuM4rSJr/AbbfedJlC7jkE5Nk7R6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624635961;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=iYJr7cKmMYd/Cux85e0fi7gLs7DofWnGamSfIvMEazI=;
        b=vEzU7Yyby42GW+UGL1CG3HYXnEEDugtPgG2ex+SBQJiVHfHuHbHelfZ3oUpeyVzlKhDk6t
        XBaCyH4bi8PeFJBg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 9D04E11A97;
        Fri, 25 Jun 2021 15:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624635961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=iYJr7cKmMYd/Cux85e0fi7gLs7DofWnGamSfIvMEazI=;
        b=O+xW6j7hCynDQ6rKtYlMGdQbANT7dTyfpheYyz+ilkDmElfPymsy3Wss+f2GoId3I9ll7S
        Ax6BYge+sjiGBe5vN8UulVWnIsaXIyZBJhXUG4NjKumhTRRqjgQlelm8N0lIN48DvIjCA+
        1qVuM4rSJr/AbbfedJlC7jkE5Nk7R6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624635961;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=iYJr7cKmMYd/Cux85e0fi7gLs7DofWnGamSfIvMEazI=;
        b=vEzU7Yyby42GW+UGL1CG3HYXnEEDugtPgG2ex+SBQJiVHfHuHbHelfZ3oUpeyVzlKhDk6t
        XBaCyH4bi8PeFJBg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id AQRqIzj61WBmOQAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Fri, 25 Jun 2021 15:46:00 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id dbfb3c6a;
        Fri, 25 Jun 2021 15:45:59 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>, stable@vger.kernel.org
Subject: [RFC PATCH] ceph: reduce contention in ceph_check_delayed_caps()
Date:   Fri, 25 Jun 2021 16:45:59 +0100
Message-Id: <20210625154559.8148-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Function ceph_check_delayed_caps() is called from the mdsc->delayed_work
workqueue and it can be kept looping for quite some time if caps keep being
added back to the mdsc->cap_delay_list.  This may result in the watchdog
tainting the kernel with the softlockup flag.

This patch re-arranges the loop through the caps list so that it initially
removes all the caps from list, adding them to a temporary list.  And then, with
less locking contention, it will eventually call the ceph_check_caps() for each
inode.  Any caps added to the list in the meantime will be handled in the next
run.

Cc: stable@vger.kernel.org
Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
Hi Jeff!

So, I've not based this patch on top of your patchset that gets rid of
ceph_async_iput() so that it will make it easier to backport it for stable
kernels.  Of course I'm not 100% this classifies as stable material.

Other than that, I've been testing this patch and I couldn't see anything
breaking.  Let me know what you think.

(I *think* I've seen a tracker bug for this in the past but I couldn't
find it.  I guess it could be added as a 'Link:' tag.)

Cheers,
--
Luis

 fs/ceph/caps.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a5e93b185515..727e41e3b939 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4229,6 +4229,7 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 {
 	struct inode *inode;
 	struct ceph_inode_info *ci;
+	LIST_HEAD(caps_list);
 
 	dout("check_delayed_caps\n");
 	spin_lock(&mdsc->cap_delay_lock);
@@ -4239,19 +4240,23 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 		if ((ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
 		    time_before(jiffies, ci->i_hold_caps_max))
 			break;
-		list_del_init(&ci->i_cap_delay_list);
+		list_move_tail(&ci->i_cap_delay_list, &caps_list);
+	}
+	spin_unlock(&mdsc->cap_delay_lock);
 
+	while (!list_empty(&caps_list)) {
+		ci = list_first_entry(&caps_list,
+				      struct ceph_inode_info,
+				      i_cap_delay_list);
+		list_del_init(&ci->i_cap_delay_list);
 		inode = igrab(&ci->vfs_inode);
 		if (inode) {
-			spin_unlock(&mdsc->cap_delay_lock);
 			dout("check_delayed_caps on %p\n", inode);
 			ceph_check_caps(ci, 0, NULL);
 			/* avoid calling iput_final() in tick thread */
 			ceph_async_iput(inode);
-			spin_lock(&mdsc->cap_delay_lock);
 		}
 	}
-	spin_unlock(&mdsc->cap_delay_lock);
 }
 
 /*
