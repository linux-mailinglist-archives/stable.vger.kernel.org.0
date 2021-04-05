Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC973544AB
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbhDEQFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238895AbhDEQFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C929C613C7;
        Mon,  5 Apr 2021 16:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638737;
        bh=FqDLX8Hj/MTV3BG1nj6wwkQ9GYbozetX81W/+qlKXEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/62qQ6Id7RbTSsZbnuPpdwfnx0dnVlKfJbO6LB5es3tYAzhQesB3ZFd70GwndB6Q
         KmEv8Pe69ym223WTUCXkYoAQlfodFtk5BTsmx82lyYzNXbJ/RBkKB7e443Ek88tULW
         vFz/LjhsKq3iycFLDacrEkUYYEqLfgb8MGvN4GNIvpbhrcb8sDkYZ4RHOEEYWLaTBy
         gYqbJHZLq0rqGVwmcoEk1mTWcs+yN8JCLC/T278hAAfNt5yKv/6/RsZCLetuy3b0DM
         AhOektiLe41x6PiyAlK/px5c8qnvESSeleJHZAZ0rZ6IEqdaRIClD1O00gLL3BYWAe
         gFL0e8TzaezDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.9 2/2] gfs2: report "already frozen/thawed" errors
Date:   Mon,  5 Apr 2021 12:05:34 -0400
Message-Id: <20210405160534.269237-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160534.269237-1-sashal@kernel.org>
References: <20210405160534.269237-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit ff132c5f93c06bd4432bbab5c369e468653bdec4 ]

Before this patch, gfs2's freeze function failed to report an error
when the target file system was already frozen as it should (and as
generic vfs function freeze_super does. Similarly, gfs2's thaw function
failed to report an error when trying to thaw a file system that is not
frozen, as vfs function thaw_super does. The errors were checked, but
it always returned a 0 return code.

This patch adds the missing error return codes to gfs2 freeze and thaw.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 37496d83661a..ef401aecaa2c 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -986,11 +986,13 @@ void gfs2_freeze_func(struct work_struct *work)
 static int gfs2_freeze(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
-	int error = 0;
+	int error;
 
 	mutex_lock(&sdp->sd_freeze_mutex);
-	if (atomic_read(&sdp->sd_freeze_state) != SFS_UNFROZEN)
+	if (atomic_read(&sdp->sd_freeze_state) != SFS_UNFROZEN) {
+		error = -EBUSY;
 		goto out;
+	}
 
 	if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags)) {
 		error = -EINVAL;
@@ -1032,10 +1034,10 @@ static int gfs2_unfreeze(struct super_block *sb)
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 
 	mutex_lock(&sdp->sd_freeze_mutex);
-        if (atomic_read(&sdp->sd_freeze_state) != SFS_FROZEN ||
+	if (atomic_read(&sdp->sd_freeze_state) != SFS_FROZEN ||
 	    !gfs2_holder_initialized(&sdp->sd_freeze_gh)) {
 		mutex_unlock(&sdp->sd_freeze_mutex);
-                return 0;
+		return -EINVAL;
 	}
 
 	gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
-- 
2.30.2

