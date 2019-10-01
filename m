Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4655AC3CA7
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbfJAQxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732619AbfJAQnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:43:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54B4721A4A;
        Tue,  1 Oct 2019 16:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948201;
        bh=kbKRZ0Q0RFzNHJ+wPoL9JkLyp4TjDE9uhp0jte9Nwio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q97VuxGiWgfxJu0sp8Tt6cEh733iXbQb+yayp65S9wwFzRQT+T3VKHvbvChNxBhv0
         ZteG0V9IVXkvd2RYKaJlztKBowSDRkrzvX7yLCx9EzDrRuj7aoKjuKx4hlbWJpFxAs
         AOfbaMJhF+S+fggtvDsDdqQOiRRcX4P1Z1N6iZcU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/43] ceph: fix directories inode i_blkbits initialization
Date:   Tue,  1 Oct 2019 12:42:36 -0400
Message-Id: <20191001164311.15993-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164311.15993-1-sashal@kernel.org>
References: <20191001164311.15993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

[ Upstream commit 750670341a24cb714e624e0fd7da30900ad93752 ]

When filling an inode with info from the MDS, i_blkbits is being
initialized using fl_stripe_unit, which contains the stripe unit in
bytes.  Unfortunately, this doesn't make sense for directories as they
have fl_stripe_unit set to '0'.  This means that i_blkbits will be set
to 0xff, causing an UBSAN undefined behaviour in i_blocksize():

  UBSAN: Undefined behaviour in ./include/linux/fs.h:731:12
  shift exponent 255 is too large for 32-bit type 'int'

Fix this by initializing i_blkbits to CEPH_BLOCK_SHIFT if fl_stripe_unit
is zero.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 665a86f83f4b0..8c9266625cea8 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -804,7 +804,12 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 
 	/* update inode */
 	inode->i_rdev = le32_to_cpu(info->rdev);
-	inode->i_blkbits = fls(le32_to_cpu(info->layout.fl_stripe_unit)) - 1;
+	/* directories have fl_stripe_unit set to zero */
+	if (le32_to_cpu(info->layout.fl_stripe_unit))
+		inode->i_blkbits =
+			fls(le32_to_cpu(info->layout.fl_stripe_unit)) - 1;
+	else
+		inode->i_blkbits = CEPH_BLOCK_SHIFT;
 
 	__ceph_update_quota(ci, iinfo->max_bytes, iinfo->max_files);
 
-- 
2.20.1

