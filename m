Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700B95492E5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356199AbiFMLv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356163AbiFMLuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:50:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F202EA0A;
        Mon, 13 Jun 2022 03:53:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51F1CB80E07;
        Mon, 13 Jun 2022 10:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1F0C34114;
        Mon, 13 Jun 2022 10:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117632;
        bh=UXuQefQutvPn6nHbF+TpBNd3dPHMCJ67gIY7ZQM4Km4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXBHIPjNS2RaP66OZT+TXxnumEAhCwfJjDY6LlBmtGdvFo/puoJFJrpA8Gb0qjkUd
         Sifo7THAlbAMZvF8GIJHmxe54c2/vuVCQ4fqASfJpUwwKK6LIeYjKC4zR4QJMailWS
         6XapUvXckdou85HDp/UnyM6AiiLRie+HnpdFmBUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/287] inotify: show inotify mask flags in proc fdinfo
Date:   Mon, 13 Jun 2022 12:08:19 +0200
Message-Id: <20220613094926.148511904@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index 86fcf5814279..74aeabbf0ea4 100644
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
index 7e4578d35b61..5d94c00b1233 100644
--- a/fs/notify/inotify/inotify.h
+++ b/fs/notify/inotify/inotify.h
@@ -21,6 +21,18 @@ static inline struct inotify_event_info *INOTIFY_E(struct fsnotify_event *fse)
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
 extern int inotify_handle_event(struct fsnotify_group *group,
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 97a51690338e..83d0b9356844 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -96,7 +96,7 @@ static inline __u32 inotify_arg_to_mask(u32 arg)
 	mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD | FS_UNMOUNT);
 
 	/* mask off the flags used to open the fd */
-	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT | IN_EXCL_UNLINK));
+	mask |= (arg & INOTIFY_USER_MASK);
 
 	return mask;
 }
-- 
2.35.1



