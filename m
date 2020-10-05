Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC8228331B
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 11:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgJEJX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 05:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJEJX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 05:23:26 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E9EC0613CE;
        Mon,  5 Oct 2020 02:23:26 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so6459961pff.6;
        Mon, 05 Oct 2020 02:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qGE1hqJMTpJDbPinNcIwyJ/y/qQief1uJTtMUva0Xfo=;
        b=OQf48a1zYvw7KiwcMeOtPiRRj8wUnUpabQexmF4lzIEO1QkKoC7cutJ/Bl3wTnu8vu
         0FVr8vt0xkA2q5ga2cwhdRAeqheOn9CxXlS+XY1ToVDTSrzN8wmsj+500G610LK+MXOe
         zYOBLacprqMSqob4UEMAo92HXzegxXW8DrC4LhUOWC9WFfcRkzsX35it/9YYH0wksNS9
         UzrdnBW58qVDkfbFx7IWTvBN5JI3O5hnlpR6OqyLOpxZ/0TN/sfYlQzOwrxNHnBlFgSk
         2JC64dJdMzVtiYZ68z08ceorl8refD5OCy5vpmMSgYtJ/Ky3nnlhtmYhrIt2HFkbAz6s
         WZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qGE1hqJMTpJDbPinNcIwyJ/y/qQief1uJTtMUva0Xfo=;
        b=GoQ0+ZynYexThgDZtSsWKgWsMPNSk/ktmIK0Xjxbpy7Lml8jfCqKAriwlzXYXca974
         Qs6W98ASXfMd0BYiyiEY68Uvg7FLuxnsJPGeDjbS9D50akn5piUKJu7ZmJmajClszf8B
         68dYYS7zK9sHInWTTNMwz/SWgLsEBBr/cBZvPQJIzfJdL5SYXS9DJ3ZK/87aOQ8WvbSh
         mGPrrZOUJkm+ic1R/7Rh1jIpq+JVF/5ldxyqJvzwJfkuOcunx85giJV84YHJbC+zxWDP
         68XmX1PsNWCY19BNJjLzwfx9X/jUKFIhemdqpr6BbuV3jMVQLZP8VNQuGmQoW6QyvCK3
         zsBA==
X-Gm-Message-State: AOAM530VdurQOg/3Fhj2/VFR5MkFimKZr2ATgKJ8/vJ4/ve8kZeGMF1D
        m74JKRNAKVTzS4B7HB95YLojLrXIrOYN82gZ+x/GJw==
X-Google-Smtp-Source: ABdhPJy1IflB+nGDCV2ETraG4lOf3YChuw9mCl2FqLQY/LT+41vnAj7vDYhQBRBmJRH5FwCfotnc9Q==
X-Received: by 2002:a63:ed01:: with SMTP id d1mr13716662pgi.58.1601889806302;
        Mon, 05 Oct 2020 02:23:26 -0700 (PDT)
Received: from ashish-sangwan.user.nutanix.com (mcp02.nutanix.com. [192.146.155.5])
        by smtp.googlemail.com with ESMTPSA id q65sm11929699pfq.219.2020.10.05.02.23.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2020 02:23:25 -0700 (PDT)
From:   Ashish Sangwan <ashishsangwan2@gmail.com>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>
Cc:     ashishsangwan2@gmail.com, stable@vger.kernel.org,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFS: fix nfs_path in case of a rename retry
Date:   Mon,  5 Oct 2020 02:22:43 -0700
Message-Id: <20201005092243.105168-1-ashishsangwan2@gmail.com>
X-Mailer: git-send-email 2.16.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We are generating incorrect path in case of rename retry because
we are restarting from wrong dentry. We should restart from the
dentry which was received in the call to nfs_path.

CC: stable@vger.kernel.org
Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
---
 fs/nfs/namespace.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 6b063227e34e..2bcbe38afe2e 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -32,9 +32,9 @@ int nfs_mountpoint_expiry_timeout = 500 * HZ;
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
@@ -49,15 +49,19 @@ int nfs_mountpoint_expiry_timeout = 500 * HZ;
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
-- 
2.22.0

