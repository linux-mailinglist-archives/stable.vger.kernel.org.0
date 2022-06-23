Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFD955874D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbiFWSX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237686AbiFWSXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:23:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A04B6B8C2;
        Thu, 23 Jun 2022 10:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8088B824B8;
        Thu, 23 Jun 2022 17:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289D8C3411B;
        Thu, 23 Jun 2022 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005141;
        bh=inJZUrPnHHEGjWTpz138mTmKDGvf6TZCpzaMn1aHwWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCTGxyy+K0L1i86Yq8jcwOQ/LT8LdmiVs814VIwcmenGM3yfSNfhcsI4WNEb4iFKJ
         H4tUSEGA+2hG3l9PW1r5cr9Oz7+HPkC/c8W5B99G3MnLj2+z/1t90N5Jz0AM4KvTXx
         E0A5btm8kYsPL98d767dGKZn1tscbuss8s48l3uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.com>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.18 07/11] fsnotify: introduce mark type iterator
Date:   Thu, 23 Jun 2022 18:45:19 +0200
Message-Id: <20220623164322.529798143@linuxfoundation.org>
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

commit 14362a2541797cf9df0e86fb12dcd7950baf566e upstream.

fsnotify_foreach_iter_mark_type() is used to reduce boilerplate code
of iterating all marks of a specific group interested in an event
by consulting the iterator report_mask.

Use an open coded version of that iterator in fsnotify_iter_next()
that collects all marks of the current iteration group without
consulting the iterator report_mask.

At the moment, the two iterator variants are the same, but this
decoupling will allow us to exclude some of the group's marks from
reporting the event, for example for event on child and inode marks
on parent did not request to watch events on children.

Fixes: 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
Reported-by: Jan Kara <jack@suse.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220511190213.831646-2-amir73il@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify.c    |   14 ++--------
 fs/notify/fsnotify.c             |   53 +++++++++++++++++++--------------------
 include/linux/fsnotify_backend.h |   31 +++++++++++++++++-----
 3 files changed, 54 insertions(+), 44 deletions(-)

--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -319,11 +319,7 @@ static u32 fanotify_group_event_mask(str
 			return 0;
 	}
 
