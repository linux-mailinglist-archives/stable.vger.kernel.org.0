Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A1E461F72
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380056AbhK2SrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:47:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380283AbhK2SpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:45:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638211318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xOUYV3OJyreKxUkOiu6/UvSUlPL0Sw+qa3y1Q+BwT7U=;
        b=blbR3T32QgTfTHx3Gt0uqpCW/jCkGIw4FMIkE5RWbswjyxCbUdgMw8i0WnvtBQ/1R6kVD/
        fvm2f4c2gO/WZRnvq6yzkHMEtMGtVm8qPtijV/MPDty9GjGJzT5V7qVmAewxkkCXC5MH4G
        giZJ8TKvXS8ivQ6zL23VOuJQJ8HlCTM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-432-hNbLP9bfM6mqFIBSDQ_p_g-1; Mon, 29 Nov 2021 13:41:54 -0500
X-MC-Unique: hNbLP9bfM6mqFIBSDQ_p_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4FDF10168C6;
        Mon, 29 Nov 2021 18:41:53 +0000 (UTC)
Received: from bcodding.csb (ovpn-64-2.rdu2.redhat.com [10.10.64.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63C1376608;
        Mon, 29 Nov 2021 18:41:53 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id EA1B110C30E3; Mon, 29 Nov 2021 13:41:52 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     stable@vger.kernel.org
Cc:     trond.myklebust@hammerspace.com, bcodding@redhat.com,
        gregkh@linuxfoundation.org
Subject: [stable v4.9 PATCH] NFSv42: Fix pagecache invalidation after COPY/CLONE
Date:   Mon, 29 Nov 2021 13:41:50 -0500
Message-Id: <6e554517703f89c52ebd6dabebe34b64c7e0adbd.1638197926.git.bcodding@redhat.com>
In-Reply-To: <cover.1638210409.git.bcodding@redhat.com>
References: <cover.1638210409.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 3f015d89a47cd8855cd92f71fff770095bd885a1 backported for
stable v4.9:

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
index 7efb9e0e9f25..3038cefff15c 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -181,8 +181,9 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 			return status;
 	}
 
-	truncate_pagecache_range(dst_inode, pos_dst,
-				 pos_dst + res->write_res.count);
+	WARN_ON_ONCE(invalidate_inode_pages2_range(dst_inode->i_mapping,
+					pos_dst >> PAGE_SHIFT,
+					(pos_dst + res->write_res.count - 1) >> PAGE_SHIFT));
 
 	return res->write_res.count;
 }
-- 
2.31.1

