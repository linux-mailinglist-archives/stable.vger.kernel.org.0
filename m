Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041B82C99FC
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgLAIyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:54:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgLAIyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:54:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9EFC206D8;
        Tue,  1 Dec 2020 08:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812811;
        bh=N/9Sji6tWE+N2In3CKIkh48ot16jWk+HLWcpyme7Dnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/V1pBk102+x0OAvRDyVACMoPKCSnlCjyXNOrc7WV6TqN/ZneHCtdVGYR2oz3K3VS
         w+myUHqTYa/TXhzqeT1kFnJbVnUWe3qST3VJp+r2CurjtRNmYE4B+VDYunuK88jB/3
         tLmN6uVmASQdKDk13erTT6OhHf5DA3JluZaDHg5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 01/24] btrfs: tree-checker: Enhance chunk checker to validate chunk profile
Date:   Tue,  1 Dec 2020 09:53:07 +0100
Message-Id: <20201201084637.835683103@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
References: <20201201084637.754785180@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -6262,6 +6262,13 @@ static int btrfs_check_chunk_valid(struc
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


