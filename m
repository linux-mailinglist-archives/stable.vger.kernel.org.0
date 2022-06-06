Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D5753E7AC
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241035AbiFFPm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 11:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbiFFPm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 11:42:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9E629376
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 08:42:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4761B61587
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 15:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53225C385A9;
        Mon,  6 Jun 2022 15:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654530144;
        bh=NSgaGjEvswgy5NUF9jfGFUZCRfG+JPQYx/kL8Qia9Kg=;
        h=Subject:To:Cc:From:Date:From;
        b=fBDsxTZ0payIyhyqT9BGsfRhTTpODFvnyqTPUQ8YrnIunqaUgQFPiAHK4hBz9bgOT
         KitSOLf5VdXHkvy4ghFyGULCQnkc1JoP5fCFrYGyvHqvrqU0tHj7tDwBzOle+b0f3F
         LwG3k8p4pn1NtegDWRNzopHV2N8i0qLbeIYStt2Q=
Subject: FAILED: patch "[PATCH] SMB3: EBADF/EIO errors in rename/open caused by race" failed to apply to 5.4-stable tree
To:     stfrench@microsoft.com, lsahlber@redhat.com,
        ohubsch@purestorage.com, pc@cjr.nz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 17:42:17 +0200
Message-ID: <1654530137241245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0a55cf74ffb5d004b93647e4389096880ce37d6b Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Thu, 12 May 2022 10:18:00 -0500
Subject: [PATCH] SMB3: EBADF/EIO errors in rename/open caused by race
 condition in smb2_compound_op
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There is  a race condition in smb2_compound_op:

after_close:
	num_rqst++;

	if (cfile) {
		cifsFileInfo_put(cfile); // sends SMB2_CLOSE to the server
		cfile = NULL;

This is triggered by smb2_query_path_info operation that happens during
revalidate_dentry. In smb2_query_path_info, get_readable_path is called to
load the cfile, increasing the reference counter. If in the meantime, this
reference becomes the very last, this call to cifsFileInfo_put(cfile) will
trigger a SMB2_CLOSE request sent to the server just before sending this compound
request – and so then the compound request fails either with EBADF/EIO depending
on the timing at the server, because the handle is already closed.

In the first scenario, the race seems to be happening between smb2_query_path_info
triggered by the rename operation, and between “cleanup” of asynchronous writes – while
fsync(fd) likely waits for the asynchronous writes to complete, releasing the writeback
structures can happen after the close(fd) call. So the EBADF/EIO errors will pop up if
the timing is such that:
1) There are still outstanding references after close(fd) in the writeback structures
2) smb2_query_path_info successfully fetches the cfile, increasing the refcounter by 1
3) All writeback structures release the same cfile, reducing refcounter to 1
4) smb2_compound_op is called with that cfile

In the second scenario, the race seems to be similar – here open triggers the
smb2_query_path_info operation, and if all other threads in the meantime decrease the
refcounter to 1 similarly to the first scenario, again SMB2_CLOSE will be sent to the
server just before issuing the compound request. This case is harder to reproduce.

See https://bugzilla.samba.org/show_bug.cgi?id=15051

Cc: stable@vger.kernel.org
Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")
Signed-off-by: Ondrej Hubsch <ohubsch@purestorage.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index fe5bfa245fa7..1b89b9b8a212 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -362,8 +362,6 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	num_rqst++;
 
 	if (cfile) {
-		cifsFileInfo_put(cfile);
-		cfile = NULL;
 		rc = compound_send_recv(xid, ses, server,
 					flags, num_rqst - 2,
 					&rqst[1], &resp_buftype[1],

