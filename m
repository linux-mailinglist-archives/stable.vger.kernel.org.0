Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A01354415
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241925AbhDEQE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241972AbhDEQEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32C3A613C4;
        Mon,  5 Apr 2021 16:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638653;
        bh=IfbCnZZonoEn1lMj5v3JPDwXb3ImT8FQzphlUT/vIEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rughsZV3mphZpF2CrHKrI2BrwC+Wbj4Fr0bO80ez1Bgos+pE29z3jr0burK7+tG/K
         DwSeneONYL0fgUtvlMjKqooKJbIUr677yP5x6ZphUwZqNXz4t/45+6Sfv8MgFSHy9+
         Rjcnq9QQiA+5Rd1xw9LsJHTiYLLJEa4yhPikyykF8o7zEJVH5ZGQ7qzWjtxM9haSyM
         Y1DBSSgPUURB7fIqws2149BG7bKjEme+I7Qel1AfJ341rgiy2TFIqZzNKg9KaQasu1
         h6G9ns1N9CZSMTaFhijjDOG2L+pQjBWOCOZFDaRcfnq894LCjju9/2aPcW3I/znhau
         AWn4dciXTPmNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.11 06/22] gfs2: report "already frozen/thawed" errors
Date:   Mon,  5 Apr 2021 12:03:49 -0400
Message-Id: <20210405160406.268132-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
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
index 34ca312457a6..223ebd6b1b8d 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -767,11 +767,13 @@ void gfs2_freeze_func(struct work_struct *work)
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
 
 	for (;;) {
 		if (gfs2_withdrawn(sdp)) {
@@ -812,10 +814,10 @@ static int gfs2_unfreeze(struct super_block *sb)
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 
 	mutex_lock(&sdp->sd_freeze_mutex);
-        if (atomic_read(&sdp->sd_freeze_state) != SFS_FROZEN ||
+	if (atomic_read(&sdp->sd_freeze_state) != SFS_FROZEN ||
 	    !gfs2_holder_initialized(&sdp->sd_freeze_gh)) {
 		mutex_unlock(&sdp->sd_freeze_mutex);
-                return 0;
+		return -EINVAL;
 	}
 
 	gfs2_freeze_unlock(&sdp->sd_freeze_gh);
-- 
2.30.2

