Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7AB4BCF33
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 15:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbiBTO4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 09:56:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239021AbiBTO4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 09:56:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7D345AD8
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 06:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DFE5611B3
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 14:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AB0C340E8;
        Sun, 20 Feb 2022 14:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645368956;
        bh=FYZov7ebc+1ZW+cbkZFofJ2eNydURSWtZ4UtPtyu60w=;
        h=Subject:To:Cc:From:Date:From;
        b=CfQWlPx2vPmhb6mlyox0infdvJPvBBTvBSMh9iCtSPR9DSDW+bA0F88unxBDKzbYV
         GsUEHwUguxyUgfiB+JrH2t0Lnfv18vVO4XsVU0yecKyjEg5Jkhw61HLmfdC8MmYQyY
         pmN0/OE8G9Tls5YilPOTZS3zqeFUQF+eFXDkVmmA=
Subject: FAILED: patch "[PATCH] NFS: Do not report writeback errors in nfs_getattr()" failed to apply to 4.14-stable tree
To:     trond.myklebust@hammerspace.com, Anna.Schumaker@Netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 20 Feb 2022 15:55:53 +0100
Message-ID: <164536895312895@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d19e0183a88306acda07f4a01fedeeffe2a2a06b Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Tue, 15 Feb 2022 18:05:18 -0500
Subject: [PATCH] NFS: Do not report writeback errors in nfs_getattr()

The result of the writeback, whether it is an ENOSPC or an EIO, or
anything else, does not inhibit the NFS client from reporting the
correct file timestamps.

Fixes: 79566ef018f5 ("NFS: Getattr doesn't require data sync semantics")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index a918c3a834b6..d96baa4450e3 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -853,12 +853,9 @@ int nfs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 	}
 
 	/* Flush out writes to the server in order to update c/mtime.  */
-	if ((request_mask & (STATX_CTIME|STATX_MTIME)) &&
-			S_ISREG(inode->i_mode)) {
-		err = filemap_write_and_wait(inode->i_mapping);
-		if (err)
-			goto out;
-	}
+	if ((request_mask & (STATX_CTIME | STATX_MTIME)) &&
+	    S_ISREG(inode->i_mode))
+		filemap_write_and_wait(inode->i_mapping);
 
 	/*
 	 * We may force a getattr if the user cares about atime.

