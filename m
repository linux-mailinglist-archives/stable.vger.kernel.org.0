Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE5F1FBAD3
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbgFPQOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:14:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731680AbgFPPmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:42:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF19D208D5;
        Tue, 16 Jun 2020 15:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322152;
        bh=SM+Nv9YF+KO0JqFA9dgYr8V4Xc8LFO0isYGvwpRQJAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlgL4x2KstJN6NQgagAxPzp6OhNzunrU4dE05Y1mBIyC8Zl/ITRsRrmn+YEmaR+ys
         vTyLmzWJZ7iv0RX7iUB01t8DmOHke2tEI2MYEKo7CFe88cjuMV9VF+bXOS7IMbcIUz
         B8MLaugwxL4JCcQUTSbeo7ofMBwaY//nWIuJb8eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Amir Goldstein <amir73il@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 020/163] fanotify: fix ignore mask logic for events on child and on dir
Date:   Tue, 16 Jun 2020 17:33:14 +0200
Message-Id: <20200616153107.848384207@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 2f02fd3fa13e51713b630164f8a8e5b42de8283b ]

The comments in fanotify_group_event_mask() say:

  "If the event is on dir/child and this mark doesn't care about
   events on dir/child, don't send it!"

Specifically, mount and filesystem marks do not care about events
on child, but they can still specify an ignore mask for those events.
For example, a group that has:
- A mount mark with mask 0 and ignore_mask FAN_OPEN
- An inode mark on a directory with mask FAN_OPEN | FAN_OPEN_EXEC
  with flag FAN_EVENT_ON_CHILD

A child file open for exec would be reported to group with the FAN_OPEN
event despite the fact that FAN_OPEN is in ignore mask of mount mark,
because the mark iteration loop skips over non-inode marks for events
on child when calculating the ignore mask.

Move ignore mask calculation to the top of the iteration loop block
before excluding marks for events on dir/child.

Link: https://lore.kernel.org/r/20200524072441.18258-1-amir73il@gmail.com
Reported-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/linux-fsdevel/20200521162443.GA26052@quack2.suse.cz/
Fixes: 55bf882c7f13 "fanotify: fix merging marks masks with FAN_ONDIR"
Fixes: b469e7e47c8a "fanotify: fix handling of events on child..."
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index c18459cea6f4..29a9de57c34c 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -232,6 +232,10 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 		if (!fsnotify_iter_should_report_type(iter_info, type))
 			continue;
 		mark = iter_info->marks[type];
+
+		/* Apply ignore mask regardless of ISDIR and ON_CHILD flags */
+		marks_ignored_mask |= mark->ignored_mask;
+
 		/*
 		 * If the event is on dir and this mark doesn't care about
 		 * events on dir, don't send it!
@@ -249,7 +253,6 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 			continue;
 
 		marks_mask |= mark->mask;
-		marks_ignored_mask |= mark->ignored_mask;
 	}
 
 	test_mask = event_mask & marks_mask & ~marks_ignored_mask;
-- 
2.25.1



