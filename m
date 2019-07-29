Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9350A797D3
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390261AbfG2Tq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390253AbfG2Tq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91C0D217D7;
        Mon, 29 Jul 2019 19:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429616;
        bh=OtzW4CKIhAYvYgoyCLB/0s+UvNbGRnoyQOxFludyc+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiPgteVdFpWmaCj10i+9t/Pq4JWl11SV7/3NvAbFsgV5d7l+WM2snxHd2j38YPmIC
         19DNw1Q56aIEoiDDA7sOA5EvtMWxma9AVkRx6ZRFCMdqQkBi+/AwYxVnowOSTiZZ4f
         vBG4vtpmQMVv4vwEwUNBzVnFP6f3YGIG9QnWYcp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 041/215] f2fs: Lower threshold for disable_cp_again
Date:   Mon, 29 Jul 2019 21:20:37 +0200
Message-Id: <20190729190747.638974132@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



