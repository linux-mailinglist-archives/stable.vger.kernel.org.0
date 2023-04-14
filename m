Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB286E1A66
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 04:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjDNCmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 22:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDNCmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 22:42:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1D0CD
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 19:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681440098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=y6ditWs4JzErEXvsdo9zUGkxKuaELZkB/oSNNnzgxms=;
        b=VJuAADu7aIS46Nce+k/T5eobtiyGKyz71zJSDFqnq1N4gvhrikF2fKLm07KuH7h25/05dw
        4gMVfrsYZxqCgrrdRuwm+nJsTzPm0psXVtTpIXhivthAnZofszJCn/1onF1GUP3gDaxDui
        z7twRDwIRknqLloFWd7SWGSGDyWK1uI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-J54qgVVEMhq3l1xXlTX4iw-1; Thu, 13 Apr 2023 22:41:36 -0400
X-MC-Unique: J54qgVVEMhq3l1xXlTX4iw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ABF78996E3;
        Fri, 14 Apr 2023 02:41:36 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-157.pek2.redhat.com [10.72.12.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88438405DBB6;
        Fri, 14 Apr 2023 02:41:30 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ceph: do not touch cap when trimming the caps
Date:   Fri, 14 Apr 2023 10:41:23 +0800
Message-Id: <20230414024123.263120-1-xiubli@redhat.com>
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

When trimming the caps it maybe queued to release in the next loop,
and just after the 'session->s_cap_lock' lock is released the
'session->s_cap_iterator' will be set to NULL and the cap also has
been removed from 'session->s_caps' list, then the '__touch_cap()'
could continue and add the cap back to the 'session->s_caps' list.

That means this cap could be iterated twice to call 'trim_caps_cb()'
and the second time will trigger use-after-free bug.

Cc: stable@vger.kernel.org
URL: https://bugzilla.redhat.com/show_bug.cgi?id=2186264
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index cf29e395af23..186c9818ab0d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -846,7 +846,7 @@ static void __touch_cap(struct ceph_cap *cap)
 	struct ceph_mds_session *s = cap->session;
 
 	spin_lock(&s->s_cap_lock);
-	if (!s->s_cap_iterator) {
+	if (!s->s_cap_iterator && !list_empty(&cap->session_caps) && !cap->queue_release) {
 		dout("__touch_cap %p cap %p mds%d\n", &cap->ci->netfs.inode, cap,
 		     s->s_mds);
 		list_move_tail(&cap->session_caps, &s->s_caps);
-- 
2.39.1

