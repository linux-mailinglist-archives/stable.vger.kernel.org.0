Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50EF26B51B
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgIOXhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbgIOOfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:35:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA5B92223F;
        Tue, 15 Sep 2020 14:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179951;
        bh=BDXVLGtgfALvqJr0hfYj/zaa8gtYGN7dGr2zBe5AEcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KT6vG9SXhtc2HJdZw9cqeAtnpQ32QjvHAQorxfXUEiBq90c35yRMYck0czWXHH6+7
         QtkmUSRFgKnuDBghjw0HUKFXCFPHokkV+iNlxBbo2z9FsRUreR/eVAcF/PmnlZWjif
         SMn15/57fTZqCS8FjEZWEAvTEyEK4Qdsnrm7k7vU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3ad9614a12f80994c32e@syzkaller.appspotmail.com,
        Tycho Andersen <tycho@tycho.pizza>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 049/177] seccomp: dont leak memory when filter install races
Date:   Tue, 15 Sep 2020 16:12:00 +0200
Message-Id: <20200915140655.981547095@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tycho Andersen <tycho@tycho.pizza>

[ Upstream commit a566a9012acd7c9a4be7e30dc7acb7a811ec2260 ]

In seccomp_set_mode_filter() with TSYNC | NEW_LISTENER, we first initialize
the listener fd, then check to see if we can actually use it later in
seccomp_may_assign_mode(), which can fail if anyone else in our thread
group has installed a filter and caused some divergence. If we can't, we
partially clean up the newly allocated file: we put the fd, put the file,
but don't actually clean up the *memory* that was allocated at
filter->notif. Let's clean that up too.

To accomplish this, let's hoist the actual "detach a notifier from a
filter" code to its own helper out of seccomp_notify_release(), so that in
case anyone adds stuff to init_listener(), they only have to add the
cleanup code in one spot. This does a bit of extra locking and such on the
failure path when the filter is not attached, but it's a slow failure path
anyway.

Fixes: 51891498f2da ("seccomp: allow TSYNC and USER_NOTIF together")
Reported-by: syzbot+3ad9614a12f80994c32e@syzkaller.appspotmail.com
Signed-off-by: Tycho Andersen <tycho@tycho.pizza>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/20200902014017.934315-1-tycho@tycho.pizza
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/seccomp.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index c461ba9925136..54cf84bac3c9b 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -997,13 +997,12 @@ out:
 }
 
 #ifdef CONFIG_SECCOMP_FILTER
-static int seccomp_notify_release(struct inode *inode, struct file *file)
+static void seccomp_notify_detach(struct seccomp_filter *filter)
 {
-	struct seccomp_filter *filter = file->private_data;
 	struct seccomp_knotif *knotif;
 
 	if (!filter)
-		return 0;
+		return;
 
 	mutex_lock(&filter->notify_lock);
 
@@ -1025,6 +1024,13 @@ static int seccomp_notify_release(struct inode *inode, struct file *file)
 	kfree(filter->notif);
 	filter->notif = NULL;
 	mutex_unlock(&filter->notify_lock);
+}
+
+static int seccomp_notify_release(struct inode *inode, struct file *file)
+{
+	struct seccomp_filter *filter = file->private_data;
+
+	seccomp_notify_detach(filter);
 	__put_seccomp_filter(filter);
 	return 0;
 }
@@ -1358,6 +1364,7 @@ out_put_fd:
 			listener_f->private_data = NULL;
 			fput(listener_f);
 			put_unused_fd(listener);
+			seccomp_notify_detach(prepared);
 		} else {
 			fd_install(listener, listener_f);
 			ret = listener;
-- 
2.25.1



