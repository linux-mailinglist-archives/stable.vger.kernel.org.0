Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C239ACDBA
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733213AbfIHMws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733204AbfIHMws (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:48 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 362A820693;
        Sun,  8 Sep 2019 12:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947167;
        bh=iWdWvQj/QygSKnUvQWENMH98qfzOfZ2rLxO+WiunLmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndRi8wD2Clzos6Me8Qn3LH4TfkDYP8DNNzn7Hjp296PC+B66K+ATD4YksZHb1gkS9
         bEKr/YfcbFyPoWehOhH318mZygTl27/w2zC4YOlLavwSnbyZvShIYQnsaymf/iIgmL
         FEEU6zJGc5hTTgPJV7nT3PQleCjEmts4aNbtcF5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 86/94] afs: use correct afs_call_type in yfs_fs_store_opaque_acl2
Date:   Sun,  8 Sep 2019 13:42:22 +0100
Message-Id: <20190908121152.893198930@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7533be858f5b9a036b9f91556a3ed70786abca8e ]

It seems that 'yfs_RXYFSStoreOpaqueACL2' should be use in
yfs_fs_store_opaque_acl2().

Fixes: f5e4546347bc ("afs: Implement YFS ACL setting")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/yfsclient.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 18722aaeda33a..a1baf3f1f14d1 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -2155,7 +2155,7 @@ int yfs_fs_store_opaque_acl2(struct afs_fs_cursor *fc, const struct afs_acl *acl
 	       key_serial(fc->key), vnode->fid.vid, vnode->fid.vnode);
 
 	size = round_up(acl->size, 4);
-	call = afs_alloc_flat_call(net, &yfs_RXYFSStoreStatus,
+	call = afs_alloc_flat_call(net, &yfs_RXYFSStoreOpaqueACL2,
 				   sizeof(__be32) * 2 +
 				   sizeof(struct yfs_xdr_YFSFid) +
 				   sizeof(__be32) + size,
-- 
2.20.1



