Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DEA45E5D3
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358945AbhKZCpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358671AbhKZCnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:43:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3800761269;
        Fri, 26 Nov 2021 02:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894135;
        bh=H0d5Y8z+TF/XRdKSWQ78s5VksBAwR20gQd7Ac13ow4A=;
        h=From:To:Cc:Subject:Date:From;
        b=d/iG0e3hvXiQdED4KkQyv9PW8cALy+XZJbTsSq+iBKywzUq4YIwedgFemq4VyvYMZ
         qRrEiyXjVWIu5Z8yt8Rw0K2J0rB2cQMlEcbmR4rUoblRQVRRZt/yncSQk99mV7WFoa
         31Zvgrgqq3mztn5Cb4DDYzxz4vEcERHGgarJVi76LSdjuxfPPAq6+62WB6CMLXk2Dc
         NAHySgGIADQddI3fLJpZyfFP7cnp7oy9x67vICfbvCxu2qSa3ztvkjduKP3+QNu+ml
         C99N6cOUsrWNMuLsg+UhCp6hTR9/CDCf+RqI9ErDS7cDJlFU0vst4dUW9lJB4Edv1I
         5Gfv/Bi+exzOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, rpeterso@redhat.com,
        cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 01/15] gfs2: Fix length of holes reported at end-of-file
Date:   Thu, 25 Nov 2021 21:35:19 -0500
Message-Id: <20211126023533.442895-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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
index 43f53020553b5..53ba5019ad063 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -943,7 +943,7 @@ static int gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 		else if (height == ip->i_height)
 			ret = gfs2_hole_size(inode, lblock, len, mp, iomap);
 		else
-			iomap->length = size - pos;
+			iomap->length = size - iomap->offset;
 	} else if (flags & IOMAP_WRITE) {
 		u64 alloc_size;
 
-- 
2.33.0

