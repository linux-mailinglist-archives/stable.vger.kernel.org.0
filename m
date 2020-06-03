Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB19E1EC680
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 03:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgFCBNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 21:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgFCBNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 21:13:38 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9BFC08C5C1
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 18:13:38 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z64so433183pfb.1
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 18:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+59owfc1kfwUQmXrWsFZ88Gj/vvbkDCiHlNMmcCSSdQ=;
        b=MA3GSCswyu++/KSXfQucWqe3bPqVm8H1OFBAVHdQh7mSpdt2pIR9Y+zSy8rF4+NbtM
         67cgLBLE1vYftoxcOJnOyO/mveyZq3yilJEQDJyKcLozP7t80+XbN1tCQj6x6pQLt25P
         PzSIMc529vLERmNd52ke0S4GvnPPkytABZ5SE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+59owfc1kfwUQmXrWsFZ88Gj/vvbkDCiHlNMmcCSSdQ=;
        b=gSia/GXnsXidcw6WalyUMMayNln4gFfauifJneeeu1Tg9g8xjZ6S70rwC4qk9QzvXM
         zBhj5ynCEGYLNOYuz7EazXUvNmKgMfw/VEebJZ+fGDtGZejub93i9WZIH8aMrCPODwZe
         dgcR6znRRwSNlWb8sXkILxo64cYi2/UzShnvdH2DUl5UJL7X+zKawEpT99PHt2w5Z/e6
         BrssCTMuLhRU6kwyN8kDHcEnqZnXUY/tvLbak+bp++8P9fLs9ZwvnCNbbhtfCCcxFPpN
         Ppkp10MDcFZP/DyvdjNPkJF6Rd4dvO5zmb24CzMTUe1t1mSfqYLr1jVW9ccI2PeQTIXJ
         MKRA==
X-Gm-Message-State: AOAM532Px4VSHblc9sHYOa+G0Krj9HZu6eXn+7TOz02oqfjb4hWGntug
        mJHBRhHv/DOFE9yC+Se2FGUhqw==
X-Google-Smtp-Source: ABdhPJwckHAc8V9MBQtC6yo7HcEMaJ9lBJTETreQJvAVJAA4IqhSbgVvN3lZo1k6FmnbUjDCAirO5Q==
X-Received: by 2002:a17:90a:b949:: with SMTP id f9mr2185235pjw.79.1591146817924;
        Tue, 02 Jun 2020 18:13:37 -0700 (PDT)
Received: from ubuntu.netflix.com (203.20.25.136.in-addr.arpa. [136.25.20.203])
        by smtp.gmail.com with ESMTPSA id a12sm263222pjw.35.2020.06.02.18.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 18:13:37 -0700 (PDT)
From:   Sargun Dhillon <sargun@sargun.me>
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Sargun Dhillon <sargun@sargun.me>, Tycho Andersen <tycho@tycho.ws>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Robert Sesek <rsesek@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        containers@lists.linux-foundation.org,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.r.fastabend@intel.com>,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org,
        cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to move fds across processes
Date:   Tue,  2 Jun 2020 18:10:41 -0700
Message-Id: <20200603011044.7972-2-sargun@sargun.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200603011044.7972-1-sargun@sargun.me>
References: <20200603011044.7972-1-sargun@sargun.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Previously there were two chunks of code where the logic to receive file
descriptors was duplicated in net. The compat version of copying
file descriptors via SCM_RIGHTS did not have logic to update cgroups.
Logic to change the cgroup data was added in:
commit 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
commit d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")

This was not copied to the compat path. This commit fixes that, and thus
should be cherry-picked into stable.

This introduces a helper (file_receive) which encapsulates the logic for
handling calling security hooks as well as manipulating cgroup information.
This helper can then be used other places in the kernel where file
descriptors are copied between processes

