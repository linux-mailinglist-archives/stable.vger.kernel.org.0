Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61DC40608C
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhIJARv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230060AbhIJARc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 335CD6023D;
        Fri, 10 Sep 2021 00:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232982;
        bh=9pN1/NsmF03j7sOApejhS8iz5KaF6E+5LzIyiCpZzlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCxzfxuR3/Qgxotr4O8R1lbn4Aje7UuwMF5oIeIUgHKOESgtvLDmsP75ub2Ww2plm
         fch/kMLq5V/33JX3yw+Dytju1yhawUdEQT2J8VagMIunbT+Ujv7TodHpsD8KQY7B6c
         syiebLIdEbdEhqobXhozIH9QVZgswGpkaAR4QxrrukD8lWwo3hko/acRPfv70k8K9S
         3c5JyoYIcylBVjsfvJ7952Akf/NkzBlNpivyLrdjzP0el+1V+J0XO66mKpZ5Tay/Lj
         Y2t3Or04Co4FdDCgpmjhQSmkCqj+QJzWJ/031pS1NgV01Qcps39zy1iYL5XOo9Sepg
         Nz/dp27GHdIfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia Yang <jiayang5@huawei.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.14 17/99] f2fs: Revert "f2fs: Fix indefinite loop in f2fs_gc() v1"
Date:   Thu,  9 Sep 2021 20:14:36 -0400
Message-Id: <20210910001558.173296-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia Yang <jiayang5@huawei.com>

[ Upstream commit 10d0786b39b3b91c4fbf8c2926e97ab456a4eea1 ]

This reverts commit 957fa47823dfe449c5a15a944e4e7a299a6601db.

The patch "f2fs: Fix indefinite loop in f2fs_gc()" v1 and v4 are all
merged. Patch v4 is test info for patch v1. Patch v1 doesn't work and
may cause that sbi->cur_victim_sec can't be resetted to NULL_SEGNO,
which makes SSR unable to get segment of sbi->cur_victim_sec.
So it should be reverted.

The mails record:
[1] https://lore.kernel.org/linux-f2fs-devel/7288dcd4-b168-7656-d1af-7e2cafa4f720@huawei.com/T/
[2] https://lore.kernel.org/linux-f2fs-devel/20190809153653.GD93481@jaegeuk-macbookpro.roam.corp.google.com/T/

Signed-off-by: Jia Yang <jiayang5@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 0e42ee5f7770..396b6f55ec24 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1747,7 +1747,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
 		round++;
 	}
 
-	if (gc_type == FG_GC && seg_freed)
+	if (gc_type == FG_GC)
 		sbi->cur_victim_sec = NULL_SEGNO;
 
 	if (sync)
-- 
2.30.2

