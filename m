Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAF9541A0F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379097AbiFGV1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379087AbiFGVZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:25:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF716150B5D;
        Tue,  7 Jun 2022 12:01:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8991861768;
        Tue,  7 Jun 2022 19:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FDFC385A2;
        Tue,  7 Jun 2022 19:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628490;
        bh=EFyZopC0NhI4QmX1Xz/RSlu+pmSVcB0t0WKz9AarTs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dc74W2XsOxZWDeWMsHoXLNRWrcNxfXgFm9mVu6XpvNO798XbVPyMFCZd1efBv5cRV
         9+lZh7e8gy1JWseBbI/QhgjmYfo9/mplJzyAnid9F+qW8ez/YXWf1sTMapnDhvxUgn
         rEvdfnc8fhogB+hJGrmOicRPfoQuj59Xu960olGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 348/879] inotify: show inotify mask flags in proc fdinfo
Date:   Tue,  7 Jun 2022 18:57:46 +0200
Message-Id: <20220607165012.962358623@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit a32e697cda27679a0327ae2cafdad8c7170f548f ]

The inotify mask flags IN_ONESHOT and IN_EXCL_UNLINK are not "internal
to kernel" and should be exposed in procfs fdinfo so CRIU can restore
them.

Fixes: 6933599697c9 ("inotify: hide internal kernel bits from fdinfo")
Link: https://lore.kernel.org/r/20220422120327.3459282-2-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fdinfo.c               | 11 ++---------
 fs/notify/inotify/inotify.h      | 12 ++++++++++++
 fs/notify/inotify/inotify_user.c |  2 +-
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 57f0d5d9f934..3451708fd035 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -83,16 +83,9 @@ static void inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(fsnotify_conn_inode(mark->connector));
 	if (inode) {
-		/*
-		 * IN_ALL_EVENTS represents all of the mask bits
-		 * that we expose to userspace.  There is at
-		 * least one bit (FS_EVENT_ON_CHILD) which is
-		 * used only internally to the kernel.
-		 */
-		u32 mask = mark->mask & IN_ALL_EVENTS;
-		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:%x ",
+		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:0 ",
 			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
-			   mask, mark->ignored_mask);
+			   inotify_mark_user_mask(mark));
 		show_mark_fhandle(m, inode);
 		seq_putc(m, '\n');
 		iput(inode);
diff --git a/fs/notify/inotify/inotify.h b/fs/notify/inotify/inotify.h
index 2007e3711916..8f00151eb731 100644
--- a/fs/notify/inotify/inotify.h
+++ b/fs/notify/inotify/inotify.h
@@ -22,6 +22,18 @@ static inline struct inotify_event_info *INOTIFY_E(struct fsnotify_event *fse)
 	return container_of(fse, struct inotify_event_info, fse);
 }
 
+/*
+ * INOTIFY_USER_FLAGS represents all of the mask bits that we expose to
+ * userspace.  There is at least one bit (FS_EVENT_ON_CHILD) which is
+ * used only internally to the kernel.
+ */
+#define INOTIFY_USER_MASK (IN_ALL_EVENTS | IN_ONESHOT | IN_EXCL_UNLINK)
+
+static inline __u32 inotify_mark_user_mask(struct fsnotify_mark *fsn_mark)
+{
+	return fsn_mark->mask & INOTIFY_USER_MASK;
+}
+
 extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 					   struct fsnotify_group *group);
 extern int inotify_handle_inode_event(struct fsnotify_mark *inode_mark,
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 54583f62dc44..3ef57db0ec9d 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -110,7 +110,7 @@ static inline __u32 inotify_arg_to_mask(struct inode *inode, u32 arg)
 		mask |= FS_EVENT_ON_CHILD;
 
 	/* mask off the flags used to open the fd */
-	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT | IN_EXCL_UNLINK));
+	mask |= (arg & INOTIFY_USER_MASK);
 
 	return mask;
 }
-- 
2.35.1



