Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD73582DB7
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241239AbiG0RBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241243AbiG0RAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:00:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD046B249;
        Wed, 27 Jul 2022 09:37:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A4C6603F2;
        Wed, 27 Jul 2022 16:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2DAC433D7;
        Wed, 27 Jul 2022 16:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939872;
        bh=9gQy/2TtoYzwkDBx0KaJhGl6Nd2Cd9T0Qtfah1XWqgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZeCbgjZ+wL0oX8l3jj0zQr7DsP+AFrXlLaKL6ZUVa0FW4BUGcrGKIvODHykjy+j0t
         wMkzfKXhJaw0OhB4Ia6KtLpfkfIauoekcxD5BuMmvCgxZnK11LrwOxzqqi+ZnHWJAX
         BBaIdgilJHHEWxmwVPZvMpPk5R+ooQ2FFKkbaBgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 026/201] xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
Date:   Wed, 27 Jul 2022 18:08:50 +0200
Message-Id: <20220727161027.976166418@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6ed6356b07714e0198be3bc3ecccc8b40a212de4 ]

The "bufsize" comes from the root user.  If "bufsize" is negative then,
because of type promotion, neither of the validation checks at the start
of the function are able to catch it:

	if (bufsize < sizeof(struct xfs_attrlist) ||
	    bufsize > XFS_XATTR_LIST_MAX)
		return -EINVAL;

This means "bufsize" will trigger (WARN_ON_ONCE(size > INT_MAX)) in
kvmalloc_node().  Fix this by changing the type from int to size_t.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_ioctl.c |    2 +-
 fs/xfs/xfs_ioctl.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -372,7 +372,7 @@ int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
 	void __user			*ubuf,
-	int				bufsize,
+	size_t				bufsize,
 	int				flags,
 	struct xfs_attrlist_cursor __user *ucursor)
 {
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -38,8 +38,9 @@ xfs_readlink_by_handle(
 int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
 		uint32_t *len, uint32_t flags);
-int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
-	int flags, struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
+		      size_t bufsize, int flags,
+		      struct xfs_attrlist_cursor __user *ucursor);
 
 extern struct dentry *
 xfs_handle_to_dentry(


