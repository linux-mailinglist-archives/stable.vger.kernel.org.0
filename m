Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77562018F6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbgFSQzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387427AbgFSOf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:35:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4F6E2070A;
        Fri, 19 Jun 2020 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577357;
        bh=GpaoxSM7OEtx+hmL3101sa/SZl5PTqmk3Qk78BmE58w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ak17SJAVkTAynxQd0VUeqaD/9KbaFIMuhm6JAisEShAcNBEJIRX3lxPYLwjxQOND/
         5XW60GfBPpmv3fvuCTTDcFZHi1xq0Yta5wtfvsAdu3aDXfSuRdTBKT0l7RAZZGQjvv
         cy8+Gd5rp1ecqo9dZC45VAIalKS9WtZL9lbFlQvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Walton Hoops <me@waltonhoops.com>,
        Tomas Hlavaty <tom@logand.com>,
        ARAI Shun-ichi <hermes@ceres.dti.ne.jp>,
        Hideki EIRAKU <hdk1983@gmail.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 019/101] nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()
Date:   Fri, 19 Jun 2020 16:32:08 +0200
Message-Id: <20200619141615.089198176@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 8301c719a2bd131436438e49130ee381d30933f5 upstream.

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

Fixes: c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if mapping has no dirty pages")
Reported-by: Walton Hoops <me@waltonhoops.com>
Reported-by: Tomas Hlavaty <tom@logand.com>
Reported-by: ARAI Shun-ichi <hermes@ceres.dti.ne.jp>
Reported-by: Hideki EIRAKU <hdk1983@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Link: http://lkml.kernel.org/r/20200608.011819.1399059588922299158.konishi.ryusuke@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nilfs2/segment.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2781,6 +2781,8 @@ int nilfs_attach_log_writer(struct super
 	if (!nilfs->ns_writer)
 		return -ENOMEM;
 
+	inode_attach_wb(nilfs->ns_bdev->bd_inode, NULL);
+
 	err = nilfs_segctor_start_thread(nilfs->ns_writer);
 	if (err) {
 		kfree(nilfs->ns_writer);


