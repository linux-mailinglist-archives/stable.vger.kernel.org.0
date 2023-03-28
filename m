Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F636CC27E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbjC1Op4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjC1Opq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:45:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FA4D536
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AE07B81D6D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F3AC433EF;
        Tue, 28 Mar 2023 14:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014722;
        bh=VGNjUKVjaawdHQ6W6FEjwa7F6GknnswJu3vHYXpRp68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GF/ksvZtpoxvVz+Vy1RdZkNXVrOGPVrn3v+GFJARM24a9kACNyJXfPRet6G7NF5Cf
         Q3D6FGrXYuglWJXyAAvufdY8LSxrKHREkTV4w8fh+wPFzpx9jB/iXZEPyhbUdFGP1V
         obDsttvno83/KuZie+YLs4ZuTTFKNv8YR8rG7lZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chengen Du <chengen.du@canonical.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 028/240] NFS: Correct timing for assigning access cache timestamp
Date:   Tue, 28 Mar 2023 16:39:51 +0200
Message-Id: <20230328142620.808482644@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengen Du <chengen.du@canonical.com>

[ Upstream commit 21fd9e8700de86d1169f6336e97d7a74916ed04a ]

When the user's login time is newer than the cache's timestamp,
the original entry in the RB-tree will be replaced by a new entry.
Currently, the timestamp is only set if the entry is not found in
the RB-tree, which can cause the timestamp to be undefined when
the entry exists. This may result in a significant increase in
ACCESS operations if the timestamp is set to zero.

Signed-off-by: Chengen Du <chengen.du@canonical.com>
Fixes: 0eb43812c027 ("NFS: Clear the file access cache upon login”)
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index f7e4a88d5d929..e28dd6475e390 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -3089,7 +3089,6 @@ static void nfs_access_add_rbtree(struct inode *inode,
 		else
 			goto found;
 	}
-	set->timestamp = ktime_get_ns();
 	rb_link_node(&set->rb_node, parent, p);
 	rb_insert_color(&set->rb_node, root_node);
 	list_add_tail(&set->lru, &nfsi->access_cache_entry_lru);
@@ -3114,6 +3113,7 @@ void nfs_access_add_cache(struct inode *inode, struct nfs_access_entry *set,
 	cache->fsgid = cred->fsgid;
 	cache->group_info = get_group_info(cred->group_info);
 	cache->mask = set->mask;
+	cache->timestamp = ktime_get_ns();
 
 	/* The above field assignments must be visible
 	 * before this item appears on the lru.  We cannot easily
-- 
2.39.2



