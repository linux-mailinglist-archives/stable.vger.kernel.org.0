Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6021259246D
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242531AbiHNQcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242749AbiHNQbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:31:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00DB13F79;
        Sun, 14 Aug 2022 09:25:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BF73B80B7F;
        Sun, 14 Aug 2022 16:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE0DC43141;
        Sun, 14 Aug 2022 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494352;
        bh=UXrvQ85jeUzk4EXykGsxWHwVxHqjVXFyQ60c+WCIULc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHbBpT2MHsqCIMMyEYfh6JO/d4M9yjBsXIxMDAkQFDvN59yHOMkhhlldxBtIEd8Lh
         yB1aXzSi+FxXl7WwQjYNwKrFUbjqu6mvb49XjsxLbT2UclrCr68/7Z0he0vxtAXTXU
         48dyAtmZxJNXNKQEwP65Qv5XkMo7uvNUKGuHq6CQbwzV5uqow60+dgP4QPFDLP5tUf
         MQFd9FP4jn2S2PDd5KrCm6UJc1eBoCOdNqIXa8/Bm5FblNpT20UbFmTk8Kz0rYJHUl
         /i59ySJ3JIoSzieL0emyIAExkpgb/5ZoYZC+eAb4CA+zh9oz8+9+cKn+fXDvxBM0/I
         DGR0gJxefYTbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao.yu@oppo.com>, Wenqing Liu <wenqingliu0120@gmail.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, chao@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.18 34/39] f2fs: fix to do sanity check on segment type in build_sit_entries()
Date:   Sun, 14 Aug 2022 12:23:23 -0400
Message-Id: <20220814162332.2396012-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index aa0162664a1e..15c72bfca692 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4486,6 +4486,12 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
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
@@ -4534,6 +4540,13 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
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

