Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3741134C968
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhC2I3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234041AbhC2I1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EC04619B1;
        Mon, 29 Mar 2021 08:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006392;
        bh=bYcSuwf76wKELwNvz/lNKM+CZvDdOnA/sw+MIR5doo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRUQfqHhi4PNXNcwyr1W+lQJnVsz0Eufq7MSlaqpHOqgIx5WJONZZEwFAezJoBI3l
         DHQ+VllRoIn/4zlYsj0YhxoKgndRt4HFwt6E1ASNdMQDmKb1XOQxFEtaT8GHyFXVmr
         5HQLqOoBOsfijJzNms5n3Vov6RYmcJMEnVI8KzDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a8b4b0c60155e87e9484@syzkaller.appspotmail.com,
        Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 217/221] fs/ext4: fix integer overflow in s_log_groups_per_flex
Date:   Mon, 29 Mar 2021 09:59:08 +0200
Message-Id: <20210329075636.375839941@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>

commit f91436d55a279f045987e8b8c1385585dca54be9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2732,8 +2732,15 @@ static int ext4_mb_init_backend(struct s
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


