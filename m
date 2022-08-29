Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8445A43F2
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiH2Hlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiH2Hlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:41:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970D04BD36
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3D6FCE0DF9
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD069C433D6;
        Mon, 29 Aug 2022 07:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661758890;
        bh=g73dGz+YYqEt/TzOPlmiT8aCzAf10dFZA32d5PJ8fJ4=;
        h=Subject:To:Cc:From:Date:From;
        b=pVKS8nbajik0kKsgvpB+lNva5GyhI41METgn6yeMuB8kZfV6K0Z+v9cGnEoWuotav
         g1nTnDOvaChwZZ4RJCQHbEoavZLKeMoNDv+u3lb3HmPrlLVhhnTr2YsywkBZhj+Bp7
         Wm26CW8FcV2iAQCEvYQ3R521UUMsRPYEEPBFabys=
Subject: FAILED: patch "[PATCH] smb3: missing inode locks in punch hole" failed to apply to 4.19-stable tree
To:     dhowells@redhat.com, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:41:19 +0200
Message-ID: <1661758879193182@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ba0803050d610d5072666be727bca5e03e55b242 Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Tue, 23 Aug 2022 02:10:56 -0500
Subject: [PATCH] smb3: missing inode locks in punch hole

smb3 fallocate punch hole was not grabbing the inode or filemap_invalidate
locks so could have race with pagemap reinstantiating the page.

Cc: stable@vger.kernel.org
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a6fe54281fd3..4810bd62266a 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3384,7 +3384,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len)
 {
-	struct inode *inode;
+	struct inode *inode = file_inode(file);
 	struct cifsFileInfo *cfile = file->private_data;
 	struct file_zero_data_information fsctl_buf;
 	long rc;
@@ -3393,14 +3393,12 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 
 	xid = get_xid();
 
-	inode = d_inode(cfile->dentry);
-
+	inode_lock(inode);
 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */
 	if (!smb2_set_sparse(xid, tcon, cfile, inode, set_sparse)) {
 		rc = -EOPNOTSUPP;
-		free_xid(xid);
-		return rc;
+		goto out;
 	}
 
 	filemap_invalidate_lock(inode->i_mapping);
@@ -3420,8 +3418,10 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			(char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			CIFSMaxBufSize, NULL, NULL);
-	free_xid(xid);
 	filemap_invalidate_unlock(inode->i_mapping);
+out:
+	inode_unlock(inode);
+	free_xid(xid);
 	return rc;
 }
 

