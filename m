Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D504061E2
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhIJAoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233340AbhIJATt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BFA46023D;
        Fri, 10 Sep 2021 00:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233119;
        bh=8HublyiwEV4fCI0eq4NiQnN+jf5XNaik78Qk8UPkgPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tw0wfEp8Y7JZl4deljtwIxl8P4bdELPWBRhMK4FFZPVnHt+j4zlsYhF2puoigMWpR
         b4lSa6iF8lv0rMDAj3WAxzw9esH2rxJJvqRtP5SuRC5ZD/yHrkZ127rIEqb6xBZegt
         vVL/dJj41lcxx2X5O0vhvubkPgSc69dAf+tkM87lmSgV9mauoAyDlJLOq5BpX29847
         TJuJBlenqRxvXLvzrWLtcweUke8eoW8uq0o2XvSHVgICQ5SfNnJuTw93xPuuSD5iik
         TpHa8rXG2G4JttH7h6p4YUC2R5sG4+WYqq4sgqZG1urHmZ+oPv3oqENgsgVtcXav7U
         il01/sZNg7MIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia Yang <jiayang5@huawei.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.13 13/88] f2fs: Revert "f2fs: Fix indefinite loop in f2fs_gc() v1"
Date:   Thu,  9 Sep 2021 20:17:05 -0400
Message-Id: <20210910001820.174272-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index ab63951c08cb..a6857f094522 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1746,7 +1746,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
 		round++;
 	}
 
-	if (gc_type == FG_GC && seg_freed)
+	if (gc_type == FG_GC)
 		sbi->cur_victim_sec = NULL_SEGNO;
 
 	if (sync)
-- 
2.30.2

