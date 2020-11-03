Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D36B2A57C4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbgKCUwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:49562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732124AbgKCUwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90EBE2236F;
        Tue,  3 Nov 2020 20:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436759;
        bh=nTTUUWFVIs73i31KKK7JjYTqSPk9AZ8yr1SBM1k8BBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=saBaVItlwz4WWhtXLEMtCypaGKmvIm7mwprxWCUFKkntRpc1tfNz1LIDaijyvki9j
         XkXN328tenJQvSvhvab1BNHhbTM6noZM1HCqhCA8zroz9Z0D2IPK9oV1k2HypAW8x9
         IA+pd/Cl3+Fs/AOERc97At5IEWKA7ED3yaQwmksQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Yuxuan Shui <yshuiv7@gmail.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.9 342/391] ext4: implement swap_activate aops using iomap
Date:   Tue,  3 Nov 2020 21:36:33 +0100
Message-Id: <20201103203410.213396435@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit 0e6895ba00b7be45f3ab0d2107dda3ef1245f5b4 upstream.

After moving ext4's bmap to iomap interface, swapon functionality
on files created using fallocate (which creates unwritten extents) are
failing. This is since iomap_bmap interface returns 0 for unwritten
extents and thus generic_swapfile_activate considers this as holes
and hence bail out with below kernel msg :-

[340.915835] swapon: swapfile has holes

To fix this we need to implement ->swap_activate aops in ext4
which will use ext4_iomap_report_ops. Since we only need to return
the list of extents so ext4_iomap_report_ops should be enough.

Cc: stable@kernel.org
Reported-by: Yuxuan Shui <yshuiv7@gmail.com>
Fixes: ac58e4fb03f ("ext4: move ext4 bmap to use iomap infrastructure")
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/20200904091653.1014334-1-riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3601,6 +3601,13 @@ static int ext4_set_page_dirty(struct pa
 	return __set_page_dirty_buffers(page);
 }
 
+static int ext4_iomap_swap_activate(struct swap_info_struct *sis,
+				    struct file *file, sector_t *span)
+{
+	return iomap_swapfile_activate(sis, file, span,
+				       &ext4_iomap_report_ops);
+}
+
 static const struct address_space_operations ext4_aops = {
 	.readpage		= ext4_readpage,
 	.readahead		= ext4_readahead,
@@ -3616,6 +3623,7 @@ static const struct address_space_operat
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
+	.swap_activate		= ext4_iomap_swap_activate,
 };
 
 static const struct address_space_operations ext4_journalled_aops = {
@@ -3632,6 +3640,7 @@ static const struct address_space_operat
 	.direct_IO		= noop_direct_IO,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
+	.swap_activate		= ext4_iomap_swap_activate,
 };
 
 static const struct address_space_operations ext4_da_aops = {
@@ -3649,6 +3658,7 @@ static const struct address_space_operat
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
+	.swap_activate		= ext4_iomap_swap_activate,
 };
 
 static const struct address_space_operations ext4_dax_aops = {
@@ -3657,6 +3667,7 @@ static const struct address_space_operat
 	.set_page_dirty		= noop_set_page_dirty,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= noop_invalidatepage,
+	.swap_activate		= ext4_iomap_swap_activate,
 };
 
 void ext4_set_aops(struct inode *inode)


