Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF90469BBD
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345297AbhLFPSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358704AbhLFPQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:16:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AE6C08EC8B;
        Mon,  6 Dec 2021 07:09:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E988961328;
        Mon,  6 Dec 2021 15:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBD3C341C2;
        Mon,  6 Dec 2021 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803373;
        bh=GCTKWypXTdlnMDCefqNAmhunxgQiu/ZvnAzpYcz5+Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsJIvK3L6RKX0kbQeohA4lkSD274ggBPfvC1KX55ILNfP7X2OaeMMsVCUiQ3CXVfu
         w8XpejGMNo9cPxAL/cxbv7BtNOvfEI3DPteOFay/gz/InHWUg+FVTsSH7aswBvFAv0
         W54eqZq/o9FCk8jesEqz9n2noy0Vov8IclwXvur8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 02/48] NFSv42: Fix pagecache invalidation after COPY/CLONE
Date:   Mon,  6 Dec 2021 15:56:19 +0100
Message-Id: <20211206145548.941941299@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
User-Agent: quilt/0.66
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


