Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1F6469C1F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347392AbhLFPVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37064 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356289AbhLFPSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:18:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AC2261321;
        Mon,  6 Dec 2021 15:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9FDC341C1;
        Mon,  6 Dec 2021 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803680;
        bh=KJK+qrbW/zwznq+7KmZ9IMfLCgwU/HKvt/dl4fTuPF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2U3bincKhoUbstdNV03RCbF/l/kU8m5v8JDBdrxyzM1YfFEzmtuy8u5M4ZFduNvFy
         x5Ry9PSrkxYev1RpKlMVx/leb14JvPrVVX8bE+0PRkZrabsT0Z7SPZtmcxiiGEmjP6
         NNrW/p5bEwLkujXdPA8KTMbaH34Ct1Vke+3+LmTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 001/130] NFSv42: Fix pagecache invalidation after COPY/CLONE
Date:   Mon,  6 Dec 2021 15:55:18 +0100
Message-Id: <20211206145559.664593607@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

commit 3f015d89a47cd8855cd92f71fff770095bd885a1 upstream.

The mechanism in use to allow the client to see the results of COPY/CLONE
is to drop those pages from the pagecache.  This forces the client to read
those pages once more from the server.  However, truncate_pagecache_range()
zeros out partial pages instead of dropping them.  Let us instead use
invalidate_inode_pages2_range() with full-page offsets to ensure the client
properly sees the results of COPY/CLONE operations.

Cc: <stable@vger.kernel.org> # v4.7+
Fixes: 2e72448b07dc ("NFS: Add COPY nfs operation")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs42proc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -362,8 +362,9 @@ static ssize_t _nfs42_proc_copy(struct f
 			goto out;
 	}
 
-	truncate_pagecache_range(dst_inode, pos_dst,
-				 pos_dst + res->write_res.count);
+	WARN_ON_ONCE(invalidate_inode_pages2_range(dst_inode->i_mapping,
+					pos_dst >> PAGE_SHIFT,
+					(pos_dst + res->write_res.count - 1) >> PAGE_SHIFT));
 	spin_lock(&dst_inode->i_lock);
 	NFS_I(dst_inode)->cache_validity |= (NFS_INO_REVAL_PAGECACHE |
 			NFS_INO_REVAL_FORCED | NFS_INO_INVALID_SIZE |


