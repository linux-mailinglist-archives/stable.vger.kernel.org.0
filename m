Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9EC6A855D
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 16:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjCBPgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 10:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjCBPgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 10:36:39 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D733B651
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 07:36:29 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id i28so9905588lfv.0
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 07:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677771388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xPP3HXcCysfTznKsDYThrcBwtl/yG8ZLYuAVSZJtJ+o=;
        b=xdv5/7ylluaW3v2WHm00b1OBIYqoIirvCXVySNdVpvERx7L9jAqYcDxPVx8FDDCBO0
         fOtWyr9llberWp31txlJjjvV0GlGXeFFN6o3rszBGThkl/Qa6Et90HUAX5pZvBI7ABWY
         8hDCjzIxf82i5tOGFzKndrK/uF7lJ9LQTcO8lapnOyOyhlUw00J0739fUp8iQR69J7Ch
         8X0sMGCGb9S6Rk1jluOjLw6G8bT/zqQD4+FC/MOIRZvvW6XjNecX3UGlz7c1BTlvXZZn
         hj5S6GEMtQlJ1VHq0TC7Tdt4YuOWBg3yb93cLSH0zqdWafPKJcIAv/Gac7lJOOja72qL
         zFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677771388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xPP3HXcCysfTznKsDYThrcBwtl/yG8ZLYuAVSZJtJ+o=;
        b=tdAUGgaCM2E7LdpacFf1U32Ejtk3FmAKLiFrNDHlWSJJ+MvV2ejqriXIfx55tlTupp
         86bA55WzmE/uL+sIErmCluF7rm4LCAEssQ+sDmvUK8qhmUlMmdkoClX5yr0s7djN4bi1
         spkvM7qOocW+P+U4S+8Iv+XBuNa9L6i+2gqbTg5A/8B29/OckUDvpTFxD6V5uraT/1dt
         DfXRC7ztpMkXUuz/ZOfEkkARPmBnLkJXElfz2rxvc5GXdTIjFncWY3MbTPv82KqMmTWJ
         YxZejfWBZooKqjduQbGn4iKKLaRbbGMHzwd812eo/M44j7WTWwKqz5zrk/PoUgGo8c2h
         jDVg==
X-Gm-Message-State: AO0yUKWabuiU8jX4E9oRQ/WYuFPdhTKuZOXayc96Yg4Hcft+Hqr8uYV5
        OTX4DpNsy1alukyvKJeV6XcPESFhh90nf/ZT
X-Google-Smtp-Source: AK7set93ZYW1xBaJdP9TfUcpnqshkEhG0x6bOeCHFRSevglUZ/k28gZkEwXDaNLfG3E4qRUrgCVDEg==
X-Received: by 2002:ac2:5330:0:b0:4e1:46e9:ec3e with SMTP id f16-20020ac25330000000b004e146e9ec3emr2826110lfh.61.1677771387836;
        Thu, 02 Mar 2023 07:36:27 -0800 (PST)
Received: from ta1.c.googlers.com.com (61.215.228.35.bc.googleusercontent.com. [35.228.215.61])
        by smtp.gmail.com with ESMTPSA id p17-20020a05651238d100b004db2978e330sm2170509lft.258.2023.03.02.07.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 07:36:27 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     stable@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com, Lukas Czerner <lczerner@redhat.com>,
        syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH][for stable 5.{15, 10} 4/4] ext4: block range must be validated before use in ext4_mb_clear_bb()
Date:   Thu,  2 Mar 2023 15:36:10 +0000
Message-Id: <20230302153610.1204653-5-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230302153610.1204653-1-tudor.ambarus@linaro.org>
References: <20230302153610.1204653-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

[ Upstream commit 1e1c2b86ef86a8477fd9b9a4f48a6bfe235606f6 ]

Block range to free is validated in ext4_free_blocks() using
ext4_inode_block_valid() and then it's passed to ext4_mb_clear_bb().
However in some situations on bigalloc file system the range might be
adjusted after the validation in ext4_free_blocks() which can lead to
troubles on corrupted file systems such as one found by syzkaller that
resulted in the following BUG

