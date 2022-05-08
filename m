Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9857A51EBF8
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 08:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiEHGYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 02:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiEHGXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 02:23:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B4C86371
        for <stable@vger.kernel.org>; Sat,  7 May 2022 23:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651990793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dU0ujdtuKzywLIsvaDwObpfK1zPzM1Ro1a56/7/IOQ0=;
        b=KuNy+TbG2vjPHif2D1pCdEgyNkztF9Nqjdy/J/d7AeFZIjffkhEC4WY02S/rYiJnyHkEZQ
        uC1LW0zGwXfU2s0pO1tocTVewl/XMjTr108L6XySDwGvSwBvXSrjpS+RcYmF6GTeHu0ww3
        otXohyWL7/dWCaCs4WIO5zS/p1vgqvg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-oe72E_xSP6mqvH-mbGjSxQ-1; Sun, 08 May 2022 02:19:48 -0400
X-MC-Unique: oe72E_xSP6mqvH-mbGjSxQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C691D294EDEC;
        Sun,  8 May 2022 06:19:47 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 405DF20292B3;
        Sun,  8 May 2022 06:19:44 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     lhenriques@suse.de, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] ceph: check folio PG_private bit instead of folio->private
Date:   Sun,  8 May 2022 14:15:43 +0800
Message-Id: <20220508061543.318394-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pages in the file mapping maybe reclaimed and reused by other
subsystems and the page->private maybe used as flags field or
something else, if later that pages are used by page caches again
the page->private maybe not cleared as expected.

Here will check the PG_private bit instead of the folio->private.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/55421
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 63b7430e1ce6..1a108f24e7d9 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -85,7 +85,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 	if (folio_test_dirty(folio)) {
 		dout("%p dirty_folio %p idx %lu -- already dirty\n",
 		     mapping->host, folio, folio->index);
-		VM_BUG_ON_FOLIO(!folio_get_private(folio), folio);
+		VM_BUG_ON_FOLIO(!folio_test_private(folio), folio);
 		return false;
 	}
 
@@ -122,7 +122,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 	 * Reference snap context in folio->private.  Also set
 	 * PagePrivate so that we get invalidate_folio callback.
 	 */
-	VM_BUG_ON_FOLIO(folio_get_private(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_private(folio), folio);
 	folio_attach_private(folio, snapc);
 
 	return ceph_fscache_dirty_folio(mapping, folio);
@@ -150,7 +150,7 @@ static void ceph_invalidate_folio(struct folio *folio, size_t offset,
 	}
 
 	WARN_ON(!folio_test_locked(folio));
-	if (folio_get_private(folio)) {
+	if (folio_test_private(folio)) {
 		dout("%p invalidate_folio idx %lu full dirty page\n",
 		     inode, folio->index);
 
-- 
2.36.0.rc1

