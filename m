Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF8634415F
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhCVMdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhCVMcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD71E619A8;
        Mon, 22 Mar 2021 12:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416322;
        bh=FF+/HZal6UdekTFYU1FwbwMDwy1bNdTFtT35oxYa1yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wySULFtfFb4dp6W1xLdnNEWHDlyXn8jVnxMdZ3rYJaX6d4lGszEoPn3qVVilN+3ur
         lL+w3gMRUzkTU4GFrqehcypDSnOouaHWh2vQFsJxrGaxpyMyHQR6Bwm6VE03KxtN0/
         qW8X6xix2nIhiLJUFdOSEXgvhtSj0jkNvFniwFw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 5.11 061/120] cifs: fix allocation size on newly created files
Date:   Mon, 22 Mar 2021 13:27:24 +0100
Message-Id: <20210322121931.724084948@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 65af8f0166f4d15e61c63db498ec7981acdd897f upstream.

Applications that create and extend and write to a file do not
expect to see 0 allocation size.  When file is extended,
set its allocation size to a plausible value until we have a
chance to query the server for it.  When the file is cached
this will prevent showing an impossible number of allocated
blocks (like 0).  This fixes e.g. xfstests 614 which does

    1) create a file and set its size to 64K
    2) mmap write 64K to the file
    3) stat -c %b for the file (to query the number of allocated blocks)

It was failing because we returned 0 blocks.  Even though we would
return the correct cached file size, we returned an impossible
allocation size.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: <stable@vger.kernel.org>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/inode.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2383,7 +2383,7 @@ int cifs_getattr(const struct path *path
 	 * We need to be sure that all dirty pages are written and the server
 	 * has actual ctime, mtime and file length.
 	 */
-	if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE)) &&
+	if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE | STATX_BLOCKS)) &&
 	    !CIFS_CACHE_READ(CIFS_I(inode)) &&
 	    inode->i_mapping && inode->i_mapping->nrpages != 0) {
 		rc = filemap_fdatawait(inode->i_mapping);
@@ -2573,6 +2573,14 @@ set_size_out:
 	if (rc == 0) {
 		cifsInode->server_eof = attrs->ia_size;
 		cifs_setsize(inode, attrs->ia_size);
+		/*
+		 * i_blocks is not related to (i_size / i_blksize), but instead
+		 * 512 byte (2**9) size is required for calculating num blocks.
+		 * Until we can query the server for actual allocation size,
+		 * this is best estimate we have for blocks allocated for a file
+		 * Number of blocks must be rounded up so size 1 is not 0 blocks
+		 */
+		inode->i_blocks = (512 - 1 + attrs->ia_size) >> 9;
 
 		/*
 		 * The man page of truncate says if the size changed,


