Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017DA348F46
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhCYL0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230454AbhCYL0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98BB461A40;
        Thu, 25 Mar 2021 11:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671565;
        bh=Mt6G52iae64dYrqxazAuw/X/M6QX44n0P3480azS3Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFiI9+BeqWhiGZSFTsfUANsFMlHMZ4/uEaKIPoRJjST4aIfu7JrAiN8uZwvb0rD8W
         C/ZDVBDnvnUVvVXLxc2j+l9c1x/cacBNf1G/gdvri2UJe29a4BE/Yvh1b3KvL98kWb
         25K6N6dDOuTB7bdZrv4L/176FO8U9CMKL61KSVGp22zVytHmo0Ubg0tOJ0wfqK1yYI
         XTNR0PuUBV9omfhvaXnC6g+bG9RUm0P9RmZqPhIhIXr9sw3befx83x3RoB+Id2NbkS
         eg15YmYedqfllRzMi91L23OGxdgAlWTGQ3HmwR6YIAeVo5LUrMJTNNf+Y71lcC+RdP
         JK3frgJOObQ0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        syzbot+a8b4b0c60155e87e9484@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/39] fs/ext4: fix integer overflow in s_log_groups_per_flex
Date:   Thu, 25 Mar 2021 07:25:23 -0400
Message-Id: <20210325112558.1927423-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

[ Upstream commit f91436d55a279f045987e8b8c1385585dca54be9 ]

syzbot found UBSAN: shift-out-of-bounds in ext4_mb_init [1], when
1 << sbi->s_es->s_log_groups_per_flex is bigger than UINT_MAX,
where sbi->s_mb_prefetch is unsigned integer type.

32 is the maximum allowed power of s_log_groups_per_flex. Following if
check will also trigger UBSAN shift-out-of-bound:

if (1 << sbi->s_es->s_log_groups_per_flex >= UINT_MAX) {

So I'm checking it against the raw number, perhaps there is another way
to calculate UINT_MAX max power. Also use min_t as to make sure it's
uint type.

[1] UBSAN: shift-out-of-bounds in fs/ext4/mballoc.c:2713:24
shift exponent 60 is too large for 32-bit type 'int'
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x137/0x1be lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:148 [inline]
 __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
 ext4_mb_init_backend fs/ext4/mballoc.c:2713 [inline]
 ext4_mb_init+0x19bc/0x19f0 fs/ext4/mballoc.c:2898
 ext4_fill_super+0xc2ec/0xfbe0 fs/ext4/super.c:4983

Reported-by: syzbot+a8b4b0c60155e87e9484@syzkaller.appspotmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210224095800.3350002-1-snovitoll@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e67d5de6f28c..b6229fe1aa23 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2732,8 +2732,15 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	}
 
 	if (ext4_has_feature_flex_bg(sb)) {
-		/* a single flex group is supposed to be read by a single IO */
-		sbi->s_mb_prefetch = min(1 << sbi->s_es->s_log_groups_per_flex,
+		/* a single flex group is supposed to be read by a single IO.
+		 * 2 ^ s_log_groups_per_flex != UINT_MAX as s_mb_prefetch is
+		 * unsigned integer, so the maximum shift is 32.
+		 */
+		if (sbi->s_es->s_log_groups_per_flex >= 32) {
+			ext4_msg(sb, KERN_ERR, "too many log groups per flexible block group");
+			goto err_freesgi;
+		}
+		sbi->s_mb_prefetch = min_t(uint, 1 << sbi->s_es->s_log_groups_per_flex,
 			BLK_MAX_SEGMENT_SIZE >> (sb->s_blocksize_bits - 9));
 		sbi->s_mb_prefetch *= 8; /* 8 prefetch IOs in flight at most */
 	} else {
-- 
2.30.1

