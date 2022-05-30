Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1A7538300
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240554AbiE3O30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbiE3ORN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598A81109AB;
        Mon, 30 May 2022 06:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB014B80D83;
        Mon, 30 May 2022 13:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9336EC36AE3;
        Mon, 30 May 2022 13:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918245;
        bh=HwjH44pS8984mw7Nh4lKusX1l8RJWXNJDc+xlPI7FLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNdq4VSj4Keixr6kMEEGQHNG4BxbncWAY2yxA+UNYJVP4ED7GG7bnBkOH9mspcsmc
         Ouu4LVQAywPuA2CkHNkfE8F95hzILIxTCeUYniaZFkvrEFo4PDcUICuOyV/JyCq0KG
         5JYbktyd2wIIrLThCvEs6ZC+HY6ADVwTcBJWKx/oSdG+14fMMzn3CNtIpnyi6ETv7w
         pxPcrS8jSBfabWQXb8YbeBCbRzij2ksnBpCdkYG/p+5NZU1vXFxeQPLR5VF0WXKoGh
         JBxWIoKIl6UNLZwu2VIjIt7qYDUySc75meT3VmLwK0UTSPZ65y1XALPhLt4LHVe9In
         bhJh+bSg0r8Cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 109/109] gfs2: use i_lock spin_lock for inode qadata
Date:   Mon, 30 May 2022 09:38:25 -0400
Message-Id: <20220530133825.1933431-109-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 5fcff61eea9efd1f4b60e89d2d686b5feaea100f ]

Before this patch, functions gfs2_qa_get and _put used the i_rw_mutex to
prevent simultaneous access to its i_qadata. But i_rw_mutex is now used
for many other things, including iomap_begin and end, which causes a
conflict according to lockdep. We cannot just remove the lock since
simultaneous opens (gfs2_open -> gfs2_open_common -> gfs2_qa_get) can
then stomp on each others values for i_qadata.

This patch solves the conflict by using the i_lock spin_lock in the inode
to prevent simultaneous access.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index be0997e24d60..dc77080a82bb 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -531,34 +531,42 @@ static void qdsb_put(struct gfs2_quota_data *qd)
  */
 int gfs2_qa_get(struct gfs2_inode *ip)
 {
-	int error = 0;
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct inode *inode = &ip->i_inode;
 
 	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
 		return 0;
 
-	down_write(&ip->i_rw_mutex);
+	spin_lock(&inode->i_lock);
 	if (ip->i_qadata == NULL) {
-		ip->i_qadata = kmem_cache_zalloc(gfs2_qadata_cachep, GFP_NOFS);
-		if (!ip->i_qadata) {
-			error = -ENOMEM;
-			goto out;
-		}
+		struct gfs2_qadata *tmp;
+
+		spin_unlock(&inode->i_lock);
+		tmp = kmem_cache_zalloc(gfs2_qadata_cachep, GFP_NOFS);
+		if (!tmp)
+			return -ENOMEM;
+
+		spin_lock(&inode->i_lock);
+		if (ip->i_qadata == NULL)
+			ip->i_qadata = tmp;
+		else
+			kmem_cache_free(gfs2_qadata_cachep, tmp);
 	}
 	ip->i_qadata->qa_ref++;
-out:
-	up_write(&ip->i_rw_mutex);
-	return error;
+	spin_unlock(&inode->i_lock);
+	return 0;
 }
 
 void gfs2_qa_put(struct gfs2_inode *ip)
 {
-	down_write(&ip->i_rw_mutex);
+	struct inode *inode = &ip->i_inode;
+
+	spin_lock(&inode->i_lock);
 	if (ip->i_qadata && --ip->i_qadata->qa_ref == 0) {
 		kmem_cache_free(gfs2_qadata_cachep, ip->i_qadata);
 		ip->i_qadata = NULL;
 	}
-	up_write(&ip->i_rw_mutex);
+	spin_unlock(&inode->i_lock);
 }
 
 int gfs2_quota_hold(struct gfs2_inode *ip, kuid_t uid, kgid_t gid)
-- 
2.35.1

