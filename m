Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1156F163293
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgBRUIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:08:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727280AbgBRT6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:58:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2902A20659;
        Tue, 18 Feb 2020 19:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055884;
        bh=oHjNPYRc6V5pjSMnY/9ywhh4+Sjp1tPVDNCkJphgWzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8TIB41JmU6qtIbsyR7mUY64+5j+yc4hMJmjPn1DNDf+JEqHMxqFkQuMChHWkLxS/
         krgUJk1y8VAIflV/juorxwxpNwisW47haMnn9nALQSFP8sSsDQ0Ylh+oEC1o2l/fV9
         lnEY1WCO3iQfGcdPfgolpzz/pm//USZw9MRcmIsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 20/66] btrfs: ref-verify: fix memory leaks
Date:   Tue, 18 Feb 2020 20:54:47 +0100
Message-Id: <20200218190429.964168504@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

commit f311ade3a7adf31658ed882aaab9f9879fdccef7 upstream.

In btrfs_ref_tree_mod(), 'ref' and 'ra' are allocated through kzalloc() and
kmalloc(), respectively. In the following code, if an error occurs, the
execution will be redirected to 'out' or 'out_unlock' and the function will
be exited. However, on some of the paths, 'ref' and 'ra' are not
deallocated, leading to memory leaks. For example, if 'action' is
BTRFS_ADD_DELAYED_EXTENT, add_block_entry() will be invoked. If the return
value indicates an error, the execution will be redirected to 'out'. But,
'ref' is not deallocated on this path, causing a memory leak.

To fix the above issues, deallocate both 'ref' and 'ra' before exiting from
the function when an error is encountered.

CC: stable@vger.kernel.org # 4.15+
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ref-verify.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -744,6 +744,7 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
 		 */
 		be = add_block_entry(fs_info, bytenr, num_bytes, ref_root);
 		if (IS_ERR(be)) {
+			kfree(ref);
 			kfree(ra);
 			ret = PTR_ERR(be);
 			goto out;
@@ -757,6 +758,8 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
 			"re-allocated a block that still has references to it!");
 			dump_block_entry(fs_info, be);
 			dump_ref_action(fs_info, ra);
+			kfree(ref);
+			kfree(ra);
 			goto out_unlock;
 		}
 
@@ -819,6 +822,7 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
 "dropping a ref for a existing root that doesn't have a ref on the block");
 				dump_block_entry(fs_info, be);
 				dump_ref_action(fs_info, ra);
+				kfree(ref);
 				kfree(ra);
 				goto out_unlock;
 			}
@@ -834,6 +838,7 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
 "attempting to add another ref for an existing ref on a tree block");
 			dump_block_entry(fs_info, be);
 			dump_ref_action(fs_info, ra);
+			kfree(ref);
 			kfree(ra);
 			goto out_unlock;
 		}


