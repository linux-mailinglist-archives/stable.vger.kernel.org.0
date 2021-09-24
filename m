Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342BA417399
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345012AbhIXM7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344788AbhIXM4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:56:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8D446138B;
        Fri, 24 Sep 2021 12:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487890;
        bh=dTSZ1GSvL2VCXDfHrK1x4xeU9uhucsyjzcXzZv+PTr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twOqgdA8K+SiIByXSFolnrSZOBhVzmSjpL5RkJj02gjYsa+jA0s3cq67UrWm5Yhqo
         wk81VXTkjqwbHLQXNVBPm4H9YUbPeuazErFwmu3ssp9XB6z2L0zBZtuyfY4rf9LKJW
         lFEsYUV/wEG/h0wxb/0Bp5/DfKkmJHdN04eLcok8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/50] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Fri, 24 Sep 2021 14:44:26 +0200
Message-Id: <20210924124333.503932249@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 3eaf5aa1cfa8c97c72f5824e2e9263d6cc977b03 ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a49bf1fbaea8..0fad044a5752 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1775,6 +1775,8 @@ static u64 __mark_caps_flushing(struct inode *inode,
  * try to invalidate mapping pages without blocking.
  */
 static int try_nonblocking_invalidate(struct inode *inode)
+	__releases(ci->i_ceph_lock)
+	__acquires(ci->i_ceph_lock)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u32 invalidating_gen = ci->i_rdcache_gen;
-- 
2.33.0



