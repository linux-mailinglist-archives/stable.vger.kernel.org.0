Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE9F27C998
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgI2MMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730156AbgI2Lhc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C22F23F2A;
        Tue, 29 Sep 2020 11:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379300;
        bh=C/vWB/HWvbBoRq5OnbqfMnbsQfBPae8evloq2/dctHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+vdLuhIjjVmbBrpXgjvs6Zpn+DILpJJ9wpBq+u1oaTp2NMav07yZzMaB0RFRh6if
         c913Ig9RoTIV7yEIndGon2+u0pWSG9jBzoJ5wkjnPBJxsZK8UEBqN+HAj+sWv4JR4V
         Go2Q79UqhDqN5xf2uwhwoqmwpy0hAGj7kyXRgj1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/388] ceph: ensure we have a new cap before continuing in fill_inode
Date:   Tue, 29 Sep 2020 12:57:13 +0200
Message-Id: <20200929110015.419352695@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
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



