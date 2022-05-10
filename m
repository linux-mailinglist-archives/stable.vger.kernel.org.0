Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF315219CC
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbiEJNvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244649AbiEJNqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:46:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1267A16A260;
        Tue, 10 May 2022 06:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF547B81D24;
        Tue, 10 May 2022 13:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BD1C385A6;
        Tue, 10 May 2022 13:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189504;
        bh=HMkPzu0U3NUOKTa8txjuV7KsMyHeKV537byhEaLBu1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0jB5Bg1syNHT0gj9kJi1cjc7p82gC5cMckRpGCz2MO6sNEq10XOR+/EjxkYpBeEC
         fLiXk3PouM5ajKP6bxb5IJTVAII1vqf8697n4EorUah2UInvzHjbtbGV7sjOsPpuMo
         1Ju9PnCj86EU0ZjJcXUWn5+KkrfQVB0U5Dbrf3Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 071/135] btrfs: do not BUG_ON() on failure to update inode when setting xattr
Date:   Tue, 10 May 2022 15:07:33 +0200
Message-Id: <20220510130742.448498897@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
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
@@ -264,7 +264,8 @@ int btrfs_setxattr_trans(struct inode *i
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
 	ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
-	BUG_ON(ret);
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
 out:
 	if (start_trans)
 		btrfs_end_transaction(trans);
@@ -418,7 +419,8 @@ static int btrfs_xattr_handler_set_prop(
 		inode_inc_iversion(inode);
 		inode->i_ctime = current_time(inode);
 		ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
-		BUG_ON(ret);
+		if (ret)
+			btrfs_abort_transaction(trans, ret);
 	}
 
 	btrfs_end_transaction(trans);


