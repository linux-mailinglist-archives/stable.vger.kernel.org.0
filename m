Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF0E527F4B
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241507AbiEPIJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 04:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241513AbiEPIJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:09:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F8333EBE
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:09:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BCAB6117F
        for <stable@vger.kernel.org>; Mon, 16 May 2022 08:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA7AC385AA;
        Mon, 16 May 2022 08:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652688573;
        bh=HUJlax3I94G3mFZJNjF98Kil/obOAS92xTJzF+spP2Q=;
        h=Subject:To:Cc:From:Date:From;
        b=UWhs21uH1MTGHIxZXHsVD34tAY8q0sZrUCaPegC5JgYVWZ2onDwFeihWSTWkCHZLe
         1QHDhE+a92k/dGHttBHsbicbTVCT+O7KCSWZmwuOGmvmczDc0u6y6BVbtqaYE2+KYY
         qPdqglRvVbn3z7oyX3vsd7VID0C4xolnT1nGNiB8=
Subject: FAILED: patch "[PATCH] ceph: check folio PG_private bit instead of folio->private" failed to apply to 5.15-stable tree
To:     xiubli@redhat.com, idryomov@gmail.com, jlayton@kernel.org,
        lhenriques@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 10:09:23 +0200
Message-ID: <165268856361116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 642d51fb0775a41dd6bb3d99b5a40c24df131c20 Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 5 May 2022 18:53:09 +0800
Subject: [PATCH] ceph: check folio PG_private bit instead of folio->private

The pages in the file mapping maybe reclaimed and reused by other
subsystems and the page->private maybe used as flags field or
something else, if later that pages are used by page caches again
the page->private maybe not cleared as expected.

Here will check the PG_private bit instead of the folio->private.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/55421
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Luis Henriques <lhenriques@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index aa25bffd4823..b6edcf89a429 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -85,7 +85,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 	if (folio_test_dirty(folio)) {
 		dout("%p dirty_folio %p idx %lu -- already dirty\n",
 		     mapping->host, folio, folio->index);
-		BUG_ON(!folio_get_private(folio));
+		VM_BUG_ON_FOLIO(!folio_test_private(folio), folio);
 		return false;
 	}
 
@@ -122,7 +122,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 	 * Reference snap context in folio->private.  Also set
 	 * PagePrivate so that we get invalidate_folio callback.
 	 */
-	BUG_ON(folio_get_private(folio));
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
 
@@ -729,8 +729,11 @@ static void writepages_finish(struct ceph_osd_request *req)
 
 	/* clean all pages */
 	for (i = 0; i < req->r_num_ops; i++) {
-		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE)
+		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE) {
+			pr_warn("%s incorrect op %d req %p index %d tid %llu\n",
+				__func__, req->r_ops[i].op, req, i, req->r_tid);
 			break;
+		}
 
 		osd_data = osd_req_op_extent_osd_data(req, i);
 		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);

