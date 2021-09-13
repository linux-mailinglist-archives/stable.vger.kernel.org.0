Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD36840A06B
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343948AbhIMWjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348545AbhIMWhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:37:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96FFC61222;
        Mon, 13 Sep 2021 22:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572511;
        bh=LlZl4uotdXTLcazj5ABksNCOpYWPlfmtfApMEEoTKeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGmS9wFgrDW/uT2zEjEuU7LFl7idfDfy+GdRAnXjvBYU3LmDN7bauwqrgv46W4LUk
         zyAzJFXWQlzLS5auZ3nVhFlC7jp4vDu7PFWFg9+N0P/Q8IhZiV1bwre83g6HfKwTs9
         y4sk6yUMPNh7tWvOIUMrx+hek3HfDVGyjDf/4mV30v2snk+cUA6bwkbOlDQSEyXhDM
         mV1Y7U0Do5XQXLR5OpWJdYCI2p9UuQI5IAxud4kuhZ7IT+jJ3ziec2sDm3F9yUgykQ
         IdvO+oI++ou7qSi/PX2GFNNid8U0UOUHlVKwvt5VscDwe/YTd8DgBs4ZcsgspAmVsE
         Bcj/Zm7Js2otA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/12] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Mon, 13 Sep 2021 18:34:57 -0400
Message-Id: <20210913223504.436087-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223504.436087-1-sashal@kernel.org>
References: <20210913223504.436087-1-sashal@kernel.org>
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
2.30.2

