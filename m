Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B1469B8B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355796AbhLFPRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48146 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346580AbhLFPPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:15:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC8A7B810AC;
        Mon,  6 Dec 2021 15:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186A4C341C1;
        Mon,  6 Dec 2021 15:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803482;
        bh=GCTKWypXTdlnMDCefqNAmhunxgQiu/ZvnAzpYcz5+Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3cHDqK3DV5FNdD3SSIz8AlDRoMkzimfQ11qiwhEV/OU4lRnI7uysLgtm5KjRpTpb
         RRu4PSU0hf293r3YoWbRqNGZAwO/AqNX3PGsfH5feXhvvtdSOzV0d9jCjuy4D4bihy
         N/APD4rKk3tj0K+5aNueN4PYrXhLXLZrlbylaH74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 01/70] NFSv42: Fix pagecache invalidation after COPY/CLONE
Date:   Mon,  6 Dec 2021 15:56:05 +0100
Message-Id: <20211206145551.962520706@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
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
@@ -295,8 +295,9 @@ static ssize_t _nfs42_proc_copy(struct f
 			goto out;
 	}
 
-	truncate_pagecache_range(dst_inode, pos_dst,
-				 pos_dst + res->write_res.count);
+	WARN_ON_ONCE(invalidate_inode_pages2_range(dst_inode->i_mapping,
+					pos_dst >> PAGE_SHIFT,
+					(pos_dst + res->write_res.count - 1) >> PAGE_SHIFT));
 
 	status = res->write_res.count;
 out:


