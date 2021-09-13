Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7486C40A00A
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241750AbhIMWg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244733AbhIMWfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A5A661244;
        Mon, 13 Sep 2021 22:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572469;
        bh=C2fs0vgBpVWXdLnQqc7lYCGWUEUn07LFF0oxJiviVeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEy9zeVftxTkzMew0zFaAmj9mEx9s+4ONoahEeQO44nIu2bY3ka76wHTAXLLeYILS
         jtprzD9Nxu5/IHuXj2MKpeffa8CUEWzcMZAQzOW5KxHT4Nx285rQzIq8MSHGfd7s+U
         IGHUivBvLg3WXn9k0bnfQKjusYClmIEDafUR3ShZuOa0f4hj0HRdezhILp1ZVQCTsm
         8QuHDRE5X5sfJAauOI1ElojxFfD7LcVFdQDKw9/GpM8X4ydPuItrrONO2myMf0KTeQ
         F2HusxuTV/eY7lggU1oC5v7tO+4g8aft3GBNUIrsLnikHFGzqIUsvFCzcfA5NMELXU
         3yXkbSkN6Wh0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 10/19] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Mon, 13 Sep 2021 18:34:06 -0400
Message-Id: <20210913223415.435654-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223415.435654-1-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
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
index 883c9d8e4aac..2f4d112898f8 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1866,6 +1866,8 @@ static u64 __mark_caps_flushing(struct inode *inode,
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

