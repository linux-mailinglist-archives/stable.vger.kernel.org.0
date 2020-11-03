Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700372A530A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgKCUzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:55:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732087AbgKCUzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:55:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFC3A223AC;
        Tue,  3 Nov 2020 20:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436954;
        bh=EQVGEy6CkB7Wb8PJHdFwy+HAguGKKloyjSxavWVl7r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2Ux7fzLXK+zq7rNL0OEaqOhowyKryZYE+sQuU0aKZeEZuBEI5/uGGFAL1QUVABdr
         0vuqxPELDq3l+KxQcgGAFn5J5I4nSjNn8wlwZVL0rvOtle554qHamoR1fS04f3DWid
         XgUZ7x4CVcFvyLI31KXwALGSrY0QUJTIPq3DndJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af90d47a37376844e731@syzkaller.appspotmail.com,
        Andrew Price <anprice@redhat.com>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/214] gfs2: add validation checks for size of superblock
Date:   Tue,  3 Nov 2020 21:35:32 +0100
Message-Id: <20201103203258.219187193@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

[ Upstream commit 0ddc5154b24c96f20e94d653b0a814438de6032b ]

In gfs2_check_sb(), no validation checks are performed with regards to
the size of the superblock.
syzkaller detected a slab-out-of-bounds bug that was primarily caused
because the block size for a superblock was set to zero.
A valid size for a superblock is a power of 2 between 512 and PAGE_SIZE.
Performing validation checks and ensuring that the size of the superblock
is valid fixes this bug.

Reported-by: syzbot+af90d47a37376844e731@syzkaller.appspotmail.com
Tested-by: syzbot+af90d47a37376844e731@syzkaller.appspotmail.com
Suggested-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
[Minor code reordering.]
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 338666a97fff6..29b27d769860c 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -169,15 +169,19 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
 		return -EINVAL;
 	}
 
-	/*  If format numbers match exactly, we're done.  */
-
-	if (sb->sb_fs_format == GFS2_FORMAT_FS &&
-	    sb->sb_multihost_format == GFS2_FORMAT_MULTI)
-		return 0;
+	if (sb->sb_fs_format != GFS2_FORMAT_FS ||
+	    sb->sb_multihost_format != GFS2_FORMAT_MULTI) {
+		fs_warn(sdp, "Unknown on-disk format, unable to mount\n");
+		return -EINVAL;
+	}
 
-	fs_warn(sdp, "Unknown on-disk format, unable to mount\n");
+	if (sb->sb_bsize < 512 || sb->sb_bsize > PAGE_SIZE ||
+	    (sb->sb_bsize & (sb->sb_bsize - 1))) {
+		pr_warn("Invalid superblock size\n");
+		return -EINVAL;
+	}
 
-	return -EINVAL;
+	return 0;
 }
 
 static void end_bio_io_page(struct bio *bio)
-- 
2.27.0



