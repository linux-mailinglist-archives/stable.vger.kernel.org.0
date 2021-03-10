Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C29333DB7
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbhCJNYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhCJNYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EFC364FF3;
        Wed, 10 Mar 2021 13:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382661;
        bh=Mv7fJKNjfiRutYFVYnTT1lTLGnJfdjtqJHtP1adkQjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmnhcCkdUyW4HWJta4SZdbiCcxWmUIZZaa7wTIT28cphgcyQ/HL1/037qoGhUVO0N
         auOCLhg5iAtEcHcgJlJhqwXEnh+y6ddjeCKXYQ5VC7PasD1JqViNhnf2qUgalZWkwq
         EWS959bOsCO9oRkW2BP8ZbtTBhcHhDxLKmdMmL/E=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.11 15/36] btrfs: export and rename qgroup_reserve_meta
Date:   Wed, 10 Mar 2021 14:23:28 +0100
Message-Id: <20210310132320.997397561@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Nikolay Borisov <nborisov@suse.com>

commit 80e9baed722c853056e0c5374f51524593cb1031 upstream

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    8 ++++----
 fs/btrfs/qgroup.h |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3841,8 +3841,8 @@ static int sub_root_meta_rsv(struct btrf
 	return num_bytes;
 }
 
-static int qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-				enum btrfs_qgroup_rsv_type type, bool enforce)
+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+			      enum btrfs_qgroup_rsv_type type, bool enforce)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
@@ -3873,14 +3873,14 @@ int __btrfs_qgroup_reserve_meta(struct b
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
@@ -361,6 +361,8 @@ int btrfs_qgroup_release_data(struct btr
 int btrfs_qgroup_free_data(struct btrfs_inode *inode,
 			   struct extent_changeset *reserved, u64 start,
 			   u64 len);
+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+			      enum btrfs_qgroup_rsv_type type, bool enforce);
 int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 				enum btrfs_qgroup_rsv_type type, bool enforce);
 /* Reserve metadata space for pertrans and prealloc type */


