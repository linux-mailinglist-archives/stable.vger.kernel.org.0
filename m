Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA05D4A4280
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359782AbiAaLMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377310AbiAaLJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD073C0604D7;
        Mon, 31 Jan 2022 03:07:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B57060FE1;
        Mon, 31 Jan 2022 11:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F0DC340E8;
        Mon, 31 Jan 2022 11:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627235;
        bh=Qaq1eYmEKuHp4EfSym8gVoXa+XNpJfoIhWl2rY8NBjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJMyLzFgYUVWIHJ7hlXBfj6b2nr/4IktKqV+iy6MeN481B17wJCP6k4qoEFIv++gC
         OdiBMM/bdnd1+UbrHYyO8PUs6ICYN6Tk5bnD+NBDv4FdCKIWHEx6txWXY/qelfi9iB
         2q52EVO8qVpz3ssynHQ7hsDKEGBZhbcWI0St2G2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 018/171] udf: Fix NULL ptr deref when converting from inline format
Date:   Mon, 31 Jan 2022 11:54:43 +0100
Message-Id: <20220131105230.629229924@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 7fc3b7c2981bbd1047916ade327beccb90994eee upstream.

udf_expand_file_adinicb() calls directly ->writepage to write data
expanded into a page. This however misses to setup inode for writeback
properly and so we can crash on inode->i_wb dereference when submitting
page for IO like:

  BUG: kernel NULL pointer dereference, address: 0000000000000158
  #PF: supervisor read access in kernel mode
...
  <TASK>
  __folio_start_writeback+0x2ac/0x350
  __block_write_full_page+0x37d/0x490
  udf_expand_file_adinicb+0x255/0x400 [udf]
  udf_file_write_iter+0xbe/0x1b0 [udf]
  new_sync_write+0x125/0x1c0
  vfs_write+0x28e/0x400

Fix the problem by marking the page dirty and going through the standard
writeback path to write the page. Strictly speaking we would not even
have to write the page but we want to catch e.g. ENOSPC errors early.

Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
CC: stable@vger.kernel.org
Fixes: 52ebea749aae ("writeback: make backing_dev_info host cgroup-specific bdi_writebacks")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -258,10 +258,6 @@ int udf_expand_file_adinicb(struct inode
 	char *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	int err;
-	struct writeback_control udf_wbc = {
-		.sync_mode = WB_SYNC_NONE,
-		.nr_to_write = 1,
-	};
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
 	if (!iinfo->i_lenAlloc) {
@@ -305,8 +301,10 @@ int udf_expand_file_adinicb(struct inode
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
 	/* from now on we have normal address_space methods */
 	inode->i_data.a_ops = &udf_aops;
+	set_page_dirty(page);
+	unlock_page(page);
 	up_write(&iinfo->i_data_sem);
-	err = inode->i_data.a_ops->writepage(page, &udf_wbc);
+	err = filemap_fdatawrite(inode->i_mapping);
 	if (err) {
 		/* Restore everything back so that we don't lose data... */
 		lock_page(page);


