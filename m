Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB04395FBC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhEaOQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233249AbhEaOMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:12:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C928613CB;
        Mon, 31 May 2021 13:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468500;
        bh=/SOqs7tI79XyTZ4L9Qld6vWOfhdLjxec5g19gpzLVY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lmv2PylxPp93yHO4pMXcyq7Tx9rPUrWe33ZrlxtzsoJEQDb1I0HSj+fXHua+loYTD
         zIs8CCoyFHjWEN/YGJzAa1k2n6JUFhSlSMyNWSazUF4GMhNQzmsLn/olyeWdqWqJm3
         MKawHkRQ4wRUg+0A/hrd0mt5aerw1ro4VJ8DRgjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 005/177] NFSv4: Fix a NULL pointer dereference in pnfs_mark_matching_lsegs_return()
Date:   Mon, 31 May 2021 15:12:42 +0200
Message-Id: <20210531130648.085132103@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

commit a421d218603ffa822a0b8045055c03eae394a7eb upstream.

Commit de144ff4234f changes _pnfs_return_layout() to call
pnfs_mark_matching_lsegs_return() passing NULL as the struct
pnfs_layout_range argument. Unfortunately,
pnfs_mark_matching_lsegs_return() doesn't check if we have a value here
before dereferencing it, causing an oops.

I'm able to hit this crash consistently when running connectathon basic
tests on NFS v4.1/v4.2 against Ontap.

Fixes: de144ff4234f ("NFSv4: Don't discard segments marked for return in _pnfs_return_layout()")
Cc: stable@vger.kernel.org
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1285,6 +1285,11 @@ _pnfs_return_layout(struct inode *ino)
 {
 	struct pnfs_layout_hdr *lo = NULL;
 	struct nfs_inode *nfsi = NFS_I(ino);
+	struct pnfs_layout_range range = {
+		.iomode		= IOMODE_ANY,
+		.offset		= 0,
+		.length		= NFS4_MAX_UINT64,
+	};
 	LIST_HEAD(tmp_list);
 	nfs4_stateid stateid;
 	int status = 0;
@@ -1311,16 +1316,10 @@ _pnfs_return_layout(struct inode *ino)
 	}
 	valid_layout = pnfs_layout_is_valid(lo);
 	pnfs_clear_layoutcommit(ino, &tmp_list);
-	pnfs_mark_matching_lsegs_return(lo, &tmp_list, NULL, 0);
+	pnfs_mark_matching_lsegs_return(lo, &tmp_list, &range, 0);
 
-	if (NFS_SERVER(ino)->pnfs_curr_ld->return_range) {
-		struct pnfs_layout_range range = {
-			.iomode		= IOMODE_ANY,
-			.offset		= 0,
-			.length		= NFS4_MAX_UINT64,
-		};
+	if (NFS_SERVER(ino)->pnfs_curr_ld->return_range)
 		NFS_SERVER(ino)->pnfs_curr_ld->return_range(lo, &range);
-	}
 
 	/* Don't send a LAYOUTRETURN if list was initially empty */
 	if (!test_bit(NFS_LAYOUT_RETURN_REQUESTED, &lo->plh_flags) ||


