Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E3D5219B0
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240098AbiEJNuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343903AbiEJNsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875E76CF55;
        Tue, 10 May 2022 06:37:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3803E6165A;
        Tue, 10 May 2022 13:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE31C385C2;
        Tue, 10 May 2022 13:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189796;
        bh=XQ0h2uHZUhjeoY/xJUSScnleGdGqjSR97mfvJn+xSR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUCPoUfLtz8nZhWa3JqE2/4SbARubXa6/zZCXkS3cFYq5dR7IUNTS9ZWWEAncAEC4
         GyPq6tqw1D8dlH+Xhpc/wfHtvyA7tGQ7jEKw/QYPqacSH+Q4oPqKWsmCO5+pLhw67j
         iRH+sBTXAba2/w+9F6pFClJ94+mO2iJ3cHvcp5Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 030/140] btrfs: do not BUG_ON() on failure to update inode when setting xattr
Date:   Tue, 10 May 2022 15:07:00 +0200
Message-Id: <20220510130742.476046800@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 193b4e83986d7ee6caa8ceefb5ee9f58240fbee0 upstream.

We are doing a BUG_ON() if we fail to update an inode after setting (or
clearing) a xattr, but there's really no reason to not instead simply
abort the transaction and return the error to the caller. This should be
a rare error because we have previously reserved enough metadata space to
update the inode and the delayed inode should have already been setup, so
an -ENOSPC or -ENOMEM, which are the possible errors, are very unlikely to
happen.

So replace the BUG_ON()s with a transaction abort.

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/xattr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -262,7 +262,8 @@ int btrfs_setxattr_trans(struct inode *i
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
 	ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
-	BUG_ON(ret);
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
 out:
 	if (start_trans)
 		btrfs_end_transaction(trans);
@@ -416,7 +417,8 @@ static int btrfs_xattr_handler_set_prop(
 		inode_inc_iversion(inode);
 		inode->i_ctime = current_time(inode);
 		ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
-		BUG_ON(ret);
+		if (ret)
+			btrfs_abort_transaction(trans, ret);
 	}
 
 	btrfs_end_transaction(trans);


