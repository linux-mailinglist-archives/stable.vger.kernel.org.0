Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12C12ABD9E
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgKINrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729666AbgKIM4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:56:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E5942076E;
        Mon,  9 Nov 2020 12:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926609;
        bh=U7vM9XcSuh9duXPTACBac/jzASl8voBIeL9UsB1fTTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5cU5Ud0oEs9ujpHapwp7O1teIqzZ3Zr1hD+SHtHC76uRn+b1q+7yXlBjKc/x7INp
         W5zgcMPKcwz81AP9mYGb8ebyzCmV9c3K/3OUwRq7CFWiQ3Rsx/h0onotpp9CnyXOlV
         RDtIENIyZ264TL2r/bzoD1sShxn4dEbo+Dpmhsag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af90d47a37376844e731@syzkaller.appspotmail.com,
        Andrew Price <anprice@redhat.com>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 29/86] gfs2: add validation checks for size of superblock
Date:   Mon,  9 Nov 2020 13:54:36 +0100
Message-Id: <20201109125022.258961644@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
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
index b7b43d00cc6d7..8ed2b1a716376 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -160,15 +160,19 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
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



