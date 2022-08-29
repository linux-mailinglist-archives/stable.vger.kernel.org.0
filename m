Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5F85A4839
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiH2LHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiH2LGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:06:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750D011177;
        Mon, 29 Aug 2022 04:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C349611BD;
        Mon, 29 Aug 2022 11:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB4FC433C1;
        Mon, 29 Aug 2022 11:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770997;
        bh=mJwK8c6C68zneecaNx23HbUHfdyLR1wIDgrBIkJKT3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2sJF/PwmQV9Gr6ooXOEGNgxpFtQ2HzYZuAtvxYuaWg08T5FWFJ1Qvw+4SeBRx5EY
         JTpICqDbWUtoM1lGCv7Pm3pS3SXY5DRXzwA9/KMCoyQtsbBJVlvaariQP66EDDCL5z
         lrw72fGkh/6xeOEenTOlSuWoIRFtd5H2gaUeo3Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 05/86] xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
Date:   Mon, 29 Aug 2022 12:58:31 +0200
Message-Id: <20220829105756.743714196@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 6ed6356b07714e0198be3bc3ecccc8b40a212de4 upstream.

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_ioctl.c |    2 +-
 fs/xfs/xfs_ioctl.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -371,7 +371,7 @@ int
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


