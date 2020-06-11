Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FD01F6FFA
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 00:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgFKWWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 18:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgFKWWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 18:22:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CD832073E;
        Thu, 11 Jun 2020 22:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591914173;
        bh=w3BCC/wqWQ84V2Mit+rnpEVOz3opHndX7E0gwBiIVLA=;
        h=Date:From:To:Subject:From;
        b=E9wunzYY6beKOmOGjlSsk8a1eaFS0skAWDGQEKrx/qji0AG4/v0Vz+dvjQcds8A/4
         zzkHjHbeiPtfGGz4kbNbKfc8x4saAAg83Y2IjScXr7mZyqSIMZc/zsgJUADBE8JOTK
         PrMz9vJ6br39Hq9Cso0RCM0rbnCAR9s8y8RFj97A=
Date:   Thu, 11 Jun 2020 15:22:53 -0700
From:   akpm@linux-foundation.org
To:     hdk1983@gmail.com, hermes@ceres.dti.ne.jp,
        konishi.ryusuke@gmail.com, me@waltonhoops.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, tom@logand.com
Subject:  [merged]
 nilfs2-fix-null-pointer-dereference-at-nilfs_segctor_do_construct.patch
 removed from -mm tree
Message-ID: <20200611222253.gW16kvdLP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-null-pointer-dereference-at-nilfs_segctor_do_construct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()

After commit c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if
mapping has no dirty pages"), the following null pointer dereference has
been reported on nilfs2:

 BUG: kernel NULL pointer dereference, address: 00000000000000a8
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP PTI
 ...
 RIP: 0010:percpu_counter_add_batch+0xa/0x60
 ...
 Call Trace:
  __test_set_page_writeback+0x2d3/0x330
  nilfs_segctor_do_construct+0x10d3/0x2110 [nilfs2]
  nilfs_segctor_construct+0x168/0x260 [nilfs2]
  nilfs_segctor_thread+0x127/0x3b0 [nilfs2]
  kthread+0xf8/0x130
  ...

This crash turned out to be caused by set_page_writeback() call for
segment summary buffers at nilfs_segctor_prepare_write().

set_page_writeback() can call inc_wb_stat(inode_to_wb(inode),
WB_WRITEBACK) where inode_to_wb(inode) is NULL if the inode of
underlying block device does not have an associated wb.

This fixes the issue by calling inode_attach_wb() in advance to ensure
to associate the bdev inode with its wb.

Link: http://lkml.kernel.org/r/20200608.011819.1399059588922299158.konishi.ryusuke@gmail.com
Fixes: c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if mapping has no dirty pages")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Walton Hoops <me@waltonhoops.com>
Reported-by: Tomas Hlavaty <tom@logand.com>
Reported-by: ARAI Shun-ichi <hermes@ceres.dti.ne.jp>
Reported-by: Hideki EIRAKU <hdk1983@gmail.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nilfs2/segment.c~nilfs2-fix-null-pointer-dereference-at-nilfs_segctor_do_construct
+++ a/fs/nilfs2/segment.c
@@ -2780,6 +2780,8 @@ int nilfs_attach_log_writer(struct super
 	if (!nilfs->ns_writer)
 		return -ENOMEM;
 
+	inode_attach_wb(nilfs->ns_bdev->bd_inode, NULL);
+
 	err = nilfs_segctor_start_thread(nilfs->ns_writer);
 	if (err) {
 		kfree(nilfs->ns_writer);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


