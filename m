Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31403594672
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351974AbiHOW5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352458AbiHOWzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:55:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A2B3C17B;
        Mon, 15 Aug 2022 12:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34ABCB81136;
        Mon, 15 Aug 2022 19:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EB6C433D6;
        Mon, 15 Aug 2022 19:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593321;
        bh=2zp/vsUDwQiyqPlsyHNvN09ZapKjPGhKIbd11SKCAQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haPRck2yE/BvlRNPuHh5Gv963SrsLC2G+DP/lvT/09BNvi7VWkHehHP2mcnmWKTKB
         HJeKAJJBn4dR9npJ4yrdFOp63dsmFpFwPvMTBSl4viyeRlCVdbEAeEWferjvzt/LeM
         Kuw+8tQbYBP2qr4QQ7rQJIcxBy0qjZvFN7l0a8FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Byungki Lee <dominicus79@gmail.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0929/1095] f2fs: write checkpoint during FG_GC
Date:   Mon, 15 Aug 2022 20:05:28 +0200
Message-Id: <20220815180507.671856275@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Byungki Lee <dominicus79@gmail.com>

[ Upstream commit a9163b947ae8f7af7cb8d63606cd87b9facbfe74 ]

If there's not enough free sections each of which consistis of large segments,
we can hit no free section for upcoming section allocation. Let's reclaim some
prefree segments by writing checkpoints.

Signed-off-by: Byungki Lee <dominicus79@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 6a7e4148ff9d..a193862ad8a5 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1790,23 +1790,31 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
 	if (sync)
 		goto stop;
 
-	if (has_not_enough_free_secs(sbi, sec_freed, 0)) {
-		if (skipped_round <= MAX_SKIP_GC_COUNT ||
-					skipped_round * 2 < round) {
-			segno = NULL_SEGNO;
-			goto gc_more;
-		}
+	if (!has_not_enough_free_secs(sbi, sec_freed, 0))
+		goto stop;
 
-		if (first_skipped < last_skipped &&
-				(last_skipped - first_skipped) >
-						sbi->skipped_gc_rwsem) {
-			f2fs_drop_inmem_pages_all(sbi, true);
-			segno = NULL_SEGNO;
-			goto gc_more;
-		}
-		if (gc_type == FG_GC && !is_sbi_flag_set(sbi, SBI_CP_DISABLED))
+	if (skipped_round <= MAX_SKIP_GC_COUNT || skipped_round * 2 < round) {
+
+		/* Write checkpoint to reclaim prefree segments */
+		if (free_sections(sbi) < NR_CURSEG_PERSIST_TYPE &&
+				prefree_segments(sbi) &&
+				!is_sbi_flag_set(sbi, SBI_CP_DISABLED)) {
 			ret = f2fs_write_checkpoint(sbi, &cpc);
-	}
+			if (ret)
+				goto stop;
+		}
+		segno = NULL_SEGNO;
+		goto gc_more;
+	}
+	if (first_skipped < last_skipped &&
+			(last_skipped - first_skipped) >
+					sbi->skipped_gc_rwsem) {
+		f2fs_drop_inmem_pages_all(sbi, true);
+		segno = NULL_SEGNO;
+		goto gc_more;
+	}
+	if (gc_type == FG_GC && !is_sbi_flag_set(sbi, SBI_CP_DISABLED))
+		ret = f2fs_write_checkpoint(sbi, &cpc);
 stop:
 	SIT_I(sbi)->last_victim[ALLOC_NEXT] = 0;
 	SIT_I(sbi)->last_victim[FLUSH_DEVICE] = init_segno;
-- 
2.35.1



