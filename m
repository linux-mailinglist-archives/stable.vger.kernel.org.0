Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6356492368
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 10:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbiARJ56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 04:57:58 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:36306 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbiARJ55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 04:57:57 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 506141F3B5;
        Tue, 18 Jan 2022 09:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642499876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3XHy9X4nT4n/AOl8C5jRxanVGoZKrHcxVdhA2eEHek=;
        b=20G7MBWNASyhjzIRqO/wD3Omch4/okChGRHAV/Ho3cjNCv5eqgBvExjngNEVnkMBKyZmwO
        bRR6hi/RFQO55mgHh35pKCjVTYROKxDv9QffcgqDaHOq5NgT7GJYLqwEkE9HCVGovFJ2I3
        WPqrMiiFWmy2aQZe/JjIqCQ/QaSnwp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642499876;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3XHy9X4nT4n/AOl8C5jRxanVGoZKrHcxVdhA2eEHek=;
        b=2cy+F4YyWFsf2cOPtbUZi1yV8hkde0hTPF52ohSwMtf0yXTRLX7kv9p1f17X54v5T7hxld
        BdCVbRO1o0j5qdBg==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 424C0A3B84;
        Tue, 18 Jan 2022 09:57:56 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 0E273A05E2; Tue, 18 Jan 2022 10:57:56 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 1/2] udf: Fix NULL ptr deref when converting from inline format
Date:   Tue, 18 Jan 2022 10:57:47 +0100
Message-Id: <20220118095753.627-1-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220118095449.2937-1-jack@suse.cz>
References: <20220118095449.2937-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2065; h=from:subject; bh=FGffWwKHxuxdIhhc030juu+3b62d1QHrgbzzRo6D37M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh5o8bFuYJbn9NJOogzMDzDzPAL/JbmS3e2a6Ic1LL Thbto/uJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYeaPGwAKCRCcnaoHP2RA2assB/ 46PhShSLxTJQt7WycODga3L1jqcwIJaJxxwNQr8us4gqu4/pcRStlz8jawMoesNKTK9vBe7YwQOHIe /d164ew7fz3aT2XDhUoaezfRpbmmnROExRo0RH0tVigLmJIWCZ6NrJThdt5b2qWmeUyIqEoMDqHS0q ZYOLSQh3XMH6FwLTstUjxCu8YZ4hcVPuZvPkEyNnt0p86LOI2Q7L+UpM0+COYPbldAk6PtwlM0U26w nPjxDd4ZeNbVpf+Nq1OyhOt+CeAhd5R3e3Q6/FXbH0treLPEs39Q9g0d7JPIYRmUU9qKy6/3VqMxWB SxYrfk/yQcm3w4PSC39nLO35mzCnyJ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 1d6b7a50736b..d6aa506b6b58 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -258,10 +258,6 @@ int udf_expand_file_adinicb(struct inode *inode)
 	char *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	int err;
-	struct writeback_control udf_wbc = {
-		.sync_mode = WB_SYNC_NONE,
-		.nr_to_write = 1,
-	};
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
 	if (!iinfo->i_lenAlloc) {
@@ -305,8 +301,10 @@ int udf_expand_file_adinicb(struct inode *inode)
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
-- 
2.31.1

