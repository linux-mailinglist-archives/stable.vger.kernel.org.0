Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51F66E016
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbfGSD6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbfGSD6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B08621851;
        Fri, 19 Jul 2019 03:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508700;
        bh=aJRvDu9YvM33JggDAoN3fy/XtFIU7MiopLHT5SlzMcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lddfjHPDE2LR9VYNgI2X3oHkz4vTs/Vdb6OQVYRZALdOdeZ9BFbY1584f/eVro4R/
         jrbnYtzq2GEf2GKOuMM17z5KVvuLyfvjd3No94wzVTRvT3+i4yVAiRvsED/LaThZ77
         8YvUIULfTGwJ/RSftF3guV1z8v9ww732dA1o9dX8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Rosenberg <drosen@google.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.2 039/171] f2fs: Lower threshold for disable_cp_again
Date:   Thu, 18 Jul 2019 23:54:30 -0400
Message-Id: <20190719035643.14300-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Rosenberg <drosen@google.com>

[ Upstream commit ae4ad7ea09d32ff1b6fb908ff12f8c1bd5241b29 ]

The existing threshold for allowable holes at checkpoint=disable time is
too high. The OVP space contains reserved segments, which are always in
the form of free segments. These must be subtracted from the OVP value.

The current threshold is meant to be the maximum value of holes of a
single type we can have and still guarantee that we can fill the disk
without failing to find space for a block of a given type.

If the disk is full, ignoring current reserved, which only helps us,
the amount of unused blocks is equal to the OVP area. Of that, there
are reserved segments, which must be free segments, and the rest of the
ovp area, which can come from either free segments or holes. The maximum
possible amount of holes is OVP-reserved.

Now, consider the disk when mounting with checkpoint=disable.
We must be able to fill all available free space with either data or
node blocks. When we start with checkpoint=disable, holes are locked to
their current type. Say we have H of one type of hole, and H+X of the
other. We can fill H of that space with arbitrary typed blocks via SSR.
For the remaining H+X blocks, we may not have any of a given block type
left at all. For instance, if we were to fill the disk entirely with
blocks of the type with fewer holes, the H+X blocks of the opposite type
would not be used. If H+X > OVP-reserved, there would be more holes than
could possibly exist, and we would have failed to find a suitable block
earlier on, leading to a crash in update_sit_entry.

If H+X <= OVP-reserved, then the holes end up effectively masked by the OVP
region in this case.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a96b9e964733..8903b61457e7 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -876,7 +876,9 @@ void f2fs_dirty_to_prefree(struct f2fs_sb_info *sbi)
 int f2fs_disable_cp_again(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
-	block_t ovp = overprovision_segments(sbi) << sbi->log_blocks_per_seg;
+	int ovp_hole_segs =
+		(overprovision_segments(sbi) - reserved_segments(sbi));
+	block_t ovp_holes = ovp_hole_segs << sbi->log_blocks_per_seg;
 	block_t holes[2] = {0, 0};	/* DATA and NODE */
 	struct seg_entry *se;
 	unsigned int segno;
@@ -891,10 +893,10 @@ int f2fs_disable_cp_again(struct f2fs_sb_info *sbi)
 	}
 	mutex_unlock(&dirty_i->seglist_lock);
 
-	if (holes[DATA] > ovp || holes[NODE] > ovp)
+	if (holes[DATA] > ovp_holes || holes[NODE] > ovp_holes)
 		return -EAGAIN;
 	if (is_sbi_flag_set(sbi, SBI_CP_DISABLED_QUICK) &&
-		dirty_segments(sbi) > overprovision_segments(sbi))
+		dirty_segments(sbi) > ovp_hole_segs)
 		return -EAGAIN;
 	return 0;
 }
-- 
2.20.1

