Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E99038A9F1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbhETLID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239348AbhETLGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:06:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A17A61D29;
        Thu, 20 May 2021 10:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505123;
        bh=q9p/jL1dxlKZfVTF1Fv6oBvpVsnuufUQ/yUS+MlceCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEDOdQSKmLUxrqC46A55iWgZJEp5dxGhXJxD1nX3pgUsiNvR6fnWPy/Hyi1DAHE4b
         aeZY0CZZaSd/vRdO1/+QifbWJHD4Rrd5CKojFUWZ+aBNaOzySARxlUEmltWh+AiLli
         YYFiMEQT9bPzhmEK4HXyhfEvZlLp7tyXxeteQulc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 234/240] ceph: fix fscache invalidation
Date:   Thu, 20 May 2021 11:23:46 +0200
Message-Id: <20210520092116.551850574@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index 2a351821d8f3..0eb2ada032c7 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1577,6 +1577,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	u32 invalidating_gen = ci->i_rdcache_gen;
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_fscache_invalidate(inode);
 	invalidate_mapping_pages(&inode->i_data, 0, -1);
 	spin_lock(&ci->i_ceph_lock);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 049cff197d2a..5e12ea92f7cd 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1762,6 +1762,7 @@ static void ceph_invalidate_work(struct work_struct *work)
 	orig_gen = ci->i_rdcache_gen;
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_fscache_invalidate(inode);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
 		pr_err("invalidate_pages %p fails\n", inode);
 	}
-- 
2.30.2



