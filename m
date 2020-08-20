Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8416D24B2CF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgHTJhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbgHTJhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:37:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0391F20724;
        Thu, 20 Aug 2020 09:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916234;
        bh=ublyth4NykMzai27siOdNCTMlMUHjhBoS5hQTtTF/HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDH1Ta0rZ4xMNOxDPx2ldMSJdMmvkCtuMRvNV2+HmLzKLdu4kM3ZpvnfdoB2yjHXt
         irR3N2ULY8tYKslnFEGAKTgcsRL4BsfYLVmx5XjZbQDPER3g20sUwxFlaoWEKEnl6j
         6gcy8Lb/cqMjRm/1JeTPb392AU7luzViM/5iWVJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Sargun Dhillon <sargun@sargun.me>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.7 056/204] net/compat: Add missing sock updates for SCM_RIGHTS
Date:   Thu, 20 Aug 2020 11:19:13 +0200
Message-Id: <20200820091609.066089993@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit d9539752d23283db4692384a634034f451261e29 upstream.

Add missed sock updates to compat path via a new helper, which will be
used more in coming patches. (The net/core/scm.c code is left as-is here
to assist with -stable backports for the compat path.)

Cc: Christoph Hellwig <hch@lst.de>
Cc: Sargun Dhillon <sargun@sargun.me>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
Fixes: d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/sock.h |    4 ++++
 net/compat.c       |    1 +
 net/core/sock.c    |   21 +++++++++++++++++++++
 3 files changed, 26 insertions(+)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -890,6 +890,8 @@ static inline int sk_memalloc_socks(void
 {
 	return static_branch_unlikely(&memalloc_socks_key);
 }
+
+void __receive_sock(struct file *file);
 #else
 
 static inline int sk_memalloc_socks(void)
@@ -897,6 +899,8 @@ static inline int sk_memalloc_socks(void
 	return 0;
 }
 
+static inline void __receive_sock(struct file *file)
+{ }
 #endif
 
 static inline gfp_t sk_gfp_mask(const struct sock *sk, gfp_t gfp_mask)
--- a/net/compat.c
+++ b/net/compat.c
@@ -307,6 +307,7 @@ void scm_detach_fds_compat(struct msghdr
 			break;
 		}
 		/* Bump the usage count and install the file. */
+		__receive_sock(fp[i]);
 		fd_install(new_fd, get_file(fp[i]));
 	}
 
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2753,6 +2753,27 @@ int sock_no_mmap(struct file *file, stru
 }
 EXPORT_SYMBOL(sock_no_mmap);
 
+/*
+ * When a file is received (via SCM_RIGHTS, etc), we must bump the
+ * various sock-based usage counts.
+ */
+void __receive_sock(struct file *file)
+{
+	struct socket *sock;
+	int error;
+
+	/*
+	 * The resulting value of "error" is ignored here since we only
+	 * need to take action when the file is a socket and testing
+	 * "sock" for NULL is sufficient.
+	 */
+	sock = sock_from_file(file, &error);
+	if (sock) {
+		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
+		sock_update_classid(&sock->sk->sk_cgrp_data);
+	}
+}
+
 ssize_t sock_no_sendpage(struct socket *sock, struct page *page, int offset, size_t size, int flags)
 {
 	ssize_t res;


