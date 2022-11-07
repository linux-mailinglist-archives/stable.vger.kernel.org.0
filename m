Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6BC61EBA0
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 08:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiKGHT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 02:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiKGHTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 02:19:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2624D13DF9
        for <stable@vger.kernel.org>; Sun,  6 Nov 2022 23:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667805489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s+w0fO2uJS5g4Y2JV2Wd+lHprC4XyOvlQlEJADBSY5k=;
        b=W5QJUiDxwi0pAVCzBqHdpvXtnSCdSFb4od1Zv2RMk9LslJo5aPwu4lIGDGDOVluT4oSEKJ
        uypTIlnEFN1EtZZoxxVe52bPIoPqrjXa4P+7j0S69OOjrLy0YVvPLWy1rNiIKKvg/6UIQV
        GMIfrqLyaET1fKRuLa2AMZ5fOE1imlQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-l0PR7UuJPiSQhVZG7b_u8A-1; Mon, 07 Nov 2022 02:18:06 -0500
X-MC-Unique: l0PR7UuJPiSQhVZG7b_u8A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97503806013;
        Mon,  7 Nov 2022 07:18:05 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EE28492B05;
        Mon,  7 Nov 2022 07:18:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, jlayton@kernel.org, mchangir@redhat.com,
        idryomov@gmail.com, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] ceph: avoid putting the realm twice when docoding snaps fails
Date:   Mon,  7 Nov 2022 15:17:59 +0800
Message-Id: <20221107071759.32000-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
 fs/ceph/snap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 9bceed2ebda3..baf17df05107 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -849,10 +849,12 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	if (realm_to_rebuild && p >= e)
 		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
 
-	if (!first_realm)
+	if (!first_realm) {
 		first_realm = realm;
-	else
+		realm = NULL;
+	} else {
 		ceph_put_snap_realm(mdsc, realm);
+	}
 
 	if (p < e)
 		goto more;
-- 
2.31.1

