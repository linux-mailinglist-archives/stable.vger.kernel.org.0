Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6A8461F6E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379894AbhK2SrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:47:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380260AbhK2SpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:45:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638211316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TqPlmIbeYxXgT8z9Hzs+go+yFxxk0JKHIMGlOJZAJAU=;
        b=PTzNChLqAvxwvXDCkhOyGOQx5YsrZJh2BCZTj4HatlZvtR2khcDgcmIod7RlqXRtSQrAN7
        scHmJKsFzylSkRl9A/a39O8mV4JoybpcJB2mijoyaEAlcbGKmmyRY4e99Hc3dM4kqFNI0H
        +sd7HOr6NYlefBphvC5NTsHH/TsbIBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-bO8Fy9Q3MxW13P37xY13_w-1; Mon, 29 Nov 2021 13:41:55 -0500
X-MC-Unique: bO8Fy9Q3MxW13P37xY13_w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 200A92D0;
        Mon, 29 Nov 2021 18:41:54 +0000 (UTC)
Received: from bcodding.csb (ovpn-64-2.rdu2.redhat.com [10.10.64.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E41735D9C0;
        Mon, 29 Nov 2021 18:41:53 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id F14C510C30EF; Mon, 29 Nov 2021 13:41:52 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     stable@vger.kernel.org
Cc:     trond.myklebust@hammerspace.com, bcodding@redhat.com,
        gregkh@linuxfoundation.org
Subject: [stable v5.4 PATCH] NFSv42: Fix pagecache invalidation after COPY/CLONE
Date:   Mon, 29 Nov 2021 13:41:52 -0500
Message-Id: <f4da02d72d4c39baf8158388e163df1e30835a25.1638206774.git.bcodding@redhat.com>
In-Reply-To: <cover.1638210409.git.bcodding@redhat.com>
References: <cover.1638210409.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 3f015d89a47cd8855cd92f71fff770095bd885a1 backported for
stable v5.4:

8<----------------------------------------------------------------------

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
---
 fs/nfs/nfs42proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 6b7c926824ae..504812ea4bc2 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -295,8 +295,9 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 			goto out;
 	}
 
-	truncate_pagecache_range(dst_inode, pos_dst,
-				 pos_dst + res->write_res.count);
+	WARN_ON_ONCE(invalidate_inode_pages2_range(dst_inode->i_mapping,
+					pos_dst >> PAGE_SHIFT,
+					(pos_dst + res->write_res.count - 1) >> PAGE_SHIFT));
 
 	status = res->write_res.count;
 out:
-- 
2.31.1

