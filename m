Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5513EB8AE
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242155AbhHMPPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242449AbhHMPOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 584AA6109D;
        Fri, 13 Aug 2021 15:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867623;
        bh=9rgRmNlt/6UWk0Ztz6okLjulqhTdnfc9g41hYKqGXlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTPOpjb+WzipqPJDO/Q1NdQHAQgI+iPYrNkMgiA0HrcKfM3iODaTwyDZN0s3CRIsq
         VvPz7fEGjVtJjxvijMAPmRV7EPc/SeOOXnJATw45o6p0SMgyvRJYAVsQVYGfDe766o
         pn/fqiFz+ZZUSlLph54neG8r0iioB4+lA0r8t4gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 26/27] btrfs: export and rename qgroup_reserve_meta
Date:   Fri, 13 Aug 2021 17:07:24 +0200
Message-Id: <20210813150524.252016242@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit 80e9baed722c853056e0c5374f51524593cb1031 upstream

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    8 ++++----
 fs/btrfs/qgroup.h |    3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3800,8 +3800,8 @@ static int sub_root_meta_rsv(struct btrf
 	return num_bytes;
 }
 
-static int qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-				enum btrfs_qgroup_rsv_type type, bool enforce)
+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+			      enum btrfs_qgroup_rsv_type type, bool enforce)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
@@ -3832,14 +3832,14 @@ int __btrfs_qgroup_reserve_meta(struct b
 {
 	int ret;
 
-	ret = qgroup_reserve_meta(root, num_bytes, type, enforce);
+	ret = btrfs_qgroup_reserve_meta(root, num_bytes, type, enforce);
 	if (ret <= 0 && ret != -EDQUOT)
 		return ret;
 
 	ret = try_flush_qgroup(root);
 	if (ret < 0)
 		return ret;
-	return qgroup_reserve_meta(root, num_bytes, type, enforce);
+	return btrfs_qgroup_reserve_meta(root, num_bytes, type, enforce);
 }
 
 void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -349,7 +349,8 @@ int btrfs_qgroup_reserve_data(struct btr
 int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_free_data(struct inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len);
-
+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+			      enum btrfs_qgroup_rsv_type type, bool enforce);
 int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 				enum btrfs_qgroup_rsv_type type, bool enforce);
 /* Reserve metadata space for pertrans and prealloc type */


