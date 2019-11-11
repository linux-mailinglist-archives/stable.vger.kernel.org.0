Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1994AF7E25
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfKKSuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730342AbfKKSuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06B9204FD;
        Mon, 11 Nov 2019 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498213;
        bh=hVmqAbFOrX+ZvSt3WWN9P4O58xdleihIUgCcUvKx3yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6Xahj/fiTYv1ldhV7KMz32cnaN+zoPMIAG+v/4uI1NKkvIhRzHMxlY1ZijQpY5GS
         O1MCTA+Ul8u7yNTGnu6Q6RidqtQcMZieYdJrl2rG4YWLdsXppOdNvmAx59ER8CbZiq
         xyLChTkmrWj/9h0SxwDlXuVXyHtRbyXKbMJHkgBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.3 054/193] ceph: dont try to handle hashed dentries in non-O_CREAT atomic_open
Date:   Mon, 11 Nov 2019 19:27:16 +0100
Message-Id: <20191111181504.975184904@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 5bb5e6ee6f5c557dcd19822eccd7bcced1e1a410 upstream.

If ceph_atomic_open is handed a !d_in_lookup dentry, then that means
that it already passed d_revalidate so we *know* that it's negative (or
at least was very recently). Just return -ENOENT in that case.

This also addresses a subtle bug in dentry handling. Non-O_CREAT opens
call atomic_open with the parent's i_rwsem shared, but calling
d_splice_alias on a hashed dentry requires the exclusive lock.

If ceph_atomic_open receives a hashed, negative dentry on a non-O_CREAT
open, and another client were to race in and create the file before we
issue our OPEN, ceph_fill_trace could end up calling d_splice_alias on
the dentry with the new inode with insufficient locks.

Cc: stable@vger.kernel.org
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/file.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -458,6 +458,9 @@ int ceph_atomic_open(struct inode *dir,
 		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
 		if (err < 0)
 			goto out_ctx;
+	} else if (!d_in_lookup(dentry)) {
+		/* If it's not being looked up, it's negative */
+		return -ENOENT;
 	}
 
 	/* do the open */


