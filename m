Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BD337D27C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349855AbhELSKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352638AbhELSDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:03:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59FBE6143A;
        Wed, 12 May 2021 18:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842562;
        bh=c0vGxJE0kD84WdGeDJ94vKifbuj/0KCQOtmoxbuS6Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diyqN0or1ceOt25v/g1RQsbSzeHVZQ0xtRDyjBlE0DzpKYK7Wu+wVwQ+F71DjQTEN
         iMV6OiUwluaXNzLlEpp1byXnIdViMf1Bkzx+jCAH1a2g8xALm2bV98xIGTk/BS9uqj
         OIQxoqHhR2xwxUD60pyimvko8IW0tAtT0ahuUtv3hAqiBdMq3KiSavmpOvCerkBJmm
         kMmh58aV7mp1mADy9+yA9r5K72pNpo51SvQm5efpPKFWEyVMeALj51DfaDfZ2aVC1d
         YanOj0YRPhkAgnBmGdv0lFHuvGHDCHca8G1hDf6nCc/6lG+DGcfUl9jt7b+b7in8gg
         ZQctIo5WUdUnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 21/35] ceph: fix fscache invalidation
Date:   Wed, 12 May 2021 14:01:51 -0400
Message-Id: <20210512180206.664536-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 638d18c198ea..52d78510e437 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1867,6 +1867,7 @@ static int try_nonblocking_invalidate(struct inode *inode)
 	u32 invalidating_gen = ci->i_rdcache_gen;
 
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_fscache_invalidate(inode);
 	invalidate_mapping_pages(&inode->i_data, 0, -1);
 	spin_lock(&ci->i_ceph_lock);
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index adc8fc3c5d85..2caa6df0bcdf 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1906,6 +1906,7 @@ static void ceph_do_invalidate_pages(struct inode *inode)
 	orig_gen = ci->i_rdcache_gen;
 	spin_unlock(&ci->i_ceph_lock);
 
+	ceph_fscache_invalidate(inode);
 	if (invalidate_inode_pages2(inode->i_mapping) < 0) {
 		pr_err("invalidate_pages %p fails\n", inode);
 	}
-- 
2.30.2

