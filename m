Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F06D4BCF25
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 15:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238766AbiBTOzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 09:55:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbiBTOzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 09:55:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C59F45AD8
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 06:55:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF897611B3
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 14:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3631C340E8;
        Sun, 20 Feb 2022 14:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645368914;
        bh=i/3rODA4wv4cZuIrQH0EwmzJRM+tfWrOVasUJom1XFU=;
        h=Subject:To:Cc:From:Date:From;
        b=b/bMIDZ54EbQRGxMF/FIMIDAJpjF2XtO9696Xmcv+83UXLuObcfHamtqLlK2JBRit
         nV4ztLsxvSnC2mMgHs7BILUc3kMzgPs4JmgIjMxCVvczXCeGaXI8JkxnRaWyz0lewW
         bfY0VoOYUIChitYRguvudNKmcdSOLcAqxcphVy1E=
Subject: FAILED: patch "[PATCH] NFS: Remove an incorrect revalidation in" failed to apply to 5.10-stable tree
To:     trond.myklebust@hammerspace.com, Anna.Schumaker@Netapp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 20 Feb 2022 15:55:11 +0100
Message-ID: <1645368911171166@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9d047bf68fe8cdb4086deaf4edd119731a9481ed Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Tue, 8 Feb 2022 12:14:44 -0500
Subject: [PATCH] NFS: Remove an incorrect revalidation in
 nfs4_update_changeattr_locked()

In nfs4_update_changeattr_locked(), we don't need to set the
NFS_INO_REVAL_PAGECACHE flag, because we already know the value of the
change attribute, and we're already flagging the size. In fact, this
forces us to revalidate the change attribute a second time for no good
reason.
This extra flag appears to have been introduced as part of the xattr
feature, when update_changeattr_locked() was converted for use by the
xattr code.

Fixes: 1b523ca972ed ("nfs: modify update_changeattr to deal with regular files")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f5020828ab65..0e0db6c27619 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1229,8 +1229,7 @@ nfs4_update_changeattr_locked(struct inode *inode,
 				NFS_INO_INVALID_ACCESS | NFS_INO_INVALID_ACL |
 				NFS_INO_INVALID_SIZE | NFS_INO_INVALID_OTHER |
 				NFS_INO_INVALID_BLOCKS | NFS_INO_INVALID_NLINK |
-				NFS_INO_INVALID_MODE | NFS_INO_INVALID_XATTR |
-				NFS_INO_REVAL_PAGECACHE;
+				NFS_INO_INVALID_MODE | NFS_INO_INVALID_XATTR;
 		nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
 	}
 	nfsi->attrtimeo_timestamp = jiffies;

