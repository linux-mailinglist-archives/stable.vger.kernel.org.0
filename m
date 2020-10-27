Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1ED29BD70
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810976AbgJ0Qge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801846AbgJ0Pob (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4204322265;
        Tue, 27 Oct 2020 15:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813437;
        bh=8npp70Pw/AZIGtoyK37Wbz/bbKCoVe6Q5KjyXuKnVF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpooSwbLbEWpjkhtGcEvQRJgQHSEZgnIIDiTrp//3/hljcDGfM4hglqZ6RV0/ZRdz
         /dH1rxMkhwyvfE1DlZif6QiBnf5eMf6c9ms7gIoLtwcLVCE7EdgqcYHZBYdCqA5FJR
         GRBSsUkP9gJHvQRpgy3lMdE9ho/z/qs8YV+8ynB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 552/757] ext4: disallow modifying DAX inode flag if inline_data has been set
Date:   Tue, 27 Oct 2020 14:53:22 +0100
Message-Id: <20201027135516.387368243@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Yang <yangx.jy@cn.fujitsu.com>

[ Upstream commit aa2f77920b743c44e02e2dc8474bbf8bd30007a2 ]

inline_data is mutually exclusive to DAX so enabling both of them triggers
the following issue:
------------------------------------------
# mkfs.ext4 -F -O inline_data /dev/pmem1
...
# mount /dev/pmem1 /mnt
# echo 'test' >/mnt/file
# lsattr -l /mnt/file
/mnt/file                    Inline_Data
# xfs_io -c "chattr +x" /mnt/file
# xfs_io -c "lsattr -v" /mnt/file
[dax] /mnt/file
# umount /mnt
# mount /dev/pmem1 /mnt
# cat /mnt/file
cat: /mnt/file: Numerical result out of range
------------------------------------------

Fixes: b383a73f2b83 ("fs/ext4: Introduce DAX inode flag")
Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20200828084330.15776-1-yangx.jy@cn.fujitsu.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 523e00d7b3924..69187b6205b2b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -492,7 +492,7 @@ struct flex_groups {
 
 /* Flags which are mutually exclusive to DAX */
 #define EXT4_DAX_MUT_EXCL (EXT4_VERITY_FL | EXT4_ENCRYPT_FL |\
-			   EXT4_JOURNAL_DATA_FL)
+			   EXT4_JOURNAL_DATA_FL | EXT4_INLINE_DATA_FL)
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
-- 
2.25.1



