Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4024A29A08D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443559AbgJ0AbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409490AbgJZXvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BF9820872;
        Mon, 26 Oct 2020 23:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756300;
        bh=4Hl0iTqt+SBIwXYGMu3Xu5V0lsutjycnTZ1fMWl+EtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJWMl8KhwJaFrRkmV3OujOKlSMAmVPQCA7RSaS6yPzfKm7uP9quM90QPUz/ntbb40
         isFeThTuSHoSE3N/SPkyV2O5e9Xu6EC5mEE5UECkjSZgBWe1b+p0HNnpFDW9flpD3j
         +fPd/SlPBXTdbbl5tDoVhYuczMGTc3aSQIwfJlyQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+af90d47a37376844e731@syzkaller.appspotmail.com,
        Andrew Price <anprice@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.9 126/147] gfs2: add validation checks for size of superblock
Date:   Mon, 26 Oct 2020 19:48:44 -0400
Message-Id: <20201026234905.1022767-126-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5bd602a290f72..03c33fc03c055 100644
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
2.25.1

