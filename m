Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A239B48420C
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 14:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbiADNFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 08:05:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiADNFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 08:05:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13B3A61365
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 13:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C349C36AE7;
        Tue,  4 Jan 2022 13:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641301518;
        bh=WQZf7CvnX1LxzlL0YMO3/J4eF+eJB21Yuse9m5LcN18=;
        h=From:To:Cc:Subject:Date:From;
        b=TNpouWFjDcQY2jfiaytG/RI02cQPN3FA9/ua67R2IpZ71C+d1axYGkA+EhVInc63p
         zNZsLnoHAP9f6xOZkTmic8zbQVo1bM/XWhsQnktvnfmTNv5dN0pzAow4J2ZJRglFDi
         6HlisIbmd18l6nXVJGZ6fz1OGKi1h6fGURLP6ou+HfZiADg2mV0qrF7Y1xgdxwaF6b
         rOSi+389iziMBWXdyoedq6yIpGi9YaiMZuqHhWY7nDog7geY8NztibvRIIugMo5S00
         oBSn5owSf1Zi4M2Sj4jfVbh76cI8vB0Jc0n+e8GxHMu4KZafXLC2dgWm908wmhWbvE
         csmwfluurojsg==
From:   Chao Yu <chao@kernel.org>
To:     stable@vger.kernel.org
Cc:     jaegeuk@kernel.org, chao@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Yi Zhuang <zhuangyi1@huawei.com>
Subject: [PATCH] f2fs: quota: fix potential deadlock
Date:   Tue,  4 Jan 2022 21:05:13 +0800
Message-Id: <20220104130513.3077-1-chao@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a5c0042200b28fff3bde6fa128ddeaef97990f8d upstream.

As Yi Zhuang reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=214299

There is potential deadlock during quota data flush as below:

Thread A:			Thread B:
f2fs_dquot_acquire
down_read(&sbi->quota_sem)
				f2fs_write_checkpoint
				block_operations
				f2fs_look_all
				down_write(&sbi->cp_rwsem)
f2fs_quota_write
f2fs_write_begin
__do_map_lock
f2fs_lock_op
down_read(&sbi->cp_rwsem)
				__need_flush_qutoa
				down_write(&sbi->quota_sem)

This patch changes block_operations() to use trylock, if it fails,
it means there is potential quota data updater, in this condition,
let's flush quota data first and then trylock again to check dirty
status of quota data.

The side effect is: in heavy race condition (e.g. multi quota data
upaters vs quota data flusher), it may decrease the probability of
synchronizing quota data successfully in checkpoint() due to limited
retry time of quota flush.

Fixes: db6ec53b7e03 ("f2fs: add a rw_sem to cover quota flag changes")
Cc: stable@vger.kernel.org # v5.3+
Reported-by: Yi Zhuang <zhuangyi1@huawei.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 83e9bc0f91ff..7b0282724231 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1162,7 +1162,8 @@ static bool __need_flush_quota(struct f2fs_sb_info *sbi)
 	if (!is_journalled_quota(sbi))
 		return false;
 
-	down_write(&sbi->quota_sem);
+	if (!down_write_trylock(&sbi->quota_sem))
+		return true;
 	if (is_sbi_flag_set(sbi, SBI_QUOTA_SKIP_FLUSH)) {
 		ret = false;
 	} else if (is_sbi_flag_set(sbi, SBI_QUOTA_NEED_REPAIR)) {
-- 
2.32.0

