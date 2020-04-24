Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DD01B7523
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgDXMbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbgDXMXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08DB021569;
        Fri, 24 Apr 2020 12:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730996;
        bh=ZFamFEIyxLFqoZps+iwlPUAC68uaCGU+cjB/GQ1R06U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsWijhMaph/uDPVA0rGK3fidgRMj2j0PBKlaviwqfUXgNLnk9LoNnlL3buD5hqQb/
         ar7SGSb6462KSVbMRZ6Q8Gnunm3DLmJQNX3gSTE9E+4gGqIQ6/UN8vWttfWLTMeCwL
         8K6KVicpT3MPDObUXIW+tgol0V2mCFgoharqtqmg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 34/38] ext4: convert BUG_ON's to WARN_ON's in mballoc.c
Date:   Fri, 24 Apr 2020 08:22:32 -0400
Message-Id: <20200424122237.9831-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 907ea529fc4c3296701d2bfc8b831dd2a8121a34 ]

If the in-core buddy bitmap gets corrupted (or out of sync with the
block bitmap), issue a WARN_ON and try to recover.  In most cases this
involves skipping trying to allocate out of a particular block group.
We can end up declaring the file system corrupted, which is fair,
since the file system probably should be checked before we proceed any
further.

Link: https://lore.kernel.org/r/20200414035649.293164-1-tytso@mit.edu
Google-Bug-Id: 34811296
Google-Bug-Id: 34639169
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 51a78eb65f3cf..2f7aebee1a7b4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1936,7 +1936,8 @@ void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 	int free;
 
 	free = e4b->bd_info->bb_free;
-	BUG_ON(free <= 0);
+	if (WARN_ON(free <= 0))
+		return;
 
 	i = e4b->bd_info->bb_first_free;
 
@@ -1959,7 +1960,8 @@ void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 		}
 
 		mb_find_extent(e4b, i, ac->ac_g_ex.fe_len, &ex);
-		BUG_ON(ex.fe_len <= 0);
+		if (WARN_ON(ex.fe_len <= 0))
+			break;
 		if (free < ex.fe_len) {
 			ext4_grp_locked_error(sb, e4b->bd_group, 0, 0,
 					"%d free clusters as per "
-- 
2.20.1

