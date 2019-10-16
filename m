Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35500DA116
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390719AbfJPWTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389739AbfJPVyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:13 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F60220872;
        Wed, 16 Oct 2019 21:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262852;
        bh=oSBMJg9jxiX29dS/4Zk49nDXcKWbTqNiDD2KtX8PJe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtZWNwtb6SYvq6AeF2FiFMmXt1q3tdZ9WH0YvDegMGjV1zVNYIsKXT/AsrqmYXxGm
         rnZpxNfQ/VoNOSSHHg6Q1C0NDK0OADw8y8OxVD/uWxivBtbD5CMFeJjnEKUmjtF1oB
         FGQXyLrcnxYoIqzzwkM5nMyVMQlWmK7FBeUtGCq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 19/92] ceph: fix directories inode i_blkbits initialization
Date:   Wed, 16 Oct 2019 14:49:52 -0700
Message-Id: <20191016214815.696498042@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 339fdf6355df7..7fcddaaca8a5d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -800,7 +800,12 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
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



