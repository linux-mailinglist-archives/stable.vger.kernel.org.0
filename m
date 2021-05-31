Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7F3395C4B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhEaNbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232417AbhEaN3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0516B613AE;
        Mon, 31 May 2021 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467347;
        bh=RDUw2FM5d0BRQokGv6ugR9c1N6TLM8/jFtX3rthnumw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zumopJsypfm0OH3aDwh0DBzDpBOdiiWs6H6XSDwDuX85R46xp86FQQaJmPcaJgG+y
         Ao6rW2pSx0rJKMZXD7c+9ZKqSa5ddM1N+dgWUtus1JwyMA9O6ih6JYj/ErBSNBjac5
         E5o//Yv6fKhMunOgONYU3maNMWaPqzsswIyADyUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 005/116] NFSv4: Fix a NULL pointer dereference in pnfs_mark_matching_lsegs_return()
Date:   Mon, 31 May 2021 15:13:01 +0200
Message-Id: <20210531130640.320489783@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
@@ -1268,6 +1268,11 @@ _pnfs_return_layout(struct inode *ino)
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
@@ -1294,16 +1299,10 @@ _pnfs_return_layout(struct inode *ino)
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


