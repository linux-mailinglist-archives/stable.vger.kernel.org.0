Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF5A409FD4
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348476AbhIMWf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345239AbhIMWfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB30C610F9;
        Mon, 13 Sep 2021 22:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572439;
        bh=YAltlpkOHQzTLi7lq7YCNJJq/CIKloXk9NURNqtMagI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kcxwx5yIQhZ/GaXG+MTCP99TuTCE2jvU4kPjLppBXOud2DNVDUG3nuKN3wOGnGrH9
         bC5FVmSR/VFZuzF06avDoU5T8SBfJVNIZuxgzEcvf7RM0BLf+taOTFtsnlHAqhPOdG
         hs7xx+hkay9s8A6isjnkRuYK7UTzeLV5GX6ln4PwCAvD+AYolKnjZvg36WJ0O/BoR9
         DVu6N4p9yl2Pe6FFnv1oJ5noWU5+j4F19vDGLPKrMw18lpjJWN+EKIDlsZNsYPPa/E
         DOJxAmhCtaz4aq++zDKZnjbw6bnUWaAPAAudddQ4VARUZ85ZAqs1jyV6VFEnXaviZ/
         haPB4M4NRldLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 14/25] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Mon, 13 Sep 2021 18:33:28 -0400
Message-Id: <20210913223339.435347-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223339.435347-1-sashal@kernel.org>
References: <20210913223339.435347-1-sashal@kernel.org>
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
index 73d8487a71d8..1fa961a5a22f 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1856,6 +1856,8 @@ static u64 __mark_caps_flushing(struct inode *inode,
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

