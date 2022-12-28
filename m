Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8259A657B81
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbiL1PXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbiL1PWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF274140BA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BA5261544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDACC433D2;
        Wed, 28 Dec 2022 15:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240940;
        bh=Zi8O9t420gNKOhNMdn4jrylDdiDle4Pac//PLNkysZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgtXns/37nUjBqDlCTo2mdImBFismm8fSc9dmgl53AqKqa253bOKcbz5mZdsIY+7P
         g0sgBDdgXtMrim8oTEXB5ntn25xPxwv2KUfdVc0ypETNOs2QV5UFtODS+AjrAPxVck
         ZYqPGr//OtkXIWYE83+fv31S70vcSEVPwuUEUkoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yonggil Song <yonggil.song@samsung.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 419/731] f2fs: avoid victim selection from previous victim section
Date:   Wed, 28 Dec 2022 15:38:46 +0100
Message-Id: <20221228144308.717034591@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonggil Song <yonggil.song@samsung.com>

[ Upstream commit e219aecfd4b766c4e878a3769057e9809f7fcadc ]

When f2fs chooses GC victim in large section & LFS mode,
next_victim_seg[gc_type] is referenced first. After segment is freed,
next_victim_seg[gc_type] has the next segment number.
However, next_victim_seg[gc_type] still has the last segment number
even after the last segment of section is freed. In this case, when f2fs
chooses a victim for the next GC round, the last segment of previous victim
section is chosen as a victim.

Initialize next_victim_seg[gc_type] to NULL_SEGNO for the last segment in
large section.

Fixes: e3080b0120a1 ("f2fs: support subsectional garbage collection")
Signed-off-by: Yonggil Song <yonggil.song@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 4cbaa6ab083f..7863f8fd3b95 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1673,8 +1673,9 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 				get_valid_blocks(sbi, segno, false) == 0)
 			seg_freed++;
 
-		if (__is_large_section(sbi) && segno + 1 < end_segno)
-			sbi->next_victim_seg[gc_type] = segno + 1;
+		if (__is_large_section(sbi))
+			sbi->next_victim_seg[gc_type] =
+				(segno + 1 < end_segno) ? segno + 1 : NULL_SEGNO;
 skip:
 		f2fs_put_page(sum_page, 0);
 	}
-- 
2.35.1



