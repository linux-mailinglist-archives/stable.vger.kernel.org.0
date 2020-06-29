Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D522E20DB83
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbgF2UHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732954AbgF2TaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31E6B251E6;
        Mon, 29 Jun 2020 15:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444907;
        bh=NUXmR4lHug30r6DStI+RG3JHn2fqSnGmfjiT7Dzq0JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=saAihrXTgSUvU3Z5SRXoqpF/+EyByisbtiRxeJT+9KtQTGp3IGdRXYu+ZMpctu+2N
         dAmwQWVNzW4lmcz6E5ApDNuw2qJfw2eWk8PxEIpz3GQkDfIRIfemrjnTww1iVkyg4W
         nFuvGzQYkuksrGmYFRBGSQUg7eMgfUPUQpwXg6yM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 003/131] fanotify: fix ignore mask logic for events on child and on dir
Date:   Mon, 29 Jun 2020 11:32:54 -0400
Message-Id: <20200629153502.2494656-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 2f02fd3fa13e51713b630164f8a8e5b42de8283b upstream.

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
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index a18b8d7a30759..ca3405f732644 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -114,6 +114,10 @@ static bool fanotify_should_send_event(struct fsnotify_iter_info *iter_info,
 		if (!fsnotify_iter_should_report_type(iter_info, type))
 			continue;
 		mark = iter_info->marks[type];
+
+		/* Apply ignore mask regardless of ISDIR and ON_CHILD flags */
+		marks_ignored_mask |= mark->ignored_mask;
+
 		/*
 		 * If the event is for a child and this mark doesn't care about
 		 * events on a child, don't send it!
@@ -124,7 +128,6 @@ static bool fanotify_should_send_event(struct fsnotify_iter_info *iter_info,
 			continue;
 
 		marks_mask |= mark->mask;
-		marks_ignored_mask |= mark->ignored_mask;
 	}
 
 	if (d_is_dir(path->dentry) &&
-- 
2.25.1

