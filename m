Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B4D406369
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhIJArh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234643AbhIJAXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5505E610A3;
        Fri, 10 Sep 2021 00:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233364;
        bh=QQk5/NFDbpoB4CsO/Nl1x01d4DAt+VrGutOoBU8flU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvAStQW9pFxKVmYPDysJ6NZbC8neJEEVV6S2EplKHXogLy+u1S4FCzmvtimvWPLE8
         nPdy0GPQ3sxf8oIJbp7GnKPYWwDBmhiUPKbW4zyz1X31GAzdQQpb12Kl2VxOd7rhVC
         AIWCqxbL4+uomZJ0KtZpzMn0+F0xZZ2fVvFs+VM9CfIygnONkVqr8WYgxxTt/c3djV
         4J8w5KR9+ISGkJEPa2zabqbAeTDeaKHbB8uqGFqUG3dH7RDNJ/5xRnlAnpJpNIEr91
         WGeZdJNWUUM1/wWQAYsPDeVAJvyU8or0S744nYaZRMFjojZKpmQ06e7MUh/J+4mWOR
         RtUr56ki33coA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laibin Qiu <qiulaibin@huawei.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 07/25] f2fs: fix min_seq_blocks can not make sense in some scenes.
Date:   Thu,  9 Sep 2021 20:22:15 -0400
Message-Id: <20210910002234.176125-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002234.176125-1-sashal@kernel.org>
References: <20210910002234.176125-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laibin Qiu <qiulaibin@huawei.com>

[ Upstream commit dc675a97129c4d9d5af55a3d7f23d7e092b8e032 ]

F2FS have dirty page count control for batched sequential
write in writepages, and get the value of min_seq_blocks by
blocks_per_seg * segs_per_sec(segs_per_sec defaults to 1).
But in some scenes we set a lager section size, Min_seq_blocks
will become too large to achieve the expected effect(eg. 4thread
sequential write, the number of merge requests will be reduced).

Signed-off-by: Laibin Qiu <qiulaibin@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 0e3e590a250f..0ac907b06cb1 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4198,7 +4198,7 @@ int f2fs_build_segment_manager(struct f2fs_sb_info *sbi)
 		sm_info->ipu_policy = 1 << F2FS_IPU_FSYNC;
 	sm_info->min_ipu_util = DEF_MIN_IPU_UTIL;
 	sm_info->min_fsync_blocks = DEF_MIN_FSYNC_BLOCKS;
-	sm_info->min_seq_blocks = sbi->blocks_per_seg * sbi->segs_per_sec;
+	sm_info->min_seq_blocks = sbi->blocks_per_seg;
 	sm_info->min_hot_blocks = DEF_MIN_HOT_BLOCKS;
 	sm_info->min_ssr_sections = reserved_sections(sbi);
 
-- 
2.30.2

