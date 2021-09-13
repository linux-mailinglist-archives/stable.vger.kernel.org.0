Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CE340A0B0
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349525AbhIMWlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348615AbhIMWjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:39:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B644D6113B;
        Mon, 13 Sep 2021 22:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572540;
        bh=bMWYl7MEv7pQlbpXp3aJt9/xUduUIVyPynFNRLtuNUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+FaJuvy1hxeHE0YjIcXC16ztazx6TIkgF0btVBgChPqkgO1YAThFepze3Yl26HD0
         vMv9xRLVZmo5HH+/JtViIaqVEH7Q8Nyzs7/rOtM7z080ZmITEr2ABeObBfeXeaxLf9
         LagYUaMTnIq6Vq+GEi5vpuIGRFsJ9ZYx/xAxPliJGj3Zw1Ny+dJs/nXAHOUGumYe9Y
         REz+bbEHmQcywGZWwtoegRGDQKI9plkSDzN868Y23t9CxzKibWIqZpM0QGEAGAFQWV
         mqOS/ASwFWjuDYLprCpQnkz42LYQBO2mjXpJg7ifPYp92asoLSFZ+jwSfW5P5WC3Qk
         eUcjT8nKhoEnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/9] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Mon, 13 Sep 2021 18:35:29 -0400
Message-Id: <20210913223535.436405-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223535.436405-1-sashal@kernel.org>
References: <20210913223535.436405-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b077b9a6bf95..a0168d9bb85d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1657,6 +1657,8 @@ static int __mark_caps_flushing(struct inode *inode,
  * try to invalidate mapping pages without blocking.
  */
 static int try_nonblocking_invalidate(struct inode *inode)
+	__releases(ci->i_ceph_lock)
+	__acquires(ci->i_ceph_lock)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u32 invalidating_gen = ci->i_rdcache_gen;
-- 
2.30.2

