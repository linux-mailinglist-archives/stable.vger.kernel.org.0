Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0179C45E4B9
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351725AbhKZChM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243836AbhKZCfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:35:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B750B61178;
        Fri, 26 Nov 2021 02:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893919;
        bh=8XlJOyULVEaLC80xsroRj7at9xsa2yy+UzE+Y/H1Abo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/RLm9Jo4BxjcEeX2yWvitdEW1F4Vo1+IC38HhSp+EDjfpTGXEVWnswhCnqJC+Pcg
         udL7chXqFwszoAhyokdsXL1euGujRh4MITnRZRTi7Z2C1mhhdUMI790FjANBCggh5i
         GJ71Nl8jvAZ9u8xAIWOAnzZOgBKrh6i5jIrIihfze46s8LPswjOqHWt8pAQ+jHYLN4
         E1hSO6+riQf+SYVKVxV529wuVpjmnchXzwULY5Zy8A1wDF9Z2l65N70Wk9R5j78eFR
         SeF+xKJx4VFuH6fb7WexH1uMRWpVW7JG2+aHzG4f550f/yD616Hey7csXRg9rfnPUy
         7pjPFqPKqIvLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, rpeterso@redhat.com,
        cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 02/39] gfs2: Fix length of holes reported at end-of-file
Date:   Thu, 25 Nov 2021 21:31:19 -0500
Message-Id: <20211126023156.441292-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit f3506eee81d1f700d9ee2d2f4a88fddb669ec032 ]

Fix the length of holes reported at the end of a file: the length is
relative to the beginning of the extent, not the seek position which is
rounded down to the filesystem block size.

This bug went unnoticed for some time, but is now caught by the
following assertion in iomap_iter_done():

  WARN_ON_ONCE(iter->iomap.offset + iter->iomap.length <= iter->pos)

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 5414c2c335809..fba32141a651b 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -940,7 +940,7 @@ static int __gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 		else if (height == ip->i_height)
 			ret = gfs2_hole_size(inode, lblock, len, mp, iomap);
 		else
-			iomap->length = size - pos;
+			iomap->length = size - iomap->offset;
 	} else if (flags & IOMAP_WRITE) {
 		u64 alloc_size;
 
-- 
2.33.0

