Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C7D1631D9
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgBRUDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728097AbgBRUDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DA3A24672;
        Tue, 18 Feb 2020 20:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056187;
        bh=cBSZwUoeZg2M9ZZiJYr7n9YyDhNS7A7CyrgCYxfwhys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsVVOF+Mi0/qc4HR9sQNlgMM+kPetOVNBtoyS6dDUg4cJIzsEwrG+YWD4FjxYpusw
         9wh2epJjc8sfg+xvQRqrkoFguoQEDqdwLLj+htpJ8S1XWY+EiL+J01y1tJ0/+LIpxj
         fSVK/J/fjFN2stWyTlonu4dmNicJ7xTvKa0yT4BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.5 67/80] ceph: noacl mount option is effectively ignored
Date:   Tue, 18 Feb 2020 20:55:28 +0100
Message-Id: <20200218190438.385837347@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

commit 3b20bc2fe4c0cfd82d35838965dc7ff0b93415c6 upstream.

For the old mount API, the module parameters parseing function will
be called in ceph_mount() and also just after the default posix acl
flag set, so we can control to enable/disable it via the mount option.

But for the new mount API, it will call the module parameters
parseing function before ceph_get_tree(), so the posix acl will always
be enabled.

Fixes: 82995cc6c5ae ("libceph, rbd, ceph: convert to use the new mount API")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1020,10 +1020,6 @@ static int ceph_get_tree(struct fs_conte
 	if (!fc->source)
 		return invalf(fc, "ceph: No source");
 
-#ifdef CONFIG_CEPH_FS_POSIX_ACL
-	fc->sb_flags |= SB_POSIXACL;
-#endif
-
 	/* create client (which we may/may not use) */
 	fsc = create_fs_client(pctx->opts, pctx->copts);
 	pctx->opts = NULL;
@@ -1141,6 +1137,10 @@ static int ceph_init_fs_context(struct f
 	fsopt->max_readdir_bytes = CEPH_MAX_READDIR_BYTES_DEFAULT;
 	fsopt->congestion_kb = default_congestion_kb();
 
+#ifdef CONFIG_CEPH_FS_POSIX_ACL
+	fc->sb_flags |= SB_POSIXACL;
+#endif
+
 	fc->fs_private = pctx;
 	fc->ops = &ceph_context_ops;
 	return 0;


