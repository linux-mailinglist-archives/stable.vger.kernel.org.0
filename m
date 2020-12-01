Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731422C9A3F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgLAI4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:56:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbgLAI4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:56:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 001E5217A0;
        Tue,  1 Dec 2020 08:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812942;
        bh=Devu7aS3yxUpDTSuBwIzeXyPYg3/pWezv87Va7+bAmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ln6975tjM1+pyQJVC7xLukYqQ46Fd+3OOjTgmoGOzk84rEiHhJ0QdYVNVhTTrLqgt
         frmGMZ8+/Wx4vp5Jvfkf9lEB7+aCGNwSxQL/0KGgU/n9ACLL7iEm3bUAbFesPct4oy
         WfjBUB1ACl4U28kR/vJOxGuwH3N9nM7CZdi3prjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 05/42] btrfs: tree-checker: Enhance chunk checker to validate chunk profile
Date:   Tue,  1 Dec 2020 09:53:03 +0100
Message-Id: <20201201084642.426783814@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084642.194933793@linuxfoundation.org>
References: <20201201084642.194933793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 80e46cf22ba0bcb57b39c7c3b52961ab3a0fd5f2 upstream

Btrfs-progs already have a comprehensive type checker, to ensure there
is only 0 (SINGLE profile) or 1 (DUP/RAID0/1/5/6/10) bit set for chunk
profile bits.

Do the same work for kernel.

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202765
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: manually backport, use btrfs_err with root->fs_info]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6414,6 +6414,13 @@ static int btrfs_check_chunk_valid(struc
 		return -EIO;
 	}
 
+	if (!is_power_of_2(type & BTRFS_BLOCK_GROUP_PROFILE_MASK) &&
+	    (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) != 0) {
+		btrfs_err(root->fs_info,
+		"invalid chunk profile flag: 0x%llx, expect 0 or 1 bit set",
+			  type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
+		return -EUCLEAN;
+	}
 	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
 		btrfs_err(root->fs_info, "missing chunk type flag: 0x%llx", type);
 		return -EIO;


