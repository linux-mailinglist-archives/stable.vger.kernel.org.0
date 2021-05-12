Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3279537D2F0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350675AbhELSPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353181AbhELSKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 754316144F;
        Wed, 12 May 2021 18:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842737;
        bh=vk2Efc8N5SpL8dwz0sdJW14go6pdxzXH8AgGNb/LLrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFkiSVC1F1ikevYVRhz0dNvJCeYWwLnpMVIxI8MdU+iTYR28dRnxG8uJHzwobV0yM
         gQR2eGZ47eKxeXAJ8lF1Z+zPArUchnqwXSzThjs8bbdYtT4bcHzAoWZ7TGZf4+4iEZ
         eQFwv3O7Emd1U9mS92Q6tTm694zNMxfPE1mI1pnTQsuSbDjnKofLgqYKCBuxv+4RnA
         5Fe6E/o/p9LwDuxGw9GxHsImWu4fpnM8dqOYX5Z64ofjo6tjYt50wMAXQIk896j/0y
         hI1dEQ4gMnNDiA0aYog3TvNu8q6o46cxwkZHSv2mI1HIgrwPMFZBXq7q1/wLOQaxUO
         9Z+UjNlCXchoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/12] ceph: fix fscache invalidation
Date:   Wed, 12 May 2021 14:05:18 -0400
Message-Id: <20210512180522.665788-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180522.665788-1-sashal@kernel.org>
References: <20210512180522.665788-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 10a7052c7868bc7bc72d947f5aac6f768928db87 ]

Ensure that we invalidate the fscache whenever we invalidate the
pagecache.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c  | 1 +
 fs/ceph/inode.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 382cf85fd574..b077b9a6bf95 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1662,6 +1662,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	u32 invalidating_gen = ci->i_rdcache_gen;
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_fscache_invalidate(inode);
 	invalidate_mapping_pages(&inode->i_data, 0, -1);
 	spin_lock(&ci->i_ceph_lock);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 5999d806de78..90db2cd07840 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1757,6 +1757,7 @@ static void ceph_invalidate_work(struct work_struct *work)
 	orig_gen = ci->i_rdcache_gen;
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_fscache_invalidate(inode);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
 		pr_err("invalidate_pages %p fails\n", inode);
 	}
-- 
2.30.2

