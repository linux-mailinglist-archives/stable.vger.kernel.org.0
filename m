Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A8E4CF6D2
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbiCGJnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbiCGJjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173A570931;
        Mon,  7 Mar 2022 01:34:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EDD36128E;
        Mon,  7 Mar 2022 09:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B794C340E9;
        Mon,  7 Mar 2022 09:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645669;
        bh=JaDOKGxkstXvayk71s8oa+46K84swD26bFQlLGDAZaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ro9r5T/9+cFt0f3HXqRQStpe6N/GZ6CnsJswKnKhnvWArhuljreu1wd870uKBjSbb
         oWdLteTWf+6WgznfBaPiWHTgs6Z4lOIHt4hYqKs1I8yBUtl1Na2qvK4F2Az52L1bLv
         OsR7HiO6viKy9PAr0yL/EfICvlvsSNSwsKqEgm+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 104/105] btrfs: add missing run of delayed items after unlink during log replay
Date:   Mon,  7 Mar 2022 10:19:47 +0100
Message-Id: <20220307091647.102718054@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 4751dc99627e4d1465c5bfa8cb7ab31ed418eff5 upstream.

During log replay, whenever we need to check if a name (dentry) exists in
a directory we do searches on the subvolume tree for inode references or
or directory entries (BTRFS_DIR_INDEX_KEY keys, and BTRFS_DIR_ITEM_KEY
keys as well, before kernel 5.17). However when during log replay we
unlink a name, through btrfs_unlink_inode(), we may not delete inode
references and dir index keys from a subvolume tree and instead just add
the deletions to the delayed inode's delayed items, which will only be
run when we commit the transaction used for log replay. This means that
after an unlink operation during log replay, if we attempt to search for
the same name during log replay, we will not see that the name was already
deleted, since the deletion is recorded only on the delayed items.

We run delayed items after every unlink operation during log replay,
except at unlink_old_inode_refs() and at add_inode_ref(). This was due
to an overlook, as delayed items should be run after evert unlink, for
the reasons stated above.

So fix those two cases.

Fixes: 0d836392cadd5 ("Btrfs: fix mount failure after fsync due to hard link recreation")
Fixes: 1f250e929a9c9 ("Btrfs: fix log replay failure after unlink and link combination")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1286,6 +1286,15 @@ again:
 						 inode, name, namelen);
 			kfree(name);
 			iput(dir);
+			/*
+			 * Whenever we need to check if a name exists or not, we
+			 * check the subvolume tree. So after an unlink we must
+			 * run delayed items, so that future checks for a name
+			 * during log replay see that the name does not exists
+			 * anymore.
+			 */
+			if (!ret)
+				ret = btrfs_run_delayed_items(trans);
 			if (ret)
 				goto out;
 			goto again;
@@ -1537,6 +1546,15 @@ static noinline int add_inode_ref(struct
 				 */
 				if (!ret && inode->i_nlink == 0)
 					inc_nlink(inode);
+				/*
+				 * Whenever we need to check if a name exists or
+				 * not, we check the subvolume tree. So after an
+				 * unlink we must run delayed items, so that future
+				 * checks for a name during log replay see that the
+				 * name does not exists anymore.
+				 */
+				if (!ret)
+					ret = btrfs_run_delayed_items(trans);
 			}
 			if (ret < 0)
 				goto out;


