Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2025040A085
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346456AbhIMWjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343807AbhIMWhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:37:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A310B61350;
        Mon, 13 Sep 2021 22:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572527;
        bh=cv+9O/FhMSFqPCz3aqrnpW69U6GPOlG4vUFrA7wGpeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDNCicfSV088ntwvfNlprYRZmVDtBThA7oejYK24HFpqaP/76LRCXyFy2NJ5x39cd
         z9JJHltXIz1D2889Xnj+LVDTqdA/fpnkKPiiI/Uj2hwSIfF7HGr/wrENd07MYgHV1M
         Tx6+BGI0pxnhyRkHoxaDuVnuETgOBm11VGm4oU9toaR96lRbqpE53Nt1PoNBmiAjVb
         oGQWju7PmnGmw32uvOtyRvVhpW6yvvX1rPNLJrJ7VlEwAvXKhuRS9Asr7GJmfC9wwv
         +ujRrHxL3U4AzOvooCr2daCgecZwcdRfM4C8OpgrIZv5DYw1g26YdeSOxUdexFSJmk
         uKY0Lh2gTUQMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/10] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Mon, 13 Sep 2021 18:35:15 -0400
Message-Id: <20210913223521.436250-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223521.436250-1-sashal@kernel.org>
References: <20210913223521.436250-1-sashal@kernel.org>
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
index 918781c51f0b..6443ba1e60eb 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1774,6 +1774,8 @@ static int __mark_caps_flushing(struct inode *inode,
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

