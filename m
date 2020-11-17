Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD32B64AF
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732418AbgKQNsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:48:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732417AbgKQNfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B1A42466D;
        Tue, 17 Nov 2020 13:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620101;
        bh=l/R39NH+cYIQunjDxIMvnDq5/M+iw4c1kzWui+l4/yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WyduY8W7dSP5OWquXNhnne5MY5mFb+5yX4sf/UH7fCcDjR8klZYmKXNdlQpr2GkL
         08SOSxrIqVL1aCOmrR8ebqgAcsbXUYc3CJ5KF933B860l+z7EiiHnfv1DdC9jhQI9O
         WCI9ks05ogHGh+W/S4ZBO9vNIUfFeQoJIZoMvJbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 090/255] gfs2: Add missing truncate_inode_pages_final for sd_aspace
Date:   Tue, 17 Nov 2020 14:03:50 +0100
Message-Id: <20201117122143.335147886@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -732,6 +732,7 @@ restart:
 	gfs2_jindex_free(sdp);
 	/*  Take apart glock structures and buffer lists  */
 	gfs2_gl_hash_clear(sdp);
+	truncate_inode_pages_final(&sdp->sd_aspace);
 	gfs2_delete_debugfs_file(sdp);
 	/*  Unmount the locking protocol  */
 	gfs2_lm_unmount(sdp);
-- 
2.27.0



