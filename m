Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E593C5221
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349864AbhGLHox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347853AbhGLHkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FAAF61469;
        Mon, 12 Jul 2021 07:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075395;
        bh=Vpgq6X5cPfItKhrQdkf+YbXlVg8r9CqVZm+PqciBKyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GQwZaOeEVaKT9J2pHzs5Cte+8xregFRMTaSOxD+nYHrFer4v7xi4Xmru8ycRXoWC
         pcCHDVHgO2Z+JE8DC0KjGN09zSjfHrKw/85HOprBaILI3bTjxpT9O9nJGKUZs6lANP
         qaoQqkRvqdJsWtBFpqbI7cNP56YoaTLKg2C4kcK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rodrigo Campos <rodrigo@kinvolk.io>,
        Sargun Dhillon <sargun@sargun.me>,
        Tycho Andersen <tycho@tycho.pizza>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 207/800] seccomp: Support atomic "addfd + send reply"
Date:   Mon, 12 Jul 2021 08:03:50 +0200
Message-Id: <20210712060942.387895844@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Campos <rodrigo@kinvolk.io>

[ Upstream commit 0ae71c7720e3ae3aabd2e8a072d27f7bd173d25c ]

Alban Crequy reported a race condition userspace faces when we want to
add some fds and make the syscall return them[1] using seccomp notify.

The problem is that currently two different ioctl() calls are needed by
the process handling the syscalls (agent) for another userspace process
(target): SECCOMP_IOCTL_NOTIF_ADDFD to allocate the fd and
SECCOMP_IOCTL_NOTIF_SEND to return that value. Therefore, it is possible
for the agent to do the first ioctl to add a file descriptor but the
target is interrupted (EINTR) before the agent does the second ioctl()
call.

This patch adds a flag to the ADDFD ioctl() so it adds the fd and
returns that value atomically to the target program, as suggested by
Kees Cook[2]. This is done by simply allowing
seccomp_do_user_notification() to add the fd and return it in this case.
Therefore, in this case the target wakes up from the wait in
seccomp_do_user_notification() either to interrupt the syscall or to add
the fd and return it.

This "allocate an fd and return" functionality is useful for syscalls
that return a file descriptor only, like connect(2). Other syscalls that
return a file descriptor but not as return value (or return more than
one fd), like socketpair(), pipe(), recvmsg with SCM_RIGHTs, will not
work with this flag.

This effectively combines SECCOMP_IOCTL_NOTIF_ADDFD and
SECCOMP_IOCTL_NOTIF_SEND into an atomic opteration. The notification's
return value, nor error can be set by the user. Upon successful invocation
of the SECCOMP_IOCTL_NOTIF_ADDFD ioctl with the SECCOMP_ADDFD_FLAG_SEND
flag, the notifying process's errno will be 0, and the return value will
be the file descriptor number that was installed.

[1]: https://lore.kernel.org/lkml/CADZs7q4sw71iNHmV8EOOXhUKJMORPzF7thraxZYddTZsxta-KQ@mail.gmail.com/
[2]: https://lore.kernel.org/lkml/202012011322.26DCBC64F2@keescook/

Signed-off-by: Rodrigo Campos <rodrigo@kinvolk.io>
Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Acked-by: Tycho Andersen <tycho@tycho.pizza>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210517193908.3113-4-sargun@sargun.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../userspace-api/seccomp_filter.rst          | 12 +++++
 include/uapi/linux/seccomp.h                  |  1 +
 kernel/seccomp.c                              | 51 ++++++++++++++++---
 3 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index 6efb41cc8072..d61219889e49 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -259,6 +259,18 @@ and ``ioctl(SECCOMP_IOCTL_NOTIF_SEND)`` a response, indicating what should be
 returned to userspace. The ``id`` member of ``struct seccomp_notif_resp`` should
 be the same ``id`` as in ``struct seccomp_notif``.
 
