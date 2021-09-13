Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD4B40A038
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349009AbhIMWhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243387AbhIMWgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:36:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEDFE61250;
        Mon, 13 Sep 2021 22:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572491;
        bh=o760lU8MtEiFatOjnULvEfDP6PMH2wCtpfXEPw031bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Db3zwaTXDJllOxJKS8J6yQOwFSEqz0dGoYYkSTVx/CUuvWnzP8mF+bLzuRp8gfO66
         fYfUhfIQX2PRkvDx5KIQcdeaqsBcfPOIomd8g/UK95tNZF1TKMqwMawOqTH3r7nPix
         D17QB5qlq/XEYWsP1C1rgVpk2d0qVbWuaeNZ08blJWbjhiFfyt78eam7dxWSC2FQz7
         dxzkZygl068y1js0pmhKzd2sQ4au443HbFXfflSnYIajhw67XBvSx9XTlHq1YnWZ7p
         pRXu5lCF2uF4BumrxDxPfIcvjX5nQGH/0Ct71MF95adIC5TO4I3S10cukQUTHeXb+J
         9w2IRprfE2kew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/16] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Mon, 13 Sep 2021 18:34:33 -0400
Message-Id: <20210913223442.435885-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223442.435885-1-sashal@kernel.org>
References: <20210913223442.435885-1-sashal@kernel.org>
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
index a975a9354ee5..dcd61e33b82e 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1865,6 +1865,8 @@ static u64 __mark_caps_flushing(struct inode *inode,
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

