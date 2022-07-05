Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB61F566DC9
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbiGEM1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237617AbiGEMZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F501164;
        Tue,  5 Jul 2022 05:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6D57CE1A4A;
        Tue,  5 Jul 2022 12:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F73C341C7;
        Tue,  5 Jul 2022 12:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023485;
        bh=Oawlwwo/4Hrt5C49vgCr5vZAAwjn3HytdMXcRZDPBi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fObLtPwvy1Onux9qKDnIqYthdCqHW8dmFKIynssgk22Qk7fGLFZ8vzNF6zBu/R92w
         ycAKf147F5h39iX3jyAbRJwOQWAZGyYJyboM3f14tEPqWDoXpvldxxU/z4yaqi6Xse
         pLVxdR1J9T9YXRIJU9MqjabIKdHcgOsLxAfNH+hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.18 075/102] fanotify: refine the validation checks on non-dir inode mask
Date:   Tue,  5 Jul 2022 13:58:41 +0200
Message-Id: <20220705115620.539139567@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 8698e3bab4dd7968666e84e111d0bfd17c040e77 upstream.

Commit ceaf69f8eadc ("fanotify: do not allow setting dirent events in
mask of non-dir") added restrictions about setting dirent events in the
mask of a non-dir inode mark, which does not make any sense.

For backward compatibility, these restictions were added only to new
(v5.17+) APIs.

It also does not make any sense to set the flags FAN_EVENT_ON_CHILD or
FAN_ONDIR in the mask of a non-dir inode.  Add these flags to the
dir-only restriction of the new APIs as well.

Move the check of the dir-only flags for new APIs into the helper
fanotify_events_supported(), which is only called for FAN_MARK_ADD,
because there is no need to error on an attempt to remove the dir-only
flags from non-dir inode.

Fixes: ceaf69f8eadc ("fanotify: do not allow setting dirent events in mask of non-dir")
Link: https://lore.kernel.org/linux-fsdevel/20220627113224.kr2725conevh53u4@quack3.lan/
Link: https://lore.kernel.org/r/20220627174719.2838175-1-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify_user.c |   34 +++++++++++++++++++---------------
 include/linux/fanotify.h           |    4 ++++
 2 files changed, 23 insertions(+), 15 deletions(-)

--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1483,8 +1483,15 @@ static int fanotify_test_fid(struct dent
 	return 0;
 }
 
-static int fanotify_events_supported(struct path *path, __u64 mask)
+static int fanotify_events_supported(struct fsnotify_group *group,
+				     struct path *path, __u64 mask,
+				     unsigned int flags)
 {
+	unsigned int mark_type = flags & FANOTIFY_MARK_TYPE_BITS;
+	/* Strict validation of events in non-dir inode mask with v5.17+ APIs */
+	bool strict_dir_events = FAN_GROUP_FLAG(group, FAN_REPORT_TARGET_FID) ||
+				 (mask & FAN_RENAME);
+
 	/*
 	 * Some filesystems such as 'proc' acquire unusual locks when opening
 	 * files. For them fanotify permission events have high chances of
@@ -1496,6 +1503,16 @@ static int fanotify_events_supported(str
 	if (mask & FANOTIFY_PERM_EVENTS &&
 	    path->mnt->mnt_sb->s_type->fs_flags & FS_DISALLOW_NOTIFY_PERM)
 		return -EINVAL;
+
+	/*
+	 * We shouldn't have allowed setting dirent events and the directory
+	 * flags FAN_ONDIR and FAN_EVENT_ON_CHILD in mask of non-dir inode,
+	 * but because we always allowed it, error only when using new APIs.
+	 */
+	if (strict_dir_events && mark_type == FAN_MARK_INODE &&
+	    !d_is_dir(path->dentry) && (mask & FANOTIFY_DIRONLY_EVENT_BITS))
+		return -ENOTDIR;
+
 	return 0;
 }
 
@@ -1634,7 +1651,7 @@ static int do_fanotify_mark(int fanotify
 		goto fput_and_out;
 
 	if (flags & FAN_MARK_ADD) {
-		ret = fanotify_events_supported(&path, mask);
+		ret = fanotify_events_supported(group, &path, mask, flags);
 		if (ret)
 			goto path_put_and_out;
 	}
@@ -1657,19 +1674,6 @@ static int do_fanotify_mark(int fanotify
 	else
 		mnt = path.mnt;
 
-	/*
-	 * FAN_RENAME is not allowed on non-dir (for now).
-	 * We shouldn't have allowed setting any dirent events in mask of
-	 * non-dir, but because we always allowed it, error only if group
-	 * was initialized with the new flag FAN_REPORT_TARGET_FID.
-	 */
-	ret = -ENOTDIR;
-	if (inode && !S_ISDIR(inode->i_mode) &&
-	    ((mask & FAN_RENAME) ||
-	     ((mask & FANOTIFY_DIRENT_EVENTS) &&
-	      FAN_GROUP_FLAG(group, FAN_REPORT_TARGET_FID))))
-		goto path_put_and_out;
-
 	/* Mask out FAN_EVENT_ON_CHILD flag for sb/mount/non-dir marks */
 	if (mnt || !S_ISDIR(inode->i_mode)) {
 		mask &= ~FAN_EVENT_ON_CHILD;
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -110,6 +110,10 @@
 					 FANOTIFY_PERM_EVENTS | \
 					 FAN_Q_OVERFLOW | FAN_ONDIR)
 
+/* Events and flags relevant only for directories */
+#define FANOTIFY_DIRONLY_EVENT_BITS	(FANOTIFY_DIRENT_EVENTS | \
+					 FAN_EVENT_ON_CHILD | FAN_ONDIR)
+
 #define ALL_FANOTIFY_EVENT_BITS		(FANOTIFY_OUTGOING_EVENTS | \
 					 FANOTIFY_EVENT_FLAGS)
 


