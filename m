Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB1A38A15B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhETJah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231984AbhETJ2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:28:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 113C9613AA;
        Thu, 20 May 2021 09:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502817;
        bh=BgWX0d9h3klkaGXVA7a6ZgusKUgNUKaqRxDr0yosfq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bh7iFexLMiNJxPadqKcm1wMMWig/7svjSpn4SdkNC7kg+98q1P1ZhmI/D+j2Zo32l
         lGPvRJCax7KRpqN9ML+HPKPjvBXk0TgVoyoq12zRf82CqptZlWjWQex7ypizBa+EZj
         N20nOn1m7qmueafZovazgncUMQAPCSc81NeYq0eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/47] ceph: fix fscache invalidation
Date:   Thu, 20 May 2021 11:22:25 +0200
Message-Id: <20210520092054.426572911@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 576d01275bbd..e4fc99afa25a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1866,6 +1866,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	u32 invalidating_gen = ci->i_rdcache_gen;
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_fscache_invalidate(inode);
 	invalidate_mapping_pages(&inode->i_data, 0, -1);
 	spin_lock(&ci->i_ceph_lock);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2462a9a84b95..6bd2a6ced22a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1912,6 +1912,7 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 	orig_gen = ci->i_rdcache_gen;
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_fscache_invalidate(inode);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
 		pr_err("invalidate_pages %p fails\n", inode);
 	}
-- 
2.30.2



