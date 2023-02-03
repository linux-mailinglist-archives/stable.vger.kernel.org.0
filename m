Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9491F688C38
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 02:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjBCBDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 20:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjBCBDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 20:03:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C40470AE;
        Thu,  2 Feb 2023 17:03:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CACE61D3D;
        Fri,  3 Feb 2023 01:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9BDC433D2;
        Fri,  3 Feb 2023 01:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675386208;
        bh=sh0TjyWGQ9JudO9PAEgymM1IjtlW0nUu2xMRWylfafA=;
        h=From:To:Cc:Subject:Date:From;
        b=pYGKbv7GLtPxXrXlNcebSiLkqQkWtfqvrf3Ekj6KOLFIBU7lcVEq3uKBozBfFShYt
         ITK3HHTz+DRvde7O4jU3ZpH8DJGQiGWE2GujCxhwijWyEaSJuRg+nGOieKkBTAqtCv
         Z+Tpa9LXinGC7xez25ol2fXXniG0rrcQBTBm3sFfaz+rlDJd7Eh+wdyiXdPRmuM+H0
         zkyxnafvPoVAj8yKFsDIP4uwhmzLPhlP1zIVVJRUPvawAe6I93d+xGVy2kBV72PVIM
         rGcY2ZP6SAhF2ph7XhuxzocLGD7GSHJqlwdIGLXzctf6sf8ZuKJqvPAz4+oNpbTPMh
         mGGl/HxcPRdSg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Tejun Heo <tj@kernel.org>, Yufen Yu <yuyufen@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH] f2fs: fix cgroup writeback accounting with fs-layer encryption
Date:   Thu,  2 Feb 2023 17:02:39 -0800
Message-Id: <20230203010239.216421-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When writing a page from an encrypted file that is using
filesystem-layer encryption (not inline encryption), f2fs encrypts the
pagecache page into a bounce page, then writes the bounce page.

It also passes the bounce page to wbc_account_cgroup_owner().  That's
incorrect, because the bounce page is a newly allocated temporary page
that doesn't have the memory cgroup of the original pagecache page.
This makes wbc_account_cgroup_owner() not account the I/O to the owner
of the pagecache page as it should.

Fix this by always passing the pagecache page to
wbc_account_cgroup_owner().

Fixes: 578c647879f7 ("f2fs: implement cgroup writeback support")
Cc: stable@vger.kernel.org
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/data.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 754841bce389f..8a636500db0ef 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -739,7 +739,7 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc && !is_read_io(fio->op))
-		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	inc_page_count(fio->sbi, is_read_io(fio->op) ?
 			__read_io_type(page) : WB_DATA_TYPE(fio->page));
@@ -949,7 +949,7 @@ int f2fs_merge_page_bio(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc)
-		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	inc_page_count(fio->sbi, WB_DATA_TYPE(page));
 
@@ -1023,7 +1023,7 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc)
-		wbc_account_cgroup_owner(fio->io_wbc, bio_page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	io->last_block_in_bio = fio->new_blkaddr;
 

base-commit: de6b3a5e09b29c014bd04044b023896107cfa2ee
-- 
2.39.1

