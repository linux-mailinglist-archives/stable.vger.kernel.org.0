Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3DD30510B
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 05:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239290AbhA0Ejm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 23:39:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405343AbhA0BpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 20:45:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA88A2054F;
        Wed, 27 Jan 2021 01:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611711878;
        bh=lBJ53K92hVK0EqvlqjcltcmGpAoUSsWhlw7eSkvYepk=;
        h=From:To:Cc:Subject:Date:From;
        b=f76QWS5jEXBltyE8jd6AavYiRTRZn17b4d4jWDQgMP1InELKx+JnuzOcXz48lfSSj
         PgaXhEb85GCQI8a7nK/Tc/5rQQ7oMinj5AbzDJn8KjfsgaYtnKnyF5sEHt0X/bpnWI
         inNsv7NKHuw5aXHUoVrbQ8MtU0ozBVbL2js8eSlS/jZkejqvkMWUxZcl/w+foVGCGv
         lb86fwJiCHNuIVHHN2TL5YGsFhRJTWZSAxFVGQEM+gW8YXDdgwN2WabOV2aUm06R4y
         65ab/9S2eMm6K35NaxwVmP8oFQxJz1zlbY1WYTG5hIk3PbXvBu9IONSqZtvO3+V9gI
         64dBDUN9tOWuA==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] f2fs: flush data when enabling checkpoint back
Date:   Tue, 26 Jan 2021 17:44:34 -0800
Message-Id: <20210127014434.3431893-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During checkpoint=disable period, f2fs bypasses all the synchronous IOs such as
sync and fsync. So, when enabling it back, we must flush all of them in order
to keep the data persistent. Otherwise, suddern power-cut right after enabling
checkpoint will cause data loss.

Fixes: 4354994f097d ("f2fs: checkpoint disabling")
Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 359cc5a2f8f5..073b51af62c8 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1887,6 +1887,9 @@ static int f2fs_disable_checkpoint(struct f2fs_sb_info *sbi)
 
 static void f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
 {
+	/* we should flush all the data to keep data consistency */
+	sync_inodes_sb(sbi->sb);
+
 	down_write(&sbi->gc_lock);
 	f2fs_dirty_to_prefree(sbi);
 
-- 
2.30.0.280.ga3ce27912f-goog

