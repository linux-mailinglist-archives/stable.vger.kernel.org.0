Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9547E40A0C1
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348345AbhIMWlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349401AbhIMWj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF97861359;
        Mon, 13 Sep 2021 22:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572553;
        bh=wONYPr1iARhFTkx5Qms6LfW3HU9ee554V1WrHB3zeRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tf3JH2UHBd/7fXi2rKEhERd8wZTC6Liv1IEFBCZfOg8dvU8CMj9ivXCaiR6jdhmB6
         JzH8y/Coc1Vww/nVBDKmAeyALmMoN4hJdhZyiaGsclVMRRMN3Wu9gtwsFbIFvLffnk
         lQHO9k3Zy7i7ZVlS+cqjv5xgBT2DhbR9Bjox25gut+7ulzOL7atNB4ERVmUZIxWKYa
         0e49AGP+olgUlXJXrlRIkacTZjcvOebebMIBXt1i3W9p2u9ixSW9usALPzBYlxxui7
         lKf55Gem3Pe0DSopyvRsgIk/kJ/SOq5tywHTE8+qNM/Eg7NLwfSoJX9g65R9HRIuuH
         TVFtchs6SwoUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/9] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Mon, 13 Sep 2021 18:35:43 -0400
Message-Id: <20210913223549.436541-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223549.436541-1-sashal@kernel.org>
References: <20210913223549.436541-1-sashal@kernel.org>
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
index 0eb2ada032c7..839bccbcc9d6 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1572,6 +1572,8 @@ static int __mark_caps_flushing(struct inode *inode,
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

