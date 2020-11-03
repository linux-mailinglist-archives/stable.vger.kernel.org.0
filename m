Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16DD2A5708
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbgKCVdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731190AbgKCU44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A69E92053B;
        Tue,  3 Nov 2020 20:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437016;
        bh=wckzC39GFGHqWU0KEpBCK8E57m64cHZTVwf5aaZZpo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVWPVVi7RnbnNox7kaarOjDySMWPJFkbU7oHGN/i+0fngO1lV+8j3wgHSIBPUAKga
         fB4LDttQKVDdGC4+IhZKjO75e+x7Z8K72qaf0k3kmkx2eUVW0bo3PQXoDIXOYhYtCs
         He2izo8oO8BQc5ByiZ1+ufEvSlGbCz+v1HmznZPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashish Sangwan <ashishsangwan2@gmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 109/214] NFS: fix nfs_path in case of a rename retry
Date:   Tue,  3 Nov 2020 21:35:57 +0100
Message-Id: <20201103203301.151917125@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashish Sangwan <ashishsangwan2@gmail.com>

commit 247db73560bc3e5aef6db50c443c3c0db115bc93 upstream.

We are generating incorrect path in case of rename retry because
we are restarting from wrong dentry. We should restart from the
dentry which was received in the call to nfs_path.

CC: stable@vger.kernel.org
Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/namespace.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -31,9 +31,9 @@ int nfs_mountpoint_expiry_timeout = 500
 /*
  * nfs_path - reconstruct the path given an arbitrary dentry
  * @base - used to return pointer to the end of devname part of path
- * @dentry - pointer to dentry
+ * @dentry_in - pointer to dentry
  * @buffer - result buffer
- * @buflen - length of buffer
+ * @buflen_in - length of buffer
  * @flags - options (see below)
  *
  * Helper function for constructing the server pathname
@@ -48,15 +48,19 @@ int nfs_mountpoint_expiry_timeout = 500
  *		       the original device (export) name
  *		       (if unset, the original name is returned verbatim)
  */
-char *nfs_path(char **p, struct dentry *dentry, char *buffer, ssize_t buflen,
-	       unsigned flags)
+char *nfs_path(char **p, struct dentry *dentry_in, char *buffer,
+	       ssize_t buflen_in, unsigned flags)
 {
 	char *end;
 	int namelen;
 	unsigned seq;
 	const char *base;
+	struct dentry *dentry;
+	ssize_t buflen;
 
 rename_retry:
+	buflen = buflen_in;
+	dentry = dentry_in;
 	end = buffer+buflen;
 	*--end = '\0';
 	buflen--;


