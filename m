Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66FC1FB7D1
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732042AbgFPPtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732014AbgFPPtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:49:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C7702071A;
        Tue, 16 Jun 2020 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322591;
        bh=9gmy1HztA2mjnSIrbqEUjMiWyJe09lRlOSUFVNxX+Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apgcXrXKD7Eb0pGt/Y5XIfu5mTsTdr0GIFp5dIJhpY1WslKbbBBBH9/aYm9rwt/0Y
         xu4MNb4/JqxB6Ph7dzsHCt4kDOYr9tQkjIZFbemqeuqW54O28rxitn/+DO/+on7Pfl
         vZiskPWGBi5ofWWsVvFrdiC+ec4PIr25sadZGd5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Amir Goldstein <amir73il@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 027/161] fanotify: fix ignore mask logic for events on child and on dir
Date:   Tue, 16 Jun 2020 17:33:37 +0200
Message-Id: <20200616153107.691857095@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
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
index deb13f0a0f7d..d24548ed31b9 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -171,6 +171,10 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
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
@@ -188,7 +192,6 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 			continue;
 
 		marks_mask |= mark->mask;
-		marks_ignored_mask |= mark->ignored_mask;
 	}
 
 	test_mask = event_mask & marks_mask & ~marks_ignored_mask;
-- 
2.25.1



