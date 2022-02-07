Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B87D4ABAA1
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383971AbiBGLYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355265AbiBGLIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:08:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4B7C043188;
        Mon,  7 Feb 2022 03:08:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06C6C61261;
        Mon,  7 Feb 2022 11:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A50C004E1;
        Mon,  7 Feb 2022 11:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232092;
        bh=0Cq6hiZ7YsNrUK6HHr6pAyM3KJv2Ya2Cm6SehmCrLPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSJUysm18/oyoMMtpvlOv+ZYT07FBhVEMW9kPaOKFCFDFUa7oLA+qDOLoIPr8CJ3+
         97NchBGB+xBtxugzLFoO2qhGu2ZG+avma3pfAasaRymakp28+CYMb0KnoZYILcC8ko
         8gYPG9Lvo/ueHqmlT2JroxRKzxeF4ouzCClrIgOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.9 06/48] udf: Fix NULL ptr deref when converting from inline format
Date:   Mon,  7 Feb 2022 12:05:39 +0100
Message-Id: <20220207103752.548604476@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
@@ -259,10 +259,6 @@ int udf_expand_file_adinicb(struct inode
 	char *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	int err;
-	struct writeback_control udf_wbc = {
-		.sync_mode = WB_SYNC_NONE,
-		.nr_to_write = 1,
-	};
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
 	if (!iinfo->i_lenAlloc) {
@@ -306,8 +302,10 @@ int udf_expand_file_adinicb(struct inode
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