+Userspace can also add file descriptors to the notifying process via
+``ioctl(SECCOMP_IOCTL_NOTIF_ADDFD)``. The ``id`` member of
+``struct seccomp_notif_addfd`` should be the same ``id`` as in
+``struct seccomp_notif``. The ``newfd_flags`` flag may be used to set flags
+like O_EXEC on the file descriptor in the notifying process. If the supervisor
+wants to inject the file descriptor with a specific number, the
+``SECCOMP_ADDFD_FLAG_SETFD`` flag can be used, and set the ``newfd`` member to
+the specific number to use. If that file descriptor is already open in the
+notifying process it will be replaced. The supervisor can also add an FD, and
+respond atomically by using the ``SECCOMP_ADDFD_FLAG_SEND`` flag and the return
+value will be the injected file descriptor number.
+
 It is worth noting that ``struct seccomp_data`` contains the values of register
 arguments to the syscall, but does not contain pointers to memory. The task's
 memory is accessible to suitably privileged traces via ``ptrace()`` or
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 6ba18b82a02e..78074254ab98 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -115,6 +115,7 @@ struct seccomp_notif_resp {
 
 /* valid flags for seccomp_notif_addfd */
 #define SECCOMP_ADDFD_FLAG_SETFD	(1UL << 0) /* Specify remote fd */
+#define SECCOMP_ADDFD_FLAG_SEND		(1UL << 1) /* Addfd and return it, atomically */
 
 /**
  * struct seccomp_notif_addfd
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 9f58049ac16d..057e17f3215d 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -107,6 +107,7 @@ struct seccomp_knotif {
  *      installing process should allocate the fd as normal.
  * @flags: The flags for the new file descriptor. At the moment, only O_CLOEXEC
  *         is allowed.
+ * @ioctl_flags: The flags used for the seccomp_addfd ioctl.
  * @ret: The return value of the installing process. It is set to the fd num
  *       upon success (>= 0).
  * @completion: Indicates that the installing process has completed fd
@@ -118,6 +119,7 @@ struct seccomp_kaddfd {
 	struct file *file;
 	int fd;
 	unsigned int flags;
+	__u32 ioctl_flags;
 
 	union {
 		bool setfd;
@@ -1065,18 +1067,37 @@ static u64 seccomp_next_notify_id(struct seccomp_filter *filter)
 	return filter->notif->next_id++;
 }
 
-static void seccomp_handle_addfd(struct seccomp_kaddfd *addfd)
+static void seccomp_handle_addfd(struct seccomp_kaddfd *addfd, struct seccomp_knotif *n)
 {
+	int fd;
+
 	/*
 	 * Remove the notification, and reset the list pointers, indicating
 	 * that it has been handled.
 	 */
 	list_del_init(&addfd->list);
 	if (!addfd->setfd)
-		addfd->ret = receive_fd(addfd->file, addfd->flags);
+		fd = receive_fd(addfd->file, addfd->flags);
 	else
-		addfd->ret = receive_fd_replace(addfd->fd, addfd->file,
-						addfd->flags);
+		fd = receive_fd_replace(addfd->fd, addfd->file, addfd->flags);
+	addfd->ret = fd;
+
+	if (addfd->ioctl_flags & SECCOMP_ADDFD_FLAG_SEND) {
+		/* If we fail reset and return an error to the notifier */
+		if (fd < 0) {
+			n->state = SECCOMP_NOTIFY_SENT;
+		} else {
+			/* Return the FD we just added */
+			n->flags = 0;
+			n->error = 0;
+			n->val = fd;
+		}
+	}
+
+	/*
+	 * Mark the notification as completed. From this point, addfd mem
+	 * might be invalidated and we can't safely read it anymore.
+	 */
 	complete(&addfd->completion);
 }
 
@@ -1120,7 +1141,7 @@ static int seccomp_do_user_notification(int this_syscall,
 						 struct seccomp_kaddfd, list);
 		/* Check if we were woken up by a addfd message */
 		if (addfd)
-			seccomp_handle_addfd(addfd);
+			seccomp_handle_addfd(addfd, &n);
 
 	}  while (n.state != SECCOMP_NOTIFY_REPLIED);
 
@@ -1581,7 +1602,7 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
 	if (addfd.newfd_flags & ~O_CLOEXEC)
 		return -EINVAL;
 
-	if (addfd.flags & ~SECCOMP_ADDFD_FLAG_SETFD)
+	if (addfd.flags & ~(SECCOMP_ADDFD_FLAG_SETFD | SECCOMP_ADDFD_FLAG_SEND))
 		return -EINVAL;
 
 	if (addfd.newfd && !(addfd.flags & SECCOMP_ADDFD_FLAG_SETFD))
@@ -1591,6 +1612,7 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
 	if (!kaddfd.file)
 		return -EBADF;
 
+	kaddfd.ioctl_flags = addfd.flags;
 	kaddfd.flags = addfd.newfd_flags;
 	kaddfd.setfd = addfd.flags & SECCOMP_ADDFD_FLAG_SETFD;
 	kaddfd.fd = addfd.newfd;
@@ -1616,6 +1638,23 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
 		goto out_unlock;
 	}
 
+	if (addfd.flags & SECCOMP_ADDFD_FLAG_SEND) {
+		/*
+		 * Disallow queuing an atomic addfd + send reply while there are
+		 * some addfd requests still to process.
+		 *
+		 * There is no clear reason to support it and allows us to keep
+		 * the loop on the other side straight-forward.
+		 */
+		if (!list_empty(&knotif->addfd)) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+
+		/* Allow exactly only one reply */
+		knotif->state = SECCOMP_NOTIFY_REPLIED;
+	}
+
 	list_add(&kaddfd.list, &knotif->addfd);
 	complete(&knotif->ready);
 	mutex_unlock(&filter->notify_lock);
-- 
2.30.2



