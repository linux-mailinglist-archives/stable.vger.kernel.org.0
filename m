Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6DE529101
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240614AbiEPUI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350201AbiEPUAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD33246664;
        Mon, 16 May 2022 12:55:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DEA5B81614;
        Mon, 16 May 2022 19:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B74AC385AA;
        Mon, 16 May 2022 19:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730849;
        bh=jyDIdAd6VRulWWPBhtTgE5U6lZXpOkTszQqFD/Gx1q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDKRnIbW1EMNF2zymjDAxYvKiYCpsOsRtZxI8CSKz1amqG37G4zuUTGKpueiBibEE
         9WdjZ/Db4v9AJKgTCH1kENic00HFibkn4J6boC+KmRdD9OCZfVIJNGhZafurJGxmbK
         UUCMdPpZfwf7IpKmUn8cWCfbznXzDHnu1dNCisL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 024/114] fanotify: do not allow setting dirent events in mask of non-dir
Date:   Mon, 16 May 2022 21:35:58 +0200
Message-Id: <20220516193626.187066736@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit ceaf69f8eadcafb323392be88e7a5248c415d423 ]

Dirent events (create/delete/move) are only reported on watched
directory inodes, but in fanotify as well as in legacy inotify, it was
always allowed to set them on non-dir inode, which does not result in
any meaningful outcome.

Until kernel v5.17, dirent events in fanotify also differed from events
"on child" (e.g. FAN_OPEN) in the information provided in the event.
For example, FAN_OPEN could be set in the mask of a non-dir or the mask
of its parent and event would report the fid of the child regardless of
the marked object.
By contrast, FAN_DELETE is not reported if the child is marked and the
child fid was not reported in the events.

Since kernel v5.17, with fanotify group flag FAN_REPORT_TARGET_FID, the
fid of the child is reported with dirent events, like events "on child",
which may create confusion for users expecting the same behavior as
events "on child" when setting events in the mask on a child.

The desired semantics of setting dirent events in the mask of a child
are not clear, so for now, deny this action for a group initialized
with flag FAN_REPORT_TARGET_FID and for the new event FAN_RENAME.
We may relax this restriction in the future if we decide on the
semantics and implement them.

Fixes: d61fd650e9d2 ("fanotify: introduce group flag FAN_REPORT_TARGET_FID")
Fixes: 8cc3b1ccd930 ("fanotify: wire up FAN_RENAME event")
Link: https://lore.kernel.org/linux-fsdevel/20220505133057.zm5t6vumc4xdcnsg@quack3.lan/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220507080028.219826-1-amir73il@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 2ff6bd85ba8f..f2a1947ec5ee 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1638,6 +1638,19 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	else
 		mnt = path.mnt;
 
+	/*
+	 * FAN_RENAME is not allowed on non-dir (for now).
+	 * We shouldn't have allowed setting any dirent events in mask of
+	 * non-dir, but because we always allowed it, error only if group
+	 * was initialized with the new flag FAN_REPORT_TARGET_FID.
+	 */
+	ret = -ENOTDIR;
+	if (inode && !S_ISDIR(inode->i_mode) &&
+	    ((mask & FAN_RENAME) ||
+	     ((mask & FANOTIFY_DIRENT_EVENTS) &&
+	      FAN_GROUP_FLAG(group, FAN_REPORT_TARGET_FID))))
+		goto path_put_and_out;
+
 	/* Mask out FAN_EVENT_ON_CHILD flag for sb/mount/non-dir marks */
 	if (mnt || !S_ISDIR(inode->i_mode)) {
 		mask &= ~FAN_EVENT_ON_CHILD;
-- 
2.35.1



