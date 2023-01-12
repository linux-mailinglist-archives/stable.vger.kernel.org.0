Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEE66675C5
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbjALOYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbjALOYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:24:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E2E52C69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:16:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C37962030
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B0FC433EF;
        Thu, 12 Jan 2023 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532965;
        bh=+WB8CWgk8t1iNvOJK7KthbFFj9Frk7cmHenieULkru8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Py+N3l0STLW0JM2BvjgK8fCInACv9cgUl6iTuoNSPevYA2hSwsE5EsdDLRcSJChoo
         7dcRmLgtsoki8Fh2zrfowNAVt57iZ6plIiRhUT0Ne+SqkgYtOz5rXecfjofUZ/dWq1
         7ueR+p+fwP9C771gMchTW+JtDqUfuSptrmt4KzXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yonggil Song <yonggil.song@samsung.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 327/783] f2fs: avoid victim selection from previous victim section
Date:   Thu, 12 Jan 2023 14:50:43 +0100
Message-Id: <20230112135539.463752407@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 5ac0b605335f..89156568a4fb 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1649,8 +1649,9 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
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



