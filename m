Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEEA161B53
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgBQTNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:13:14 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41915 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728467AbgBQTNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:13:13 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DA62A21FC3;
        Mon, 17 Feb 2020 14:13:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:13:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Q1vqXA
        QhBHkhpwBJNcngzm+w5jt+i7U2nk8PXe92HYA=; b=UzV0xqtwkvrfqv3tvCWUUb
        9iCxtOO1mAMsjYl75S1x+22MVz6i7B7ech987Zptsz1X+xUtFXJwaTEvATCOmwHW
        +Qqekm3r28H5WF5iOdHRNRExe+uO3IoIx5BnTlrlNb7zfLCddnRAfFqy0Rt6CXsE
        TVH2PyLcMk4qEf5KyjV3gaf6q3rJ/GX+co/JEth6Uzsc3lPOW8wadNP7LMDocuQI
        8hRalqHUz/rKYMcGuIly2QrAKD4FsZeyyGiUjON/VNRt2NuIw9HaVL5IK/9+6CTp
        DD2ywJveLsOkBZWhBEB1xWjAS0q9AH68MM47gFWnBrS3LoRmMkDcNg91bDJM8IUw
        ==
X-ME-Sender: <xms:yOVKXhx2lvqsbEuXUVRzrv7ITRGvshbO50UT_CpjQUmQgiS57m9mcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:yOVKXoUIWcrkmxtTkKwj1O892ycc_5sncc2FpIl1ky0Ym6h6lDN49Q>
    <xmx:yOVKXjBA9l-xM6vKcCS6aj5X3rva0sMxMfGp7eR28RPSADvgvoepNw>
    <xmx:yOVKXp4o069zgepbGnATlEitv803wUt_MAMe2vNbfoXzum-uB17p2A>
    <xmx:yOVKXq6UkmUIswlR-J9ZTFy4-zCy5G2O8InX3taIZlZGG1M6vgle7g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A230328005E;
        Mon, 17 Feb 2020 14:13:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] jbd2: do not clear the BH_Mapped flag when forgetting a" failed to apply to 5.4-stable tree
To:     yi.zhang@huawei.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:13:11 +0100
Message-ID: <158196679125313@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c96dceeabf765d0b1b1f29c3bf50a5c01315b820 Mon Sep 17 00:00:00 2001
From: "zhangyi (F)" <yi.zhang@huawei.com>
Date: Thu, 13 Feb 2020 14:38:21 +0800
Subject: [PATCH] jbd2: do not clear the BH_Mapped flag when forgetting a
 metadata buffer

Commit 904cdbd41d74 ("jbd2: clear dirty flag when revoking a buffer from
an older transaction") set the BH_Freed flag when forgetting a metadata
buffer which belongs to the committing transaction, it indicate the
committing process clear dirty bits when it is done with the buffer. But
it also clear the BH_Mapped flag at the same time, which may trigger
below NULL pointer oops when block_size < PAGE_SIZE.

rmdir 1             kjournald2                 mkdir 2
                    jbd2_journal_commit_transaction
		    commit transaction N
jbd2_journal_forget
set_buffer_freed(bh1)
                    jbd2_journal_commit_transaction
                     commit transaction N+1
                     ...
                     clear_buffer_mapped(bh1)
                                               ext4_getblk(bh2 ummapped)
                                               ...
                                               grow_dev_page
                                                init_page_buffers
                                                 bh1->b_private=NULL
                                                 bh2->b_private=NULL
                     jbd2_journal_put_journal_head(jh1)
                      __journal_remove_journal_head(hb1)
		       jh1 is NULL and trigger oops

*) Dir entry block bh1 and bh2 belongs to one page, and the bh2 has
   already been unmapped.

For the metadata buffer we forgetting, we should always keep the mapped
flag and clear the dirty flags is enough, so this patch pick out the
these buffers and keep their BH_Mapped flag.

Link: https://lore.kernel.org/r/20200213063821.30455-3-yi.zhang@huawei.com
Fixes: 904cdbd41d74 ("jbd2: clear dirty flag when revoking a buffer from an older transaction")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 6396fe70085b..27373f5792a4 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -985,12 +985,29 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		 * pagesize and it is attached to the last partial page.
 		 */
 		if (buffer_freed(bh) && !jh->b_next_transaction) {
+			struct address_space *mapping;
+
 			clear_buffer_freed(bh);
 			clear_buffer_jbddirty(bh);
-			clear_buffer_mapped(bh);
-			clear_buffer_new(bh);
-			clear_buffer_req(bh);
-			bh->b_bdev = NULL;
+
+			/*
+			 * Block device buffers need to stay mapped all the
+			 * time, so it is enough to clear buffer_jbddirty and
+			 * buffer_freed bits. For the file mapping buffers (i.e.
+			 * journalled data) we need to unmap buffer and clear
+			 * more bits. We also need to be careful about the check
+			 * because the data page mapping can get cleared under
+			 * out hands, which alse need not to clear more bits
+			 * because the page and buffers will be freed and can
+			 * never be reused once we are done with them.
+			 */
+			mapping = READ_ONCE(bh->b_page->mapping);
+			if (mapping && !sb_is_blkdev_sb(mapping->host->i_sb)) {
+				clear_buffer_mapped(bh);
+				clear_buffer_new(bh);
+				clear_buffer_req(bh);
+				bh->b_bdev = NULL;
+			}
 		}
 
 		if (buffer_jbddirty(bh)) {

