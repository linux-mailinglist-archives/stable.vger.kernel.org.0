Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F2D27C988
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbgI2ML1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730169AbgI2Lhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9928423A59;
        Tue, 29 Sep 2020 11:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378577;
        bh=z615ymZ/Om4N2G36QTxSXe6ZDUUfnlbl5HQD/4ZM9f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C172qmW53qKzyCsy6Ijp+HViNuJBFowDyU/XmC2U0I1Mbtv30ABmZL4vMBBimI+5v
         0Ry2k/AVSmwfJsSS5Cltq1RMUK2vt0lpJCdfS9MipdFO62q5YT6rzHywb+uLu+2SKN
         kqI3ZCglBM3ax7A6pG70Zw9nBuuiJ9lsTOkLzkLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/245] ceph: ensure we have a new cap before continuing in fill_inode
Date:   Tue, 29 Sep 2020 12:58:34 +0200
Message-Id: <20200929105950.059456156@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1e438e0faf77e..3c24fb77ef325 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -764,8 +764,11 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
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



