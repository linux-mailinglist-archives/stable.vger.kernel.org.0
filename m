Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456E91D0E99
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387632AbgEMKBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387624AbgEMJvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A5EA20740;
        Wed, 13 May 2020 09:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363474;
        bh=iiOvWsJz9xiC3AmULUmzoArSo4nHTVHWNQqV589ZIEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sS5etvhv3B8NJ4LhfMxrvmCt6c8Idoak1L+tdwwIoqZO8FBS5jOmb/wke2cGmh3vJ
         JrdOk9mYwm4lFOaPVHkBe2MCnc7+NirmDadwMYp5vGsleB57VJUbEBcTRV6czdMXZT
         RiK7Os2myGTx5268N7gWS+vspYct/NpYhq6cJkfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 90/90] fanotify: merge duplicate events on parent and child
Date:   Wed, 13 May 2020 11:45:26 +0200
Message-Id: <20200513094418.515684247@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit f367a62a7cad2447d835a9f14fc63997a9137246 ]

With inotify, when a watch is set on a directory and on its child, an
event on the child is reported twice, once with wd of the parent watch
and once with wd of the child watch without the filename.

With fanotify, when a watch is set on a directory and on its child, an
event on the child is reported twice, but it has the exact same
information - either an open file descriptor of the child or an encoded
fid of the child.

The reason that the two identical events are not merged is because the
object id used for merging events in the queue is the child inode in one
event and parent inode in the other.

For events with path or dentry data, use the victim inode instead of the
watched inode as the object id for event merging, so that the event
reported on parent will be merged with the event reported on the child.

Link: https://lore.kernel.org/r/20200319151022.31456-9-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 14d0ac4664595..f5d30573f4a99 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -314,7 +314,12 @@ struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 	if (!event)
 		goto out;
 init: __maybe_unused
-	fsnotify_init_event(&event->fse, (unsigned long)inode);
+	/*
+	 * Use the victim inode instead of the watching inode as the id for
+	 * event queue, so event reported on parent is merged with event
+	 * reported on child when both directory and child watches exist.
+	 */
+	fsnotify_init_event(&event->fse, (unsigned long)id);
 	event->mask = mask;
 	if (FAN_GROUP_FLAG(group, FAN_REPORT_TID))
 		event->pid = get_pid(task_pid(current));
-- 
2.20.1



