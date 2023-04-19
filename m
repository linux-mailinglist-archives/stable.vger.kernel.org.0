Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69446E72F1
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 08:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjDSGPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 02:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjDSGPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 02:15:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0441BFD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 23:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681884864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lVLlLs6owwM+smJqvLGA4DynELYRix6Hq9EubDjqKNU=;
        b=a4Oni5e01jrmtsFPDmg/z87FdoW4BVbTaOswSWJkPs8qesVBhAv42TIVtaZ8re7p09a3qt
        +AmRD47ElbFQKzcJOn0dtZh0lXjcs9TP204umCsiXIysVMOcrxU9Q6xoLhUZ34wA733Pg9
        FYgHMnRU8NI5upS8o6NPt6Am4sqQvZA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-WSAzrgmwM-SDKZjOOhqpCg-1; Wed, 19 Apr 2023 02:14:20 -0400
X-MC-Unique: WSAzrgmwM-SDKZjOOhqpCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D695085A5B1;
        Wed, 19 Apr 2023 06:14:19 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-234.pek2.redhat.com [10.72.12.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBDFDC16024;
        Wed, 19 Apr 2023 06:14:15 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v4 1/2] ceph: export __get_cap_for_mds() helper
Date:   Wed, 19 Apr 2023 14:14:01 +0800
Message-Id: <20230419061402.183915-2-xiubli@redhat.com>
In-Reply-To: <20230419061402.183915-1-xiubli@redhat.com>
References: <20230419061402.183915-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This is one helper without the ci->i_ceph_lock and will be used
in another file.

Cc: stable@vger.kernel.org
URL: https://bugzilla.redhat.com/show_bug.cgi?id=2186264
URL: https://tracker.ceph.com/issues/43272
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c  | 2 +-
 fs/ceph/super.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index cf29e395af23..2732f46532ec 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -432,7 +432,7 @@ void ceph_reservation_status(struct ceph_fs_client *fsc,
  *
  * Called with i_ceph_lock held.
  */
-static struct ceph_cap *__get_cap_for_mds(struct ceph_inode_info *ci, int mds)
+struct ceph_cap *__get_cap_for_mds(struct ceph_inode_info *ci, int mds)
 {
 	struct ceph_cap *cap;
 	struct rb_node *n = ci->i_caps.rb_node;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a5e84f8b67ba..a226d36b3ecb 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1225,6 +1225,8 @@ extern void ceph_kick_flushing_caps(struct ceph_mds_client *mdsc,
 				    struct ceph_mds_session *session);
 void ceph_kick_flushing_inode_caps(struct ceph_mds_session *session,
 				   struct ceph_inode_info *ci);
+extern struct ceph_cap *__get_cap_for_mds(struct ceph_inode_info *ci,
+					  int mds);
 extern struct ceph_cap *ceph_get_cap_for_mds(struct ceph_inode_info *ci,
 					     int mds);
 extern void ceph_take_cap_refs(struct ceph_inode_info *ci, int caps,
-- 
2.39.2

