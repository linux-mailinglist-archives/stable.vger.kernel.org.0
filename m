Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AA9C3D37
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbfJAQlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731218AbfJAQll (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26CB72190F;
        Tue,  1 Oct 2019 16:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948100;
        bh=Wmk2nFhDp2+8jCV07diTlQn1EA/r5Bpio5yf57OjGyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXizrT+X5SMU3x/Wtb1fWvRPR5ozu92G7XUa7ICA6oyctHrmLEdMuF8itmsd5ZDu9
         grt4k82xDrK09L0NH1zb0ZBYMqlgBrKo4nSGtjIewmj07DjIAU7DBPVWIQCYQtR4Cm
         tPeQHg3yzPXuGe2hHlf/U5jSnhHaR7DiNZSY2dGQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 12/63] ceph: fetch cap_gen under spinlock in ceph_add_cap
Date:   Tue,  1 Oct 2019 12:40:34 -0400
Message-Id: <20191001164125.15398-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164125.15398-1-sashal@kernel.org>
References: <20191001164125.15398-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 606d102327a45a49d293557527802ee7fbfd7af1 ]

It's protected by the s_gen_ttl_lock, so we should fetch under it
and ensure that we're using the same generation in both places.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 622467e47cde8..07ac2de542eb3 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -644,6 +644,7 @@ void ceph_add_cap(struct inode *inode,
 	struct ceph_cap *cap;
 	int mds = session->s_mds;
 	int actual_wanted;
+	u32 gen;
 
 	dout("add_cap %p mds%d cap %llx %s seq %d\n", inode,
 	     session->s_mds, cap_id, ceph_cap_string(issued), seq);
@@ -655,6 +656,10 @@ void ceph_add_cap(struct inode *inode,
 	if (fmode >= 0)
 		wanted |= ceph_caps_for_mode(fmode);
 
+	spin_lock(&session->s_gen_ttl_lock);
+	gen = session->s_cap_gen;
+	spin_unlock(&session->s_gen_ttl_lock);
+
 	cap = __get_cap_for_mds(ci, mds);
 	if (!cap) {
 		cap = *new_cap;
@@ -680,7 +685,7 @@ void ceph_add_cap(struct inode *inode,
 		list_move_tail(&cap->session_caps, &session->s_caps);
 		spin_unlock(&session->s_cap_lock);
 
-		if (cap->cap_gen < session->s_cap_gen)
+		if (cap->cap_gen < gen)
 			cap->issued = cap->implemented = CEPH_CAP_PIN;
 
 		/*
@@ -774,7 +779,7 @@ void ceph_add_cap(struct inode *inode,
 	cap->seq = seq;
 	cap->issue_seq = seq;
 	cap->mseq = mseq;
-	cap->cap_gen = session->s_cap_gen;
+	cap->cap_gen = gen;
 
 	if (fmode >= 0)
 		__ceph_get_fmode(ci, fmode);
-- 
2.20.1

