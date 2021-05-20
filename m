Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AF338A803
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbhETKp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237541AbhETKno (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C318961C88;
        Thu, 20 May 2021 09:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504609;
        bh=vk2Efc8N5SpL8dwz0sdJW14go6pdxzXH8AgGNb/LLrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcNUJFTlJxlzRIhjCdFVf8g+dAiPFgu5gwTE/AzyD0fyw558dT9bncde5hkpO+jmi
         KkxZENXpXBxrrb3T4gHuHj+h0k0MiSpZBWabJIF+i/ZKguRA+igtFsXrG9cU04l03R
         8tVdCySYMLd03Lsdiict4ZoXTFnrTLTNDMm9aiZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 314/323] ceph: fix fscache invalidation
Date:   Thu, 20 May 2021 11:23:26 +0200
Message-Id: <20210520092131.011992199@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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



