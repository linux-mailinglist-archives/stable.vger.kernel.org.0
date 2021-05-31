Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC14396186
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhEaOlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234203AbhEaOji (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D3A861874;
        Mon, 31 May 2021 13:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469180;
        bh=MOa681YkjIDTsO/iqmYvJ5GkdkdHKU8MnIisXx/mwyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRM631/JslK+IvKRdjzCphN5XeIY5uoNPg1lRMok7+9SSm6RICPHM9R9qaTHxv6Mb
         WGAYnJgcVvQ8nrvBJgsDOULU6x2sAYiQ9wQUcyW5irRVkfW5jtV8zUXpvi+oYx5YLu
         bh60btuX4/chW6e//0VUAd5PUvalByqia7jvrJ8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Tycho Andersen <tycho@tycho.pizza>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Rodrigo Campos <rodrigo@kinvolk.io>
Subject: [PATCH 5.12 064/296] seccomp: Refactor notification handler to prepare for new semantics
Date:   Mon, 31 May 2021 15:11:59 +0200
Message-Id: <20210531130705.991657084@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sargun Dhillon <sargun@sargun.me>

commit ddc473916955f7710d1eb17c1273d91c8622a9fe upstream.

This refactors the user notification code to have a do / while loop around
the completion condition. This has a small change in semantic, in that
previously we ignored addfd calls upon wakeup if the notification had been
responded to, but instead with the new change we check for an outstanding
addfd calls prior to returning to userspace.

Rodrigo Campos also identified a bug that can result in addfd causing
an early return, when the supervisor didn't actually handle the
syscall [1].

[1]: https://lore.kernel.org/lkml/20210413160151.3301-1-rodrigo@kinvolk.io/

Fixes: 7cf97b125455 ("seccomp: Introduce addfd ioctl to seccomp user notifier")
Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Acked-by: Tycho Andersen <tycho@tycho.pizza>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Rodrigo Campos <rodrigo@kinvolk.io>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210517193908.3113-3-sargun@sargun.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/seccomp.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1098,28 +1098,30 @@ static int seccomp_do_user_notification(
 
 	up(&match->notif->request);
 	wake_up_poll(&match->wqh, EPOLLIN | EPOLLRDNORM);
-	mutex_unlock(&match->notify_lock);
 
 	/*
 	 * This is where we wait for a reply from userspace.
 	 */
-wait:
-	err = wait_for_completion_interruptible(&n.ready);
-	mutex_lock(&match->notify_lock);
-	if (err == 0) {
-		/* Check if we were woken up by a addfd message */
+	do {
+		mutex_unlock(&match->notify_lock);
+		err = wait_for_completion_interruptible(&n.ready);
+		mutex_lock(&match->notify_lock);
+		if (err != 0)
+			goto interrupted;
+
 		addfd = list_first_entry_or_null(&n.addfd,
 						 struct seccomp_kaddfd, list);
-		if (addfd && n.state != SECCOMP_NOTIFY_REPLIED) {
+		/* Check if we were woken up by a addfd message */
+		if (addfd)
 			seccomp_handle_addfd(addfd);
-			mutex_unlock(&match->notify_lock);
-			goto wait;
-		}
-		ret = n.val;
-		err = n.error;
-		flags = n.flags;
-	}
 
+	}  while (n.state != SECCOMP_NOTIFY_REPLIED);
+
+	ret = n.val;
+	err = n.error;
+	flags = n.flags;
+
+interrupted:
 	/* If there were any pending addfd calls, clear them out */
 	list_for_each_entry_safe(addfd, tmp, &n.addfd, list) {
 		/* The process went away before we got a chance to handle it */


