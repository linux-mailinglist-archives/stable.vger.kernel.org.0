Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34C6D2361
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387725AbfJJIlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388414AbfJJIlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:41:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E061021BE5;
        Thu, 10 Oct 2019 08:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696909;
        bh=au7RXpazVKg8aDvc0+r3dLxy0AhQ6+CZk+Ol5BMAo6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVKa4tWZPmZ4xfXKZDmkyXI+eizSyCeByXgVeMmo11Ma+SUOmgrAf+4DHPwYHHaXg
         RXTuKZDN+EiU65yzqaZrwAJar+btKyJw1Ld0shahTA6C9DyPdXBDLG4fO2SEpIhvEK
         Tt8DGIcXZQAgWYGvVByF0ZqjuyRHYQOIv3VK+AP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 098/148] ceph: fix directories inode i_blkbits initialization
Date:   Thu, 10 Oct 2019 10:35:59 +0200
Message-Id: <20191010083617.195609047@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
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
index 18500edefc56f..3b537e7038c7a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -801,7 +801,12 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 
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



