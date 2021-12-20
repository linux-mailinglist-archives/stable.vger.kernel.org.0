Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8A147AE59
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239221AbhLTPA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239177AbhLTO63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC09C0617A1;
        Mon, 20 Dec 2021 06:49:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55207B80EE5;
        Mon, 20 Dec 2021 14:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDA4C36AE8;
        Mon, 20 Dec 2021 14:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011792;
        bh=4pl3MJI3SANXrWVSTKxh1d/yI/hdSsjmSJUBrn2mceI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lS31KMhTA0HxEcCYcUkOqFgdM4tB4pcWsLCDkbtNWnPT2tPAVwG+84IrMywQYR0oR
         qmZvr7bd31OVx57+PpEgh5gUp9yDDipT292/Usn+aqJkJKWVfnaQbQDxwSJ3rEtmWl
         d1xxAVd2rkjQvPRTu2/D2ps+vOcutb4fkohvX1m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Jianglei Nie <niejianglei2021@163.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 75/99] btrfs: fix memory leak in __add_inode_ref()
Date:   Mon, 20 Dec 2021 15:34:48 +0100
Message-Id: <20211220143031.919674681@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
@@ -1109,6 +1109,7 @@ again:
 					     parent_objectid, victim_name,
 					     victim_name_len);
 			if (ret < 0) {
+				kfree(victim_name);
 				return ret;
 			} else if (!ret) {
 				ret = -ENOENT;


