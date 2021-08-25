Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BDE3F6EC4
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 07:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhHYFXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 01:23:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231490AbhHYFXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 01:23:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629868946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mpfOZMJ9vLgo4SXlvQ8UMbbVxuhe3YDX0vpFC5xR91k=;
        b=IqZ8HQHzPIgmQ4WFOl6jsZ7Wwz5AOdKRStGfkY2fAebm3jcFr1BlAHTtvNYbqBVAYopn7s
        Cx3YDe06blUy5/1vGu9cXAygIIQt39sMlVpG35qAt7iqbg+AnVg7ECkdp5ie0ViN2K2WQv
        yVCiC+UjjoMidEty9nMA7lamvOWWCQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-9rZuxZTSPzC16DaZXSWOsg-1; Wed, 25 Aug 2021 01:22:22 -0400
X-MC-Unique: 9rZuxZTSPzC16DaZXSWOsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2459F1853028;
        Wed, 25 Aug 2021 05:22:21 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B38255C1A1;
        Wed, 25 Aug 2021 05:22:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] ceph: init the i_list/g_list for cap flush
Date:   Wed, 25 Aug 2021 13:22:12 +0800
Message-Id: <20210825052212.19625-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Always init the i_list/g_list in the begining to make sure it won't
crash the kernel if someone want to delete the cap_flush from the
lists.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/52401
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 2 +-
 fs/ceph/snap.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 4f0dbc640b0b..60f60260cf42 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3666,7 +3666,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 	while (!list_empty(&to_remove)) {
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
-		list_del(&cf->i_list);
+		list_del_init(&cf->i_list);
 		if (!cf->is_capsnap)
 			ceph_free_cap_flush(cf);
 	}
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 62fab59bbf96..b41e6724c591 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -488,6 +488,8 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 		return;
 	}
 	capsnap->cap_flush.is_capsnap = true;
+	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
+	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
 
 	spin_lock(&ci->i_ceph_lock);
 	used = __ceph_caps_used(ci);
-- 
2.27.0

