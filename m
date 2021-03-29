Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDCA34CAEF
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhC2IlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234876AbhC2IkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:40:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6AA86196F;
        Mon, 29 Mar 2021 08:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007212;
        bh=bci7wk62osNSTcvyTI2U5/vnoKVCJPeho2zCeMLj6EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kntbTT/3Lpa6Vd9MCCFokhd/mO8vGT+enRVB/IrntmWU75VbqmL0BJfUEMtsrnsTH
         kLC5U4+4X4Wsh0K1Y1tc74p9i+4c4RFkYp19Vhb9d2O43362EMKolglhVLSTcMOdcB
         58G0WxMtDuq5/nFAY+9jZKRMnAFZNHYeeH51P+Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 239/254] smb3: fix cached file size problems in duplicate extents (reflink)
Date:   Mon, 29 Mar 2021 09:59:15 +0200
Message-Id: <20210329075640.930112647@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit cfc63fc8126a93cbf95379bc4cad79a7b15b6ece upstream.

There were two problems (one of which could cause data corruption)
that were noticed with duplicate extents (ie reflink)
when debugging why various xfstests were being incorrectly skipped
(e.g. generic/138, generic/140, generic/142). First, we were not
updating the file size locally in the cache when extending a
file due to reflink (it would refresh after actimeo expires)
but xfstest was checking the size immediately which was still
0 so caused the test to be skipped.  Second, we were setting
the target file size (which could shrink the file) in all cases
to the end of the reflinked range rather than only setting the
target file size when reflink would extend the file.

CC: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2007,6 +2007,7 @@ smb2_duplicate_extents(const unsigned in
 {
 	int rc;
 	unsigned int ret_data_len;
+	struct inode *inode;
 	struct duplicate_extents_to_file dup_ext_buf;
 	struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
 
@@ -2023,10 +2024,21 @@ smb2_duplicate_extents(const unsigned in
 	cifs_dbg(FYI, "Duplicate extents: src off %lld dst off %lld len %lld\n",
 		src_off, dest_off, len);
 
-	rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
-	if (rc)
-		goto duplicate_extents_out;
+	inode = d_inode(trgtfile->dentry);
+	if (inode->i_size < dest_off + len) {
+		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
+		if (rc)
+			goto duplicate_extents_out;
 
+		/*
+		 * Although also could set plausible allocation size (i_blocks)
+		 * here in addition to setting the file size, in reflink
+		 * it is likely that the target file is sparse. Its allocation
+		 * size will be queried on next revalidate, but it is important
+		 * to make sure that file's cached size is updated immediately
+		 */
+		cifs_setsize(inode, dest_off + len);
+	}
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
 			FSCTL_DUPLICATE_EXTENTS_TO_FILE,