I tested cgroup classid setting on both the compat (x32) path, and the
native path to ensure that when moving the file descriptor the classid
is set.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Suggested-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jann Horn <jannh@google.com>,
Cc: John Fastabend <john.r.fastabend@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: stable@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 fs/file.c            | 35 +++++++++++++++++++++++++++++++++++
 include/linux/file.h |  1 +
 net/compat.c         | 10 +++++-----
 net/core/scm.c       | 14 ++++----------
 4 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index abb8b7081d7a..5afd76fca8c2 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -18,6 +18,9 @@
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
+#include <net/sock.h>
+#include <net/netprio_cgroup.h>
+#include <net/cls_cgroup.h>
 
 unsigned int sysctl_nr_open __read_mostly = 1024*1024;
 unsigned int sysctl_nr_open_min = BITS_PER_LONG;
@@ -931,6 +934,38 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
 	return err;
 }
 
+/*
+ * File Receive - Receive a file from another process
+ *
+ * This function is designed to receive files from other tasks. It encapsulates
+ * logic around security and cgroups. The file descriptor provided must be a
+ * freshly allocated (unused) file descriptor.
+ *
+ * This helper does not consume a reference to the file, so the caller must put
+ * their reference.
+ *
+ * Returns 0 upon success.
+ */
+int file_receive(int fd, struct file *file)
+{
+	struct socket *sock;
+	int err;
+
+	err = security_file_receive(file);
+	if (err)
+		return err;
+
+	fd_install(fd, get_file(file));
+
+	sock = sock_from_file(file, &err);
+	if (sock) {
+		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
+		sock_update_classid(&sock->sk->sk_cgrp_data);
+	}
+
+	return 0;
+}
+
 static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
 	int err = -EBADF;
diff --git a/include/linux/file.h b/include/linux/file.h
index 142d102f285e..7b56dc23e560 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -94,4 +94,5 @@ extern void fd_install(unsigned int fd, struct file *file);
 extern void flush_delayed_fput(void);
 extern void __fput_sync(struct file *);
 
+extern int file_receive(int fd, struct file *file);
 #endif /* __LINUX_FILE_H */
diff --git a/net/compat.c b/net/compat.c
index 4bed96e84d9a..8ac0e7e09208 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -293,9 +293,6 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
 
 	for (i = 0, cmfptr = (int __user *) CMSG_COMPAT_DATA(cm); i < fdmax; i++, cmfptr++) {
 		int new_fd;
-		err = security_file_receive(fp[i]);
-		if (err)
-			break;
 		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & kmsg->msg_flags
 					  ? O_CLOEXEC : 0);
 		if (err < 0)
@@ -306,8 +303,11 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
 			put_unused_fd(new_fd);
 			break;
 		}
-		/* Bump the usage count and install the file. */
-		fd_install(new_fd, get_file(fp[i]));
+		err = file_receive(new_fd, fp[i]);
+		if (err) {
+			put_unused_fd(new_fd);
+			break;
+		}
 	}
 
 	if (i > 0) {
diff --git a/net/core/scm.c b/net/core/scm.c
index dc6fed1f221c..ba93abf2881b 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -303,11 +303,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 	for (i=0, cmfptr=(__force int __user *)CMSG_DATA(cm); i<fdmax;
 	     i++, cmfptr++)
 	{
-		struct socket *sock;
 		int new_fd;
-		err = security_file_receive(fp[i]);
-		if (err)
-			break;
 		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & msg->msg_flags
 					  ? O_CLOEXEC : 0);
 		if (err < 0)
@@ -318,13 +314,11 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 			put_unused_fd(new_fd);
 			break;
 		}
-		/* Bump the usage count and install the file. */
-		sock = sock_from_file(fp[i], &err);
-		if (sock) {
-			sock_update_netprioidx(&sock->sk->sk_cgrp_data);
-			sock_update_classid(&sock->sk->sk_cgrp_data);
+		err = file_receive(new_fd, fp[i]);
+		if (err) {
+			put_unused_fd(new_fd);
+			break;
 		}
-		fd_install(new_fd, get_file(fp[i]));
 	}
 
 	if (i > 0)
-- 
2.25.1

