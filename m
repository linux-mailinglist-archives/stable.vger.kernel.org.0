Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F851720E9
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbgB0Npk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:45:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729271AbgB0Npj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:45:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 584DD20726;
        Thu, 27 Feb 2020 13:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811138;
        bh=JYXDpIIfUeYJMHVkNrmOhnzX9bAbLfJyE+fD7gpTHi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ART/o4x3e4vwH0ZgFBaEal7HmKibWwynCEuNx4qj96BajM2gt/8hr1rG86Lby2NmR
         ODUMYPKBMU3zygpHLTI4bhTtg7BS14becbsbdXrC0tY3CQDnBU9wfk9BPhusmzwkE4
         Y5wUw/Hopit3dxTT2f1R3SPEDpjRuNvKirtMQf/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "zhangyi (F)" <yi.zhang@huawei.com>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 018/165] jbd2: do not clear the BH_Mapped flag when forgetting a metadata buffer
Date:   Thu, 27 Feb 2020 14:34:52 +0100
Message-Id: <20200227132233.672887457@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

[ Upstream commit c96dceeabf765d0b1b1f29c3bf50a5c01315b820 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/commit.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 2ee0013d86af5..72b5bbfd38447 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -978,12 +978,29 @@ void jbd2_journal_commit_transaction(journal_t *journal)
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
-- 
2.20.1



