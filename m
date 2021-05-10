Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F085D3782DA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhEJKin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231167AbhEJKgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:36:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6D19613D6;
        Mon, 10 May 2021 10:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642560;
        bh=KIr7O11WsfUxdjcPN3lJ5XLBUJ+kJA01EzYdnn6q10k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KszBgt/QsvbdfsmXH4bzphKf0vtFceZ5DEfYn98Lz+b32gqza7+lyEBxAs8nE1iBh
         vDLWVmOcE/0BylvYPGora7wQC5YLgW/gq2GqQvXsgUVZI0AfVbL9bcxk3N7FfQq2iT
         vjGl8OU3zp/j/0xGYWtiG8uPmnYWrYaU5HgrN0IU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 144/184] NFS: Dont discard pNFS layout segments that are marked for return
Date:   Mon, 10 May 2021 12:20:38 +0200
Message-Id: <20210510101954.853737275@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 39fd01863616964f009599e50ca5c6ea9ebf88d6 upstream.

If the pNFS layout segment is marked with the NFS_LSEG_LAYOUTRETURN
flag, then the assumption is that it has some reporting requirement
to perform through a layoutreturn (e.g. flexfiles layout stats or error
information).

Fixes: e0b7d420f72a ("pNFS: Don't discard layout segments that are marked for return")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2427,6 +2427,9 @@ pnfs_mark_matching_lsegs_return(struct p
 
 	assert_spin_locked(&lo->plh_inode->i_lock);
 
+	if (test_bit(NFS_LAYOUT_RETURN_REQUESTED, &lo->plh_flags))
+		tmp_list = &lo->plh_return_segs;
+
 	list_for_each_entry_safe(lseg, next, &lo->plh_segs, pls_list)
 		if (pnfs_match_lseg_recall(lseg, return_range, seq)) {
 			dprintk("%s: marking lseg %p iomode %d "
@@ -2434,6 +2437,8 @@ pnfs_mark_matching_lsegs_return(struct p
 				lseg, lseg->pls_range.iomode,
 				lseg->pls_range.offset,
 				lseg->pls_range.length);
+			if (test_bit(NFS_LSEG_LAYOUTRETURN, &lseg->pls_flags))
+				tmp_list = &lo->plh_return_segs;
 			if (mark_lseg_invalid(lseg, tmp_list))
 				continue;
 			remaining++;


