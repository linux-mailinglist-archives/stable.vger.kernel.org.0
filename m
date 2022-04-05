Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBD94F2502
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiDEHoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiDEHoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:44:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D243995482;
        Tue,  5 Apr 2022 00:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A977B81B92;
        Tue,  5 Apr 2022 07:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51C8C340EE;
        Tue,  5 Apr 2022 07:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144437;
        bh=Fb4riB0jEURomykj+1J8g5qsThUapKp//UiRoyJN0MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXw9+tCks2dFhMp9GTqXiEq3P1IvbjaiiEy3Hc1nzLhm0pIh9kwiHXTx7eWWVmfXO
         zg7oSm/nCRQiC3JlHGU/XogHCp5IdrFH1GyZXMuTqTAD/2EQjTLEjO/W2vXD9edMsF
         GwPXybsRUPypZjAHON4p87lzWQbT3pZS0TSEGR2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoli Feng <xifeng@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 0043/1126] cifs: truncate the inode and mapping when we simulate fcollapse
Date:   Tue,  5 Apr 2022 09:13:10 +0200
Message-Id: <20220405070408.823275754@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 84330d41efb12bc227899e54dbdbe7d9590cb2b7 upstream.

RHBZ:1997367

When we collapse a range in smb3_collapse_range() we must make sure
we update the inode size and pagecache accordingly.

If not, both inode size and pagecahce may be stale until it is refreshed.

This can be demonstrated for the inode size by running :

xfs_io -i -f -c "truncate 320k" -c "fcollapse 64k 128k" -c "fiemap -v"  \
/mnt/testfile

where we can see the result of stale data in the fiemap output.
The third line of the output is wrong, all this data should be truncated.

 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        hole               128
   1: [128..383]:      128..383           256   0x1
   2: [384..639]:      hole               256

And the correct output, when the inode size has been updated correctly should
look like this:

 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        hole               128
   1: [128..383]:      128..383           256   0x1

Reported-by: Xiaoli Feng <xifeng@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -25,6 +25,7 @@
 #include "smb2glob.h"
 #include "cifs_ioctl.h"
 #include "smbdirect.h"
+#include "fscache.h"
 #include "fs_context.h"
 
 /* Change credits for different ops and return the total number of credits */
@@ -3887,29 +3888,38 @@ static long smb3_collapse_range(struct f
 {
 	int rc;
 	unsigned int xid;
+	struct inode *inode;
 	struct cifsFileInfo *cfile = file->private_data;
+	struct cifsInodeInfo *cifsi;
 	__le64 eof;
 
 	xid = get_xid();
 
-	if (off >= i_size_read(file->f_inode) ||
-	    off + len >= i_size_read(file->f_inode)) {
+	inode = d_inode(cfile->dentry);
+	cifsi = CIFS_I(inode);
+
+	if (off >= i_size_read(inode) ||
+	    off + len >= i_size_read(inode)) {
 		rc = -EINVAL;
 		goto out;
 	}
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
-				  i_size_read(file->f_inode) - off - len, off);
+				  i_size_read(inode) - off - len, off);
 	if (rc < 0)
 		goto out;
 
-	eof = cpu_to_le64(i_size_read(file->f_inode) - len);
+	eof = cpu_to_le64(i_size_read(inode) - len);
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, &eof);
 	if (rc < 0)
 		goto out;
 
 	rc = 0;
+
+	cifsi->server_eof = i_size_read(inode) - len;
+	truncate_setsize(inode, cifsi->server_eof);
+	fscache_resize_cookie(cifs_inode_cookie(inode), cifsi->server_eof);
  out:
 	free_xid(xid);
 	return rc;


