Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1960C3B7A
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfJAQoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388087AbfJAQoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F85021855;
        Tue,  1 Oct 2019 16:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948269;
        bh=iYquV7rnSBLN4fz1yz+JjspIOWP43YtxMzKycPphq00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ekaxrtg092HUo9gk9/jWswA41fI6KQWOtpIui1hKqUoh/A1ulfiRlr80vdP7JQCWY
         Rd1RCoC4hGMg8VP/uYxplNy7m27BaLRt0YNVbeQbWYGte+q5AbHMVItiQYCOvuM9kO
         7yrgQqwEoA/N+sNJ0Xna0/PPtur1mRPYhpJsfcQI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/29] ceph: fix directories inode i_blkbits initialization
Date:   Tue,  1 Oct 2019 12:43:59 -0400
Message-Id: <20191001164423.16406-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164423.16406-1-sashal@kernel.org>
References: <20191001164423.16406-1-sashal@kernel.org>
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
index 9bda8c7a80a05..879bc08250931 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -789,7 +789,12 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 	ci->i_version = le64_to_cpu(info->version);
 	inode->i_version++;
 	inode->i_rdev = le32_to_cpu(info->rdev);
-	inode->i_blkbits = fls(le32_to_cpu(info->layout.fl_stripe_unit)) - 1;
+	/* directories have fl_stripe_unit set to zero */
+	if (le32_to_cpu(info->layout.fl_stripe_unit))
+		inode->i_blkbits =
+			fls(le32_to_cpu(info->layout.fl_stripe_unit)) - 1;
+	else
+		inode->i_blkbits = CEPH_BLOCK_SHIFT;
 
 	if ((new_version || (new_issued & CEPH_CAP_AUTH_SHARED)) &&
 	    (issued & CEPH_CAP_AUTH_EXCL) == 0) {
-- 
2.20.1

