Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACF655875C
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiFWSYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237695AbiFWSXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:23:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429A9C2C52;
        Thu, 23 Jun 2022 10:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBD80B824BC;
        Thu, 23 Jun 2022 17:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BF6C341C7;
        Thu, 23 Jun 2022 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005144;
        bh=fktVbGTudoPPT+gPcMTm5EPC1UpCzHAWbOUnYQ07HBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/VnkOzYYUwnuXVTKHD7CZJlUhPJdMsU24+1drSP+qo/WwqGH+9SrznXLP8wUf33L
         VHhiW9a+apynP2hQLFLRhdLca884TT7msThNMfzktxW7B30gS2Gn5cFqg9xWvC78q7
         Wj8x3sjXr6W5piI1G+gNUvK1MxWOHzM4IGK7RFh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.com>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.18 08/11] fsnotify: consistent behavior for parent not watching children
Date:   Thu, 23 Jun 2022 18:45:20 +0200
Message-Id: <20220623164322.557676906@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
References: <20220623164322.315085512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Amir Goldstein <amir73il@gmail.com>

commit e730558adffb88a52e562db089e969ee9510184a upstream.

The logic for handling events on child in groups that have a mark on
the parent inode, but without FS_EVENT_ON_CHILD flag in the mask is
duplicated in several places and inconsistent.

Move the logic into the preparation of mark type iterator, so that the
parent mark type will be excluded from all mark type iterations in that
case.

This results in several subtle changes of behavior, hopefully all
desired changes of behavior, for example:

- Group A has a mount mark with FS_MODIFY in mask
- Group A has a mark with ignore mask that does not survive FS_MODIFY
  and does not watch children on directory D.
- Group B has a mark with FS_MODIFY in mask that does watch children
  on directory D.
- FS_MODIFY event on file D/foo should not clear the ignore mask of
  group A, but before this change it does

And if group A ignore mask was set to survive FS_MODIFY:
- FS_MODIFY event on file D/foo should be reported to group A on account
  of the mount mark, but before this change it is wrongly ignored

Fixes: 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
Reported-by: Jan Kara <jack@suse.com>
Link: https://lore.kernel.org/linux-fsdevel/20220314113337.j7slrb5srxukztje@quack3.lan/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220511190213.831646-3-amir73il@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify.c |   10 +---------
 fs/notify/fsnotify.c          |   34 +++++++++++++++++++---------------
 2 files changed, 20 insertions(+), 24 deletions(-)

--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -320,7 +320,7 @@ static u32 fanotify_group_event_mask(str
 	}
 
 	fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
-		/* Apply ignore mask regardless of ISDIR and ON_CHILD flags */
+		/* Apply ignore mask regardless of mark's ISDIR flag */
 		marks_ignored_mask |= mark->ignored_mask;
 
 		/*
@@ -330,14 +330,6 @@ static u32 fanotify_group_event_mask(str
 		if (event_mask & FS_ISDIR && !(mark->mask & FS_ISDIR))
 			continue;
 
-		/*
-		 * If the event is on a child and this mark is on a parent not
-		 * watching children, don't send it!
-		 */
-		if (type == FSNOTIFY_ITER_TYPE_PARENT &&
-		    !(mark->mask & FS_EVENT_ON_CHILD))
-			continue;
-
 		marks_mask |= mark->mask;
 
 		/* Record the mark types of this group that matched the event */
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -290,22 +290,15 @@ static int fsnotify_handle_event(struct
 	}
 
 	if (parent_mark) {
-		/*
-		 * parent_mark indicates that the parent inode is watching
-		 * children and interested in this event, which is an event
-		 * possible on child. But is *this mark* watching children and
-		 * interested in this event?
-		 */
-		if (parent_mark->mask & FS_EVENT_ON_CHILD) {
-			ret = fsnotify_handle_inode_event(group, parent_mark, mask,
-							  data, data_type, dir, name, 0);
-			if (ret)
-				return ret;
-		}
-		if (!inode_mark)
-			return 0;
+		ret = fsnotify_handle_inode_event(group, parent_mark, mask,
+						  data, data_type, dir, name, 0);
+		if (ret)
+			return ret;
 	}
 
+	if (!inode_mark)
+		return 0;
+
 	if (mask & FS_EVENT_ON_CHILD) {
 		/*
 		 * Some events can be sent on both parent dir and child marks
@@ -422,8 +415,19 @@ static bool fsnotify_iter_select_report_
 	iter_info->report_mask = 0;
 	fsnotify_foreach_iter_type(type) {
 		mark = iter_info->marks[type];
-		if (mark && mark->group == iter_info->current_group)
+		if (mark && mark->group == iter_info->current_group) {
+			/*
+			 * FSNOTIFY_ITER_TYPE_PARENT indicates that this inode
+			 * is watching children and interested in this event,
+			 * which is an event possible on child.
+			 * But is *this mark* watching children?
+			 */
+			if (type == FSNOTIFY_ITER_TYPE_PARENT &&
+			    !(mark->mask & FS_EVENT_ON_CHILD))
+				continue;
+
 			fsnotify_iter_set_report_type(iter_info, type);
+		}
 	}
 
 	return true;


