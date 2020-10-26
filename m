Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4914229A16E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441478AbgJ0Als (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408653AbgJZXtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70EEB2075B;
        Mon, 26 Oct 2020 23:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756158;
        bh=wJ7tx26oXbwyvOoGgHEzr8rD6oBnYrEO0hRZuOwrsRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7E0TKQI4k3G6BBMkBdxLTZnPorQpAc/BLrsFtdNflUvuni2ihbpWEDRHmlqQ6IUt
         l1rFYPF6zszV89o0+1OR4ixb3XKT5x3B2THOpnrAHuaDM+BBsu9oUf7NWM6Bj4DZAR
         yc5OaCyUI4xtAGgRZ0cu4KdSLVHDQLLQ+uwyWSWs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.9 010/147] f2fs: do sanity check on zoned block device path
Date:   Mon, 26 Oct 2020 19:46:48 -0400
Message-Id: <20201026234905.1022767-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 07eb1d699452de04e9d389ff17fb8fc9e975d7bf ]

sbi->devs would be initialized only if image enables multiple device
feature or blkzoned feature, if blkzoned feature flag was set by fuzz
in non-blkzoned device, we will suffer below panic:

get_zone_idx fs/f2fs/segment.c:4892 [inline]
f2fs_usable_zone_blks_in_seg fs/f2fs/segment.c:4943 [inline]
f2fs_usable_blks_in_seg+0x39b/0xa00 fs/f2fs/segment.c:4999
Call Trace:
 check_block_count+0x69/0x4e0 fs/f2fs/segment.h:704
 build_sit_entries fs/f2fs/segment.c:4403 [inline]
 f2fs_build_segment_manager+0x51da/0xa370 fs/f2fs/segment.c:5100
 f2fs_fill_super+0x3880/0x6ff0 fs/f2fs/super.c:3684
 mount_bdev+0x32e/0x3f0 fs/super.c:1417
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2896 [inline]
 path_mount+0x12ae/0x1e70 fs/namespace.c:3216
 do_mount fs/namespace.c:3229 [inline]
 __do_sys_mount fs/namespace.c:3437 [inline]
 __se_sys_mount fs/namespace.c:3414 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3414
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46

Add sanity check to inconsistency on factors: blkzoned flag, device
path and device character to avoid above panic.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index dfa072fa80815..be5050292caa5 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2832,6 +2832,12 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 					segment_count, dev_seg_count);
 			return -EFSCORRUPTED;
 		}
+	} else {
+		if (__F2FS_HAS_FEATURE(raw_super, F2FS_FEATURE_BLKZONED) &&
+					!bdev_is_zoned(sbi->sb->s_bdev)) {
+			f2fs_info(sbi, "Zoned block device path is missing");
+			return -EFSCORRUPTED;
+		}
 	}
 
 	if (secs_per_zone > total_sections || !secs_per_zone) {
-- 
2.25.1

