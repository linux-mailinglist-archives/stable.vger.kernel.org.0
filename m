Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB232ACC2A
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbgKJDxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731487AbgKJDxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D9320731;
        Tue, 10 Nov 2020 03:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980420;
        bh=dl/APlT0EB9fzDUvz9Tkt75t8Hm7vIxMc/C7KCgXr7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JiGzUTq/76hevqK9mNJ443u1V36rdyGI0hCz7uApgqXDDTs98YJWAcMAZ2yJ3MmP9
         zGrS4gY6vXIoZQ9talulcg7Z3kJXQc1kDQi7dlrqALFFJ6FtTuAhH1EWcD/O2MPPhd
         zf6zlQ6ithKHwVHqsxIV0aLeNaOiCSkUts3rcn0s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.9 15/55] gfs2: Add missing truncate_inode_pages_final for sd_aspace
Date:   Mon,  9 Nov 2020 22:52:38 -0500
Message-Id: <20201110035318.423757-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit a9dd945ccef07a904e412f208f8de708a3d7159e ]

Gfs2 creates an address space for its rgrps called sd_aspace, but it never
called truncate_inode_pages_final on it. This confused vfs greatly which
tried to reference the address space after gfs2 had freed the superblock
that contained it.

This patch adds a call to truncate_inode_pages_final for sd_aspace, thus
avoiding the use-after-free.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 32ae1a7cdaed8..831f6e31d6821 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -732,6 +732,7 @@ static void gfs2_put_super(struct super_block *sb)
 	gfs2_jindex_free(sdp);
 	/*  Take apart glock structures and buffer lists  */
 	gfs2_gl_hash_clear(sdp);
+	truncate_inode_pages_final(&sdp->sd_aspace);
 	gfs2_delete_debugfs_file(sdp);
 	/*  Unmount the locking protocol  */
 	gfs2_lm_unmount(sdp);
-- 
2.27.0

