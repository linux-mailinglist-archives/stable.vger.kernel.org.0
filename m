Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E088051F7DE
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 11:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiEIJWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 05:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbiEIIt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:49:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D319B18B02
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:46:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FC3861447
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80081C385AB;
        Mon,  9 May 2022 08:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652085964;
        bh=hYQdria7EBoUxsTFRRNoiaAQUbdjFYJfa50/RIOO9Mo=;
        h=Subject:To:Cc:From:Date:From;
        b=Zlex423GR26+sYEwnmrNINCKWEv6vm/fWJMQe4aYfBC7HugciqGGtxmM2Z0Tkghbs
         2xYZ2HLzMdTRywFQQRJuTfan+JO9diD0rPDs7+StbcpZAg3kABHNx7RjSJEVUTGHsb
         wxSOJTN5w3QtXSGExnhwZElmL211wGOBAOVStXjI=
Subject: FAILED: patch "[PATCH] btrfs: do not BUG_ON() on failure to update inode when" failed to apply to 4.19-stable tree
To:     fdmanana@suse.com, anand.jain@oracle.com, dsterba@suse.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:45:54 +0200
Message-ID: <165208595414311@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 193b4e83986d7ee6caa8ceefb5ee9f58240fbee0 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 21 Apr 2022 11:03:09 +0100
Subject: [PATCH] btrfs: do not BUG_ON() on failure to update inode when
 setting xattr

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

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 9632d0ff2038..367bb87b66df 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -262,7 +262,8 @@ int btrfs_setxattr_trans(struct inode *inode, const char *name,
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
 	ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
-	BUG_ON(ret);
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
 out:
 	if (start_trans)
 		btrfs_end_transaction(trans);
@@ -416,7 +417,8 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 		inode_inc_iversion(inode);
 		inode->i_ctime = current_time(inode);
 		ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
-		BUG_ON(ret);
+		if (ret)
+			btrfs_abort_transaction(trans, ret);
 	}
 
 	btrfs_end_transaction(trans);

