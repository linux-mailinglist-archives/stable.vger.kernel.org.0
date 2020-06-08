Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5181F2E3B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgFIAkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:32836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729239AbgFHXNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D05220E65;
        Mon,  8 Jun 2020 23:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657988;
        bh=3aQn8lWSx0gzufLB59ZzKTddB/fgb3P21/cKvHsdEB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJqski512j80Kt6Ev10f430j2yptYiNXnC0B2RmJWwe3aAL260DzXP7loNO4AK3kw
         02NbTWfzSBfIZDHE4hVM7GdvDh+T60B7Ir73m6+giF9iU5tq/4VyFoyNw76J5zXRlg
         QhRVg+Qjp51PpVj/9XRhSM9B08vMrCNN1BBD9uTk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        Rachel Sibley <rasibley@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 047/606] fanotify: fix merging marks masks with FAN_ONDIR
Date:   Mon,  8 Jun 2020 19:02:52 -0400
Message-Id: <20200608231211.3363633-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 55bf882c7f13dda8bbe624040c6d5b4fbb812d16 upstream.

Change the logic of FAN_ONDIR in two ways that are similar to the logic
of FAN_EVENT_ON_CHILD, that was fixed in commit 54a307ba8d3c ("fanotify:
fix logic of events on child"):

1. The flag is meaningless in ignore mask
2. The flag refers only to events in the mask of the mark where it is set

This is what the fanotify_mark.2 man page says about FAN_ONDIR:
"Without this flag, only events for files are created."  It doesn't
say anything about setting this flag in ignore mask to stop getting
events on directories nor can I think of any setup where this capability
would be useful.

Currently, when marks masks are merged, the FAN_ONDIR flag set in one
mark affects the events that are set in another mark's mask and this
behavior causes unexpected results.  For example, a user adds a mark on a
directory with mask FAN_ATTRIB | FAN_ONDIR and a mount mark with mask
FAN_OPEN (without FAN_ONDIR).  An opendir() of that directory (which is
inside that mount) generates a FAN_OPEN event even though neither of the
marks requested to get open events on directories.

Link: https://lore.kernel.org/r/20200319151022.31456-10-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Rachel Sibley <rasibley@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index f5d30573f4a9..deb13f0a0f7d 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -171,6 +171,13 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 		if (!fsnotify_iter_should_report_type(iter_info, type))
 			continue;
 		mark = iter_info->marks[type];
+		/*
+		 * If the event is on dir and this mark doesn't care about
+		 * events on dir, don't send it!
+		 */
+		if (event_mask & FS_ISDIR && !(mark->mask & FS_ISDIR))
+			continue;
+
 		/*
 		 * If the event is for a child and this mark doesn't care about
 		 * events on a child, don't send it!
@@ -203,10 +210,6 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 		user_mask &= ~FAN_ONDIR;
 	}
 
-	if (event_mask & FS_ISDIR &&
-	    !(marks_mask & FS_ISDIR & ~marks_ignored_mask))
-		return 0;
-
 	return test_mask & user_mask;
 }
 
-- 
2.25.1

