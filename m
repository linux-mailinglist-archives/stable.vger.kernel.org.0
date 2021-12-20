Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B0247AF9A
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbhLTPQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239887AbhLTPOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:14:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38E9C00693D;
        Mon, 20 Dec 2021 06:57:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E808B80EE3;
        Mon, 20 Dec 2021 14:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D696AC36AE8;
        Mon, 20 Dec 2021 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012248;
        bh=bK1n+S427wb23NqOofsbrM4ULxmkuDog0jSt8VwB6mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhTwV/tOdNleaOGRfEJUqGzRiGeS9muDVPdRzxo4IokhyNhiMD8xhC76FTYCd3CmR
         FsHYJev6yYZe4ef4wpVvbEpRrIj3YRwzVPVwjbbqaoWGYgNla0gLdgpquz3KUjZDYf
         tixfiNisg+yfg/bJ2ONLTNzDcB4SxmSldZqv6d5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Jianglei Nie <niejianglei2021@163.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 132/177] btrfs: fix memory leak in __add_inode_ref()
Date:   Mon, 20 Dec 2021 15:34:42 +0100
Message-Id: <20211220143044.516478168@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

commit f35838a6930296fc1988764cfa54cb3f705c0665 upstream.

Line 1169 (#3) allocates a memory chunk for victim_name by kmalloc(),
but  when the function returns in line 1184 (#4) victim_name allocated
by line 1169 (#3) is not freed, which will lead to a memory leak.
There is a similar snippet of code in this function as allocating a memory
chunk for victim_name in line 1104 (#1) as well as releasing the memory
in line 1116 (#2).

We should kfree() victim_name when the return value of backref_in_log()
is less than zero and before the function returns in line 1184 (#4).

1057 static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
1058 				  struct btrfs_root *root,
1059 				  struct btrfs_path *path,
1060 				  struct btrfs_root *log_root,
1061 				  struct btrfs_inode *dir,
1062 				  struct btrfs_inode *inode,
1063 				  u64 inode_objectid, u64 parent_objectid,
1064 				  u64 ref_index, char *name, int namelen,
1065 				  int *search_done)
1066 {

1104 	victim_name = kmalloc(victim_name_len, GFP_NOFS);
	// #1: kmalloc (victim_name-1)
1105 	if (!victim_name)
1106 		return -ENOMEM;

1112	ret = backref_in_log(log_root, &search_key,
1113			parent_objectid, victim_name,
1114			victim_name_len);
1115	if (ret < 0) {
1116		kfree(victim_name); // #2: kfree (victim_name-1)
1117		return ret;
1118	} else if (!ret) {

1169 	victim_name = kmalloc(victim_name_len, GFP_NOFS);
	// #3: kmalloc (victim_name-2)
1170 	if (!victim_name)
1171 		return -ENOMEM;

1180 	ret = backref_in_log(log_root, &search_key,
1181 			parent_objectid, victim_name,
1182 			victim_name_len);
1183 	if (ret < 0) {
1184 		return ret; // #4: missing kfree (victim_name-2)
1185 	} else if (!ret) {

1241 	return 0;
1242 }

Fixes: d3316c8233bb ("btrfs: Properly handle backref_in_log retval")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1153,6 +1153,7 @@ again:
 					     parent_objectid, victim_name,
 					     victim_name_len);
 			if (ret < 0) {
+				kfree(victim_name);
 				return ret;
 			} else if (!ret) {
 				ret = -ENOENT;