-	fsnotify_foreach_iter_type(type) {
-		if (!fsnotify_iter_should_report_type(iter_info, type))
-			continue;
-		mark = iter_info->marks[type];
-
+	fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
 		/* Apply ignore mask regardless of ISDIR and ON_CHILD flags */
 		marks_ignored_mask |= mark->ignored_mask;
 
@@ -849,16 +845,14 @@ out:
  */
 static __kernel_fsid_t fanotify_get_fsid(struct fsnotify_iter_info *iter_info)
 {
+	struct fsnotify_mark *mark;
 	int type;
 	__kernel_fsid_t fsid = {};
 
-	fsnotify_foreach_iter_type(type) {
+	fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
 		struct fsnotify_mark_connector *conn;
 
-		if (!fsnotify_iter_should_report_type(iter_info, type))
-			continue;
-
-		conn = READ_ONCE(iter_info->marks[type]->connector);
+		conn = READ_ONCE(mark->connector);
 		/* Mark is just getting destroyed or created? */
 		if (!conn)
 			continue;
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -335,31 +335,23 @@ static int send_to_group(__u32 mask, con
 	struct fsnotify_mark *mark;
 	int type;
 
-	if (WARN_ON(!iter_info->report_mask))
+	if (!iter_info->report_mask)
 		return 0;
 
 	/* clear ignored on inode modification */
 	if (mask & FS_MODIFY) {
-		fsnotify_foreach_iter_type(type) {
-			if (!fsnotify_iter_should_report_type(iter_info, type))
-				continue;
-			mark = iter_info->marks[type];
-			if (mark &&
-			    !(mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY))
+		fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
+			if (!(mark->flags &
+			      FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY))
 				mark->ignored_mask = 0;
 		}
 	}
 
-	fsnotify_foreach_iter_type(type) {
-		if (!fsnotify_iter_should_report_type(iter_info, type))
-			continue;
-		mark = iter_info->marks[type];
-		/* does the object mark tell us to do something? */
-		if (mark) {
-			group = mark->group;
-			marks_mask |= mark->mask;
-			marks_ignored_mask |= mark->ignored_mask;
-		}
+	/* Are any of the group marks interested in this event? */
+	fsnotify_foreach_iter_mark_type(iter_info, mark, type) {
+		group = mark->group;
+		marks_mask |= mark->mask;
+		marks_ignored_mask |= mark->ignored_mask;
 	}
 
 	pr_debug("%s: group=%p mask=%x marks_mask=%x marks_ignored_mask=%x data=%p data_type=%d dir=%p cookie=%d\n",
@@ -403,11 +395,11 @@ static struct fsnotify_mark *fsnotify_ne
 
 /*
  * iter_info is a multi head priority queue of marks.
- * Pick a subset of marks from queue heads, all with the
- * same group and set the report_mask for selected subset.
- * Returns the report_mask of the selected subset.
+ * Pick a subset of marks from queue heads, all with the same group
+ * and set the report_mask to a subset of the selected marks.
+ * Returns false if there are no more groups to iterate.
  */
-static unsigned int fsnotify_iter_select_report_types(
+static bool fsnotify_iter_select_report_types(
 		struct fsnotify_iter_info *iter_info)
 {
 	struct fsnotify_group *max_prio_group = NULL;
@@ -423,30 +415,37 @@ static unsigned int fsnotify_iter_select
 	}
 
 	if (!max_prio_group)
-		return 0;
+		return false;
 
 	/* Set the report mask for marks from same group as max prio group */
+	iter_info->current_group = max_prio_group;
 	iter_info->report_mask = 0;
 	fsnotify_foreach_iter_type(type) {
 		mark = iter_info->marks[type];
-		if (mark &&
-		    fsnotify_compare_groups(max_prio_group, mark->group) == 0)
+		if (mark && mark->group == iter_info->current_group)
 			fsnotify_iter_set_report_type(iter_info, type);
 	}
 
-	return iter_info->report_mask;
+	return true;
 }
 
 /*
- * Pop from iter_info multi head queue, the marks that were iterated in the
+ * Pop from iter_info multi head queue, the marks that belong to the group of
  * current iteration step.
  */
 static void fsnotify_iter_next(struct fsnotify_iter_info *iter_info)
 {
+	struct fsnotify_mark *mark;
 	int type;
 
+	/*
+	 * We cannot use fsnotify_foreach_iter_mark_type() here because we
+	 * may need to advance a mark of type X that belongs to current_group
+	 * but was not selected for reporting.
+	 */
 	fsnotify_foreach_iter_type(type) {
-		if (fsnotify_iter_should_report_type(iter_info, type))
+		mark = iter_info->marks[type];
+		if (mark && mark->group == iter_info->current_group)
 			iter_info->marks[type] =
 				fsnotify_next_mark(iter_info->marks[type]);
 	}
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -370,6 +370,7 @@ static inline bool fsnotify_valid_obj_ty
 
 struct fsnotify_iter_info {
 	struct fsnotify_mark *marks[FSNOTIFY_ITER_TYPE_COUNT];
+	struct fsnotify_group *current_group;
 	unsigned int report_mask;
 	int srcu_idx;
 };
@@ -386,20 +387,31 @@ static inline void fsnotify_iter_set_rep
 	iter_info->report_mask |= (1U << iter_type);
 }
 
-static inline void fsnotify_iter_set_report_type_mark(
-		struct fsnotify_iter_info *iter_info, int iter_type,
-		struct fsnotify_mark *mark)
+static inline struct fsnotify_mark *fsnotify_iter_mark(
+		struct fsnotify_iter_info *iter_info, int iter_type)
 {
-	iter_info->marks[iter_type] = mark;
-	iter_info->report_mask |= (1U << iter_type);
+	if (fsnotify_iter_should_report_type(iter_info, iter_type))
+		return iter_info->marks[iter_type];
+	return NULL;
+}
+
+static inline int fsnotify_iter_step(struct fsnotify_iter_info *iter, int type,
+				     struct fsnotify_mark **markp)
+{
+	while (type < FSNOTIFY_ITER_TYPE_COUNT) {
+		*markp = fsnotify_iter_mark(iter, type);
+		if (*markp)
+			break;
+		type++;
+	}
+	return type;
 }
 
 #define FSNOTIFY_ITER_FUNCS(name, NAME) \
 static inline struct fsnotify_mark *fsnotify_iter_##name##_mark( \
 		struct fsnotify_iter_info *iter_info) \
 { \
-	return (iter_info->report_mask & (1U << FSNOTIFY_ITER_TYPE_##NAME)) ? \
-		iter_info->marks[FSNOTIFY_ITER_TYPE_##NAME] : NULL; \
+	return fsnotify_iter_mark(iter_info, FSNOTIFY_ITER_TYPE_##NAME); \
 }
 
 FSNOTIFY_ITER_FUNCS(inode, INODE)
@@ -409,6 +421,11 @@ FSNOTIFY_ITER_FUNCS(sb, SB)
 
 #define fsnotify_foreach_iter_type(type) \
 	for (type = 0; type < FSNOTIFY_ITER_TYPE_COUNT; type++)
+#define fsnotify_foreach_iter_mark_type(iter, mark, type) \
+	for (type = 0; \
+	     type = fsnotify_iter_step(iter, type, &mark), \
+	     type < FSNOTIFY_ITER_TYPE_COUNT; \
+	     type++)
 
 /*
  * fsnotify_connp_t is what we embed in objects which connector can be attached