kernel BUG at fs/ext4/ext4.h:3319!
PREEMPT SMP NOPTI
CPU: 28 PID: 4243 Comm: repro Kdump: loaded Not tainted 5.19.0-rc6+ #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
RIP: 0010:ext4_free_blocks+0x95e/0xa90
Call Trace:
 <TASK>
 ? lock_timer_base+0x61/0x80
 ? __es_remove_extent+0x5a/0x760
 ? __mod_timer+0x256/0x380
 ? ext4_ind_truncate_ensure_credits+0x90/0x220
 ext4_clear_blocks+0x107/0x1b0
 ext4_free_data+0x15b/0x170
 ext4_ind_truncate+0x214/0x2c0
 ? _raw_spin_unlock+0x15/0x30
 ? ext4_discard_preallocations+0x15a/0x410
 ? ext4_journal_check_start+0xe/0x90
 ? __ext4_journal_start_sb+0x2f/0x110
 ext4_truncate+0x1b5/0x460
 ? __ext4_journal_start_sb+0x2f/0x110
 ext4_evict_inode+0x2b4/0x6f0
 evict+0xd0/0x1d0
 ext4_enable_quotas+0x11f/0x1f0
 ext4_orphan_cleanup+0x3de/0x430
 ? proc_create_seq_private+0x43/0x50
 ext4_fill_super+0x295f/0x3ae0
 ? snprintf+0x39/0x40
 ? sget_fc+0x19c/0x330
 ? ext4_reconfigure+0x850/0x850
 get_tree_bdev+0x16d/0x260
 vfs_get_tree+0x25/0xb0
 path_mount+0x431/0xa70
 __x64_sys_mount+0xe2/0x120
 do_syscall_64+0x5b/0x80
 ? do_user_addr_fault+0x1e2/0x670
 ? exc_page_fault+0x70/0x170
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fdf4e512ace

Fix it by making sure that the block range is properly validated before
used every time it changes in ext4_free_blocks() or ext4_mb_clear_bb().

Link: https://syzkaller.appspot.com/bug?id=5266d464285a03cee9dbfda7d2452a72c3c2ae7c
Reported-by: syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Tested-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Link: https://lore.kernel.org/r/20220714165903.58260-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 fs/ext4/mballoc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7b4359862a60..e6718bfc6c55 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5916,6 +5916,15 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 
 	sbi = EXT4_SB(sb);
 
+	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
+	    !ext4_inode_block_valid(inode, block, count)) {
+		ext4_error(sb, "Freeing blocks in system zone - "
+			   "Block = %llu, count = %lu", block, count);
+		/* err = 0. ext4_std_error should be a no op */
+		goto error_return;
+	}
+	flags |= EXT4_FREE_BLOCKS_VALIDATED;
+
 do_more:
 	overflow = 0;
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
@@ -5932,6 +5941,8 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 		overflow = EXT4_C2B(sbi, bit) + count -
 			EXT4_BLOCKS_PER_GROUP(sb);
 		count -= overflow;
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 	count_clusters = EXT4_NUM_B2C(sbi, count);
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
@@ -5946,7 +5957,8 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 		goto error_return;
 	}
 
-	if (!ext4_inode_block_valid(inode, block, count)) {
+	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
+	    !ext4_inode_block_valid(inode, block, count)) {
 		ext4_error(sb, "Freeing blocks in system zone - "
 			   "Block = %llu, count = %lu", block, count);
 		/* err = 0. ext4_std_error should be a no op */
@@ -6069,6 +6081,8 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 		block += count;
 		count = overflow;
 		put_bh(bitmap_bh);
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 		goto do_more;
 	}
 error_return:
@@ -6115,6 +6129,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			   "block = %llu, count = %lu", block, count);
 		return;
 	}
+	flags |= EXT4_FREE_BLOCKS_VALIDATED;
 
 	ext4_debug("freeing block %llu\n", block);
 	trace_ext4_free_blocks(inode, block, count, flags);
@@ -6146,6 +6161,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			block -= overflow;
 			count += overflow;
 		}
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 	overflow = EXT4_LBLK_COFF(sbi, count);
 	if (overflow) {
@@ -6156,6 +6173,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 				return;
 		} else
 			count += sbi->s_cluster_ratio - overflow;
+		/* The range changed so it's no longer validated */
+		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
 
 	if (!bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

