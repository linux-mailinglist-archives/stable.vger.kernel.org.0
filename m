Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B4234410C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhCVMa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhCVM37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:29:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E006198D;
        Mon, 22 Mar 2021 12:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416199;
        bh=F6eJdsfBnDfsHw+AImRtdS79Z0OYcORfJ2XfboM13Oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3gWKzlV4nt1KrV5lcZY96hx1kwH6BPwE6t7XZ0j3yikroUGp4X2e7HL3H4JNtvfr
         yOrBcDsCMqXGQ0Wkka7+RG2WOJ6/eygfDmsmfTP2YCuaahKrHKuvNlkVQobgHHbA/j
         s9nEHzY/1Qf+d54EOUMahhsjdhX8Y4eBNZo8JkGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5.11 017/120] zonefs: prevent use of seq files as swap file
Date:   Mon, 22 Mar 2021 13:26:40 +0100
Message-Id: <20210322121930.246636328@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 1601ea068b886da1f8f8d4e18b9403e9e24adef6 upstream.

The sequential write constraint of sequential zone file prevent their
use as swap files. Only allow conventional zone files to be used as swap
files.

Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Cc: <stable@vger.kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -159,6 +159,21 @@ static int zonefs_writepages(struct addr
 	return iomap_writepages(mapping, wbc, &wpc, &zonefs_writeback_ops);
 }
 
+static int zonefs_swap_activate(struct swap_info_struct *sis,
+				struct file *swap_file, sector_t *span)
+{
+	struct inode *inode = file_inode(swap_file);
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+
+	if (zi->i_ztype != ZONEFS_ZTYPE_CNV) {
+		zonefs_err(inode->i_sb,
+			   "swap file: not a conventional zone file\n");
+		return -EINVAL;
+	}
+
+	return iomap_swapfile_activate(sis, swap_file, span, &zonefs_iomap_ops);
+}
+
 static const struct address_space_operations zonefs_file_aops = {
 	.readpage		= zonefs_readpage,
 	.readahead		= zonefs_readahead,
@@ -171,6 +186,7 @@ static const struct address_space_operat
 	.is_partially_uptodate	= iomap_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 	.direct_IO		= noop_direct_IO,
+	.swap_activate		= zonefs_swap_activate,
 };
 
 static void zonefs_update_stats(struct inode *inode, loff_t new_isize)


