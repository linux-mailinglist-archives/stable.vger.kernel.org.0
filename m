Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A783786B2
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbhEJLKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234298AbhEJLCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:02:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1CED61285;
        Mon, 10 May 2021 10:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644051;
        bh=Z3l4YmwAXxTeVKaGMy/bTcNl0d4GDdy4twdeXag1rbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrqAGIkGGs39MN/oj88goHIYJJvI9kMYqqlJl2Ysu+3JPQ3dJHAytgkdxqu2ZHR8H
         0slP9Cc6ICklL5oBEeE3aosqy7oYiCRjSUtD+0CdaQf5KcQ/aTDx7IgbTXwkaSzUOw
         F9ZeEHCv8U8wIRJWWORR94eJe030pGXZfcGKr4KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.11 267/342] NFSv4: Dont discard segments marked for return in _pnfs_return_layout()
Date:   Mon, 10 May 2021 12:20:57 +0200
Message-Id: <20210510102018.921897282@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit de144ff4234f935bd2150108019b5d87a90a8a96 upstream.

If the pNFS layout segment is marked with the NFS_LSEG_LAYOUTRETURN
flag, then the assumption is that it has some reporting requirement
to perform through a layoutreturn (e.g. flexfiles layout stats or error
information).

Fixes: 6d597e175012 ("pnfs: only tear down lsegs that precede seqid in LAYOUTRETURN args")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1344,7 +1344,7 @@ _pnfs_return_layout(struct inode *ino)
 	}
 	valid_layout = pnfs_layout_is_valid(lo);
 	pnfs_clear_layoutcommit(ino, &tmp_list);
-	pnfs_mark_matching_lsegs_invalid(lo, &tmp_list, NULL, 0);
+	pnfs_mark_matching_lsegs_return(lo, &tmp_list, NULL, 0);
 
 	if (NFS_SERVER(ino)->pnfs_curr_ld->return_range) {
 		struct pnfs_layout_range range = {


