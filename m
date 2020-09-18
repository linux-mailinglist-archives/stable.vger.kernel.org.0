Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5792926EB1F
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgIRCDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgIRCDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ACEF22211;
        Fri, 18 Sep 2020 02:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394601;
        bh=C/vWB/HWvbBoRq5OnbqfMnbsQfBPae8evloq2/dctHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJlDyPsY9EwGWOqvSKU0xkrEEcp1kNJqQxJWG3McESt4FwV8QG+NGNeZ+Fvhbvf74
         mcaQ0eCibnkT4kmCG+cpIT975yrHF8ZrmAqoro14o3yv40in6/72eVcLvcLqFzUTH3
         gbs9pEudcUTpXNw8Ie2BNut8PQ5UqZdFpA8ljPOI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 108/330] ceph: ensure we have a new cap before continuing in fill_inode
Date:   Thu, 17 Sep 2020 21:57:28 -0400
Message-Id: <20200918020110.2063155-108-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 9a6bed4fe0c8bf57785cbc4db9f86086cb9b193d ]

If the caller passes in a NULL cap_reservation, and we can't allocate
one then ensure that we fail gracefully.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index c07407586ce87..660a878e20ef2 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -754,8 +754,11 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 	info_caps = le32_to_cpu(info->cap.caps);
 
 	/* prealloc new cap struct */
-	if (info_caps && ceph_snap(inode) == CEPH_NOSNAP)
+	if (info_caps && ceph_snap(inode) == CEPH_NOSNAP) {
 		new_cap = ceph_get_cap(mdsc, caps_reservation);
+		if (!new_cap)
+			return -ENOMEM;
+	}
 
 	/*
 	 * prealloc xattr data, if it looks like we'll need it.  only
-- 
2.25.1

