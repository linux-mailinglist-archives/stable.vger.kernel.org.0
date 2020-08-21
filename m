Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFCD24DE0B
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgHUQPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgHUQPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F231320FC3;
        Fri, 21 Aug 2020 16:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026506;
        bh=0Bpcya60q0A12JUTmhkO1fZ82j89VNCVsocOmSZltpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jykAIrvyTIDIEtMSBurqgfCGeQGuMDXsxoa1w5h+VdSaJbmDTTev9BkdpYnl7cl4G
         2HRiCeE4kJnimO2HZsKIMCba/wXNJ3LNnMrTqOup4dAl5peBOFWqYOkDRW5zjkooXN
         386pT2VvWEdxRKJzbytMHgBQdQQABBtx8cenmkzA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dehe Gu <gudehe@huawei.com>,
        Daiyue Zhang <zhangdaiyue1@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.8 34/62] f2fs: remove write attribute of main_blkaddr sysfs node
Date:   Fri, 21 Aug 2020 12:13:55 -0400
Message-Id: <20200821161423.347071-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dehe Gu <gudehe@huawei.com>

[ Upstream commit ffcde4b29a5f20ddca6fe559b48f345818bf1d91 ]

Fuzzing main_blkaddr sysfs node will corrupt this field's value,
causing kernel panic, remove its write attribute to avoid potential
security risk.

[Chao Yu: add description]

Signed-off-by: Dehe Gu <gudehe@huawei.com>
Signed-off-by: Daiyue Zhang <zhangdaiyue1@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index e877c59b9fdb4..c5e32ceb94827 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -223,6 +223,13 @@ static ssize_t avg_vblocks_show(struct f2fs_attr *a,
 }
 #endif
 
+static ssize_t main_blkaddr_show(struct f2fs_attr *a,
+				struct f2fs_sb_info *sbi, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)MAIN_BLKADDR(sbi));
+}
+
 static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 			struct f2fs_sb_info *sbi, char *buf)
 {
@@ -522,7 +529,6 @@ F2FS_RW_ATTR(GC_THREAD, f2fs_gc_kthread, gc_no_gc_sleep_time, no_gc_sleep_time);
 F2FS_RW_ATTR(F2FS_SBI, f2fs_sb_info, gc_idle, gc_mode);
 F2FS_RW_ATTR(F2FS_SBI, f2fs_sb_info, gc_urgent, gc_mode);
 F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, reclaim_segments, rec_prefree_segments);
-F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, main_blkaddr, main_blkaddr);
 F2FS_RW_ATTR(DCC_INFO, discard_cmd_control, max_small_discards, max_discards);
 F2FS_RW_ATTR(DCC_INFO, discard_cmd_control, discard_granularity, discard_granularity);
 F2FS_RW_ATTR(RESERVED_BLOCKS, f2fs_sb_info, reserved_blocks, reserved_blocks);
@@ -565,6 +571,7 @@ F2FS_GENERAL_RO_ATTR(current_reserved_blocks);
 F2FS_GENERAL_RO_ATTR(unusable);
 F2FS_GENERAL_RO_ATTR(encoding);
 F2FS_GENERAL_RO_ATTR(mounted_time_sec);
+F2FS_GENERAL_RO_ATTR(main_blkaddr);
 #ifdef CONFIG_F2FS_STAT_FS
 F2FS_STAT_ATTR(STAT_INFO, f2fs_stat_info, cp_foreground_calls, cp_count);
 F2FS_STAT_ATTR(STAT_INFO, f2fs_stat_info, cp_background_calls, bg_cp_count);
-- 
2.25.1

