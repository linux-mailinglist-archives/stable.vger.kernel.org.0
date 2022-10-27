Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D5E60F369
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 11:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbiJ0JOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 05:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbiJ0JN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 05:13:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1AD17536D
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 02:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666861949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d+rjS0j05vTqI0dJSY//TM0y/4hA85+tG5tCbw0SkVo=;
        b=gzjULxE2pt7EApM2JGxFVhrVv+56OzrIPyINximS2qn8NvF8Gmh8r2LgTYEGCI9SeAF4eP
        MOwvH082sqkaKAWKtbTK/ATt32bADSvnl69v2zpkacsqtLu/0FwhUNDhR60HQClFqJCRXC
        c/NqAukJgYeY/ELyGezjpnfTGJOuX4s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-XLC6b4tnORCBwLxvcI6-Og-1; Thu, 27 Oct 2022 05:12:25 -0400
X-MC-Unique: XLC6b4tnORCBwLxvcI6-Og-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A013A86F12C;
        Thu, 27 Oct 2022 09:12:24 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C24F549BB69;
        Thu, 27 Oct 2022 09:12:21 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, jlayton@kernel.org, mchangir@redhat.com,
        idryomov@gmail.com, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] ceph: fix NULL pointer dereference for req->r_session
Date:   Thu, 27 Oct 2022 17:11:54 +0800
Message-Id: <20221027091155.334178-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The request's r_session maybe changed when it was forwarded or
resent.

Cc: stable@vger.kernel.org
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 894adfb4a092..d34ac716d7fe 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2341,6 +2341,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 			goto out;
 		}
 
+		mutex_lock(&mdsc->mutex);
 		spin_lock(&ci->i_unsafe_lock);
 		if (req1) {
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
@@ -2350,6 +2351,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
+					mutex_unlock(&mdsc->mutex);
 					for (i = 0; i < max_sessions; i++) {
 						s = sessions[i];
 						if (s)
@@ -2372,6 +2374,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
+					mutex_unlock(&mdsc->mutex);
 					for (i = 0; i < max_sessions; i++) {
 						s = sessions[i];
 						if (s)
@@ -2387,6 +2390,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 			}
 		}
 		spin_unlock(&ci->i_unsafe_lock);
+		mutex_unlock(&mdsc->mutex);
 
 		/* the auth MDS */
 		spin_lock(&ci->i_ceph_lock);
-- 
2.31.1

