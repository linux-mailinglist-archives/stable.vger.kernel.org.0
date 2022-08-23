Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E906C59D9F5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352022AbiHWKEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352434AbiHWKBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D87163F25;
        Tue, 23 Aug 2022 01:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C732B81C5F;
        Tue, 23 Aug 2022 08:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EC7C433D6;
        Tue, 23 Aug 2022 08:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243688;
        bh=nIcfzrungjtKw7y6HO2FvmCrIPM7rRA9aRlAm5poON0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNRn40+u9fx9QCdCNQEp5e+euBg4J3urz8M4GIsI0qmyxw3Qs6ZEueI3am0t4QG/T
         88BsSyDgmRjpuCqj1Kp4XoY9LznOUZyaqpvfU6/CY1UF8+4rmtk2Cksdb59t847vf9
         KuChM+FAJ/sleNJhL2F8BZQfE6ZxufnfqE23/nvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenqing Liu <wenqingliu0120@gmail.com>,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 356/365] f2fs: fix to do sanity check on segment type in build_sit_entries()
Date:   Tue, 23 Aug 2022 10:04:17 +0200
Message-Id: <20220823080133.179539706@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao.yu@oppo.com>

[ Upstream commit 09beadf289d6e300553e60d6e76f13c0427ecab3 ]

As Wenqing Liu <wenqingliu0120@gmail.com> reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=216285

RIP: 0010:memcpy_erms+0x6/0x10
 f2fs_update_meta_page+0x84/0x570 [f2fs]
 change_curseg.constprop.0+0x159/0xbd0 [f2fs]
 f2fs_do_replace_block+0x5c7/0x18a0 [f2fs]
 f2fs_replace_block+0xeb/0x180 [f2fs]
 recover_data+0x1abd/0x6f50 [f2fs]
 f2fs_recover_fsync_data+0x12ce/0x3250 [f2fs]
 f2fs_fill_super+0x4459/0x6190 [f2fs]
 mount_bdev+0x2cf/0x3b0
 legacy_get_tree+0xed/0x1d0
 vfs_get_tree+0x81/0x2b0
 path_mount+0x47e/0x19d0
 do_mount+0xce/0xf0
 __x64_sys_mount+0x12c/0x1a0
 do_syscall_64+0x38/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The root cause is segment type is invalid, so in f2fs_do_replace_block(),
f2fs accesses f2fs_sm_info::curseg_array with out-of-range segment type,
result in accessing invalid curseg->sum_blk during memcpy in
f2fs_update_meta_page(). Fix this by adding sanity check on segment type
in build_sit_entries().

Reported-by: Wenqing Liu <wenqingliu0120@gmail.com>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 874c1b9c41a2..ac890c9fa8a1 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4362,6 +4362,12 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 				return err;
 			seg_info_from_raw_sit(se, &sit);
 
+			if (se->type >= NR_PERSISTENT_LOG) {
+				f2fs_err(sbi, "Invalid segment type: %u, segno: %u",
+							se->type, start);
+				return -EFSCORRUPTED;
+			}
+
 			sit_valid_blocks[SE_PAGETYPE(se)] += se->valid_blocks;
 
 			if (f2fs_block_unit_discard(sbi)) {
@@ -4410,6 +4416,13 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 			break;
 		seg_info_from_raw_sit(se, &sit);
 
+		if (se->type >= NR_PERSISTENT_LOG) {
+			f2fs_err(sbi, "Invalid segment type: %u, segno: %u",
+							se->type, start);
+			err = -EFSCORRUPTED;
+			break;
+		}
+
 		sit_valid_blocks[SE_PAGETYPE(se)] += se->valid_blocks;
 
 		if (f2fs_block_unit_discard(sbi)) {
-- 
2.35.1



