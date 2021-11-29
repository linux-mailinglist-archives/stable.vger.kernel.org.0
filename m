Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D617C461F70
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380021AbhK2SrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:47:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380274AbhK2SpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:45:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638211317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zUGKz/dbsMjarGkns4tlHgKVtHDYIAONQ/Y4yCPPaw8=;
        b=cX22QdrdGFQctb0uM6EQJCK7vrOsMMYta9RRQV331BE8APNaP9bxYrHf0m4wA5qM4s4oQz
        XQmSJyeeKY8ISBcB9svzIJldX+Q0JMOcpDkYFmErgyMdp8fNTKRKw0JSOFYN0IaKy3fYhD
        jFgJgWHws2S5xPIHM0QfcBEDsLp6PEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-eVGB3adtOOqeAW_JO21zXw-1; Mon, 29 Nov 2021 13:41:54 -0500
X-MC-Unique: eVGB3adtOOqeAW_JO21zXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93D1E100C610;
        Mon, 29 Nov 2021 18:41:53 +0000 (UTC)
Received: from bcodding.csb (ovpn-64-2.rdu2.redhat.com [10.10.64.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63A3E5C25A;
        Mon, 29 Nov 2021 18:41:53 +0000 (UTC)
Received: by bcodding.csb (Postfix, from userid 24008)
        id E580510C30E2; Mon, 29 Nov 2021 13:41:52 -0500 (EST)
From:   Benjamin Coddington <bcodding@redhat.com>
To:     stable@vger.kernel.org
Cc:     trond.myklebust@hammerspace.com, bcodding@redhat.com,
        gregkh@linuxfoundation.org
Subject: [stable v4.19 PATCH] NFSv42: Fix pagecache invalidation after COPY/CLONE
Date:   Mon, 29 Nov 2021 13:41:49 -0500
Message-Id: <ddba87366317b681d61d1012c277e161fb15fd0b.1638199121.git.bcodding@redhat.com>
In-Reply-To: <cover.1638210409.git.bcodding@redhat.com>
References: <cover.1638210409.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 3f015d89a47cd8855cd92f71fff770095bd885a1 backported for
stable v4.19:

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
index be252795a6f7..5b1d452e640b 100644
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

