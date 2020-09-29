Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CA527C8F1
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730290AbgI2MGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730268AbgI2Lhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5508B23BDF;
        Tue, 29 Sep 2020 11:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379445;
        bh=aZQ8kblRrgrsA6AI6PIohMYUWXqq5h+dYDdP2IxiZTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYJHDz3nQz0lB/+zlfvXo6LymnlsYHp8Y/TO+JYR0CFeOFfMs4eLImeEYALGw+HWG
         rem/Bj9dHZtKprheTj0LqrLJmuUd8c/aAsPlQHmmxr+qZClDvsd4ae1uGiLwwbDeMb
         LsYBMXmhtBCrunhOHkx2/VXKQYpjBHjD5jgBS4OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Dmitry Monakhov <dmonakhov@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 167/388] ext4: mark block bitmap corrupted when found instead of BUGON
Date:   Tue, 29 Sep 2020 12:58:18 +0200
Message-Id: <20200929110018.565641211@linuxfoundation.org>
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

From: Dmitry Monakhov <dmonakhov@gmail.com>

[ Upstream commit eb5760863fc28feab28b567ddcda7e667e638da0 ]

We already has similar code in ext4_mb_complex_scan_group(), but
ext4_mb_simple_scan_group() still affected.

Other reports: https://www.spinics.net/lists/linux-ext4/msg60231.html

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Dmitry Monakhov <dmonakhov@gmail.com>
Link: https://lore.kernel.org/r/20200310150156.641-1-dmonakhov@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e1782b2e2e2dd..e5d43d2ee474d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1901,8 +1901,15 @@ void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 		BUG_ON(buddy == NULL);
 
 		k = mb_find_next_zero_bit(buddy, max, 0);
-		BUG_ON(k >= max);
-
+		if (k >= max) {
+			ext4_grp_locked_error(ac->ac_sb, e4b->bd_group, 0, 0,
+				"%d free clusters of order %d. But found 0",
+				grp->bb_counters[i], i);
+			ext4_mark_group_bitmap_corrupted(ac->ac_sb,
+					 e4b->bd_group,
+					EXT4_GROUP_INFO_BBITMAP_CORRUPT);
+			break;
+		}
 		ac->ac_found++;
 
 		ac->ac_b_ex.fe_len = 1 << i;
-- 
2.25.1



