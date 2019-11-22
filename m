Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D5A106540
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfKVGXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:23:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbfKVFvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0916520717;
        Fri, 22 Nov 2019 05:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401910;
        bh=pnHoMJ/VIf/bpAE19w6W//LfMUwzElYtDIiJ9wLpwgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVpGJBIFVn9ld64xGBlidcb1MVObsr3xoN5VZeHEw3BojbKasOoWgHvZzvT8HspwT
         SxNFD44RR/9DN4U6ZaidiTDa+ysR7PIycotTimvc05BqzBn8GRexr5J7G0MyCf7qhG
         auL0SqARIlpdOlIeg1irbs6IBU/WN59fBpFLR1to=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiuyang Sun <sunqiuyang@huawei.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 141/219] f2fs: fix block address for __check_sit_bitmap
Date:   Fri, 22 Nov 2019 00:47:53 -0500
Message-Id: <20191122054911.1750-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiuyang Sun <sunqiuyang@huawei.com>

[ Upstream commit 9249dded7b5cb539a8c8698b25d08a3c15261470 ]

Should use lstart (logical start address) instead of start (in dev) here.
This fixes a bug in multi-device scenarios.

Signed-off-by: Qiuyang Sun <sunqiuyang@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 10d5dcdb34be6..01cb87b12d40b 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1101,7 +1101,7 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 		list_move_tail(&dc->list, wait_list);
 
 		/* sanity check on discard range */
-		__check_sit_bitmap(sbi, start, start + len);
+		__check_sit_bitmap(sbi, lstart, lstart + len);
 
 		bio->bi_private = dc;
 		bio->bi_end_io = f2fs_submit_discard_endio;
-- 
2.20.1

