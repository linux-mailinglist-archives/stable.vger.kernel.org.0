Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F2938A2B5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhETJo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233099AbhETJmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01710613E6;
        Thu, 20 May 2021 09:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503146;
        bh=qPrtqrM830SwP71pthpqXJRduOrWBDWXMnYl1rHV8T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngIEdqFIieiHhk6LOxFSqgRaS3dPJ0AQiwezk/206hIhjhH0VM5JHJFWS3q/ZBjY+
         FAEpbM9Q3Plga41YhuWmwS/DpalGwLa+6CgXuiRfvmyZeSCd5C3/ZlSOr2eXN7bfwr
         4CW9WFeWvNto8z4EwkYtTh+nNQAjq4tHsjxu72y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 089/425] NFSv4: Dont discard segments marked for return in _pnfs_return_layout()
Date:   Thu, 20 May 2021 11:17:38 +0200
Message-Id: <20210520092134.372020207@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -1294,7 +1294,7 @@ _pnfs_return_layout(struct inode *ino)
 	}
 	valid_layout = pnfs_layout_is_valid(lo);
 	pnfs_clear_layoutcommit(ino, &tmp_list);
-	pnfs_mark_matching_lsegs_invalid(lo, &tmp_list, NULL, 0);
+	pnfs_mark_matching_lsegs_return(lo, &tmp_list, NULL, 0);
 
 	if (NFS_SERVER(ino)->pnfs_curr_ld->return_range) {
 		struct pnfs_layout_range range = {


