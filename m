Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC97138A87B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbhETKvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238014AbhETKs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:48:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDE606141D;
        Thu, 20 May 2021 09:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504723;
        bh=TdqnW6tppbjS5iPvbuOsdbm4sZAxcDxsTGeuTpgehFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvk6sCpDnaiRdbJt5t/2+Rb73T9taZXTbL/Qf3QSpms0ORIQgq732cD+pyoW8Sx7W
         HZ2xisSk52HTpjH3Y2mWNInx60LGYHZNIELRsoVq06x+sb2/9J1CtffN/4B+k7IJ4p
         tuMcjex44nyFpHQg1vIN3rnpyqxiLWzoMcRbZC5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.9 052/240] NFSv4: Dont discard segments marked for return in _pnfs_return_layout()
Date:   Thu, 20 May 2021 11:20:44 +0200
Message-Id: <20210520092110.420550292@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
@@ -1088,7 +1088,7 @@ _pnfs_return_layout(struct inode *ino)
 	pnfs_get_layout_hdr(lo);
 	empty = list_empty(&lo->plh_segs);
 	pnfs_clear_layoutcommit(ino, &tmp_list);
-	pnfs_mark_matching_lsegs_invalid(lo, &tmp_list, NULL, 0);
+	pnfs_mark_matching_lsegs_return(lo, &tmp_list, NULL, 0);
 
 	if (NFS_SERVER(ino)->pnfs_curr_ld->return_range) {
 		struct pnfs_layout_range range = {


