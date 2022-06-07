Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C5654253C
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382964AbiFHBPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843648AbiFHALR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:11:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D30119CB77;
        Tue,  7 Jun 2022 12:26:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 452D8B8237B;
        Tue,  7 Jun 2022 19:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06F9C385A5;
        Tue,  7 Jun 2022 19:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629971;
        bh=2b3EwAxT/IxY3yiIFVjw+wSEWXH1+Ouo/kRi/T0Wbxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cogw5YqoEGLYQmkzpPP4C1Fv2Fc3DI0mxUDFk+U436W4NkEku7/SxttcoNt2yANyp
         T33MUY2fzABT+Z7Op3h32kU8DdtMJi5j+ioonp4+qDgwvqhyyoR/OGPq1VWLqXJPmm
         E/39LJwRAnbWItLOO9QQH+su6+GZqtCZXf4ry3Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Hubsch <ohubsch@purestorage.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.18 854/879] SMB3: EBADF/EIO errors in rename/open caused by race condition in smb2_compound_op
Date:   Tue,  7 Jun 2022 19:06:12 +0200
Message-Id: <20220607165027.643252462@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Steve French <stfrench@microsoft.com>

commit 0a55cf74ffb5d004b93647e4389096880ce37d6b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -362,8 +362,6 @@ smb2_compound_op(const unsigned int xid,
 	num_rqst++;
 
 	if (cfile) {
-		cifsFileInfo_put(cfile);
-		cfile = NULL;
 		rc = compound_send_recv(xid, ses, server,
 					flags, num_rqst - 2,
 					&rqst[1], &resp_buftype[1],


