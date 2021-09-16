Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9677B40E124
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240738AbhIPQ14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241715AbhIPQZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:25:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B006135F;
        Thu, 16 Sep 2021 16:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809015;
        bh=AqjpVczbWhjKyLE7PDyMzNLU9SOVZx6lJP4vKwpG/gU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5JFjlh44OvmUsMy4Ry7D1ILwurEvoyow6OaqBjT7bGyttNTciHaKcyQnzDJ1N70Q
         YySCjhzz/K7ZvZxgWlZst11Zq5dir8l59Q/h5bdFarRr/rTUI7e8y6Z1RDQQWKD/AY
         EHad0PLR6QoP/XSfp6BiSWQHo1S7PzL9StEGXjFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 306/306] fanotify: limit number of event merge attempts
Date:   Thu, 16 Sep 2021 18:00:51 +0200
Message-Id: <20210916155804.511117474@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit b8cd0ee8cda68a888a317991c1e918a8cba1a568 upstream.

Event merges are expensive when event queue size is large, so limit the
linear search to 128 merge tests.

[Stable backport notes] The following statement from upstream commit is
irrelevant for backport:
-
-In combination with 128 size hash table, there is a potential to merge
-with up to 16K events in the hashed queue.
-
[Stable backport notes] The problem is as old as fanotify and described
in the linked cover letter "Performance improvement for fanotify merge".
This backported patch fixes the performance issue at the cost of merging
fewer potential events.  Fixing the performance issue is more important
than preserving the "event merge" behavior, which was not predictable in
any way that applications could rely on.

Link: https://lore.kernel.org/r/20210304104826.3993892-6-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/linux-fsdevel/20210202162010.305971-1-amir73il@gmail.com/
Link: https://lore.kernel.org/linux-fsdevel/20210915163334.GD6166@quack2.suse.cz/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -129,11 +129,15 @@ static bool fanotify_should_merge(struct
 	return false;
 }
 
+/* Limit event merges to limit CPU overhead per event */
+#define FANOTIFY_MAX_MERGE_EVENTS 128
+
 /* and the list better be locked by something too! */
 static int fanotify_merge(struct list_head *list, struct fsnotify_event *event)
 {
 	struct fsnotify_event *test_event;
 	struct fanotify_event *new;
+	int i = 0;
 
 	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
 	new = FANOTIFY_E(event);
@@ -147,6 +151,8 @@ static int fanotify_merge(struct list_he
 		return 0;
 
 	list_for_each_entry_reverse(test_event, list, list) {
+		if (++i > FANOTIFY_MAX_MERGE_EVENTS)
+			break;
 		if (fanotify_should_merge(test_event, event)) {
 			FANOTIFY_E(test_event)->mask |= new->mask;
 			return 1;


