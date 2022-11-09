Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614DB622261
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 04:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiKIDBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 22:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIDBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 22:01:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976BD183BA
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 19:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667962849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iMy2VOMTEAboRQxRApFuvkjsadfTfOePpBuBK15hGg0=;
        b=U3Fp556CppIaFADHFKnxZlMwKTdrY/nPjOBBWeKIE65eOKxQEbvAd/iZOZumM+JYjPd0tw
        J/iJ/Ib0N6+0ZKsFfWdJvYFm31xnSHH1hqJqTAab9dYa5KvUd3ljes3gGAWbH0+94znv1T
        RRXA3KpitXD2Ec7l7mG5LTQDiOCq9nc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-_UzcJp9kO5-PxrfWW6S9cA-1; Tue, 08 Nov 2022 22:00:46 -0500
X-MC-Unique: _UzcJp9kO5-PxrfWW6S9cA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A263185A79C;
        Wed,  9 Nov 2022 03:00:46 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3600940C2086;
        Wed,  9 Nov 2022 03:00:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, jlayton@kernel.org, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v4] ceph: avoid putting the realm twice when decoding snaps fails
Date:   Wed,  9 Nov 2022 11:00:39 +0800
Message-Id: <20221109030039.592830-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When decoding the snaps fails it maybe leaving the 'first_realm'
and 'realm' pointing to the same snaprealm memory. And then it'll
put it twice and could cause random use-after-free, BUG_ON, etc
issues.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/57686
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V4:
- remove initilizing of 'realm'.

 fs/ceph/snap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 9bceed2ebda3..c1c452afa84d 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -764,7 +764,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_mds_snap_realm *ri;    /* encoded */
 	__le64 *snaps;                     /* encoded */
 	__le64 *prior_parent_snaps;        /* encoded */
-	struct ceph_snap_realm *realm = NULL;
+	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
 	int rebuild_snapcs;
@@ -775,6 +775,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("%s deletion=%d\n", __func__, deletion);
 more:
+	realm = NULL;
 	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
-- 
2.31.1

