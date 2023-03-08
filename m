Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF456AFED2
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 07:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCHGSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 01:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHGSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 01:18:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C06558B7E;
        Tue,  7 Mar 2023 22:18:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE36CB81BC1;
        Wed,  8 Mar 2023 06:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5297FC433D2;
        Wed,  8 Mar 2023 06:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678256310;
        bh=71aPwkLQex1x+QJiLQLCx21XaqRi77OvXFklt0nE/KE=;
        h=From:To:Cc:Subject:Date:From;
        b=Wh69IBPHpiAWHCRdc7XGE9n8/3JloJVAPmdaCATTPy7SHhDBWNgYKxbHQAU54U1lm
         maBxoRoSsuxbHxhj7slzRSRmwww2Z6pIKPwxyNPJtLd+arjC09rULc4mmn2cbN39H/
         Bvt+8PUuvzp4wKYKNly6ufa4VQmvQ2k7TyvEhbaECTKv9Sg3E3hfqSwBgnqBRa8Bzy
         vC4allIJ6HIzjfNwAdyhf6c5WO7vDydIokwoJcc5gD3gkJCptk0GvzHUxVpuasHjoR
         ghENndS5CCqEd5PMVw0NyWP3pEfyQOCR7goG/9TgXY7m86TMMnXNqWBYdk15BxdiPE
         Rl7ISFoRSasGw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Tejun Heo <tj@kernel.org>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.19] f2fs: fix cgroup writeback accounting with fs-layer encryption
Date:   Tue,  7 Mar 2023 22:17:46 -0800
Message-Id: <20230308061746.711142-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 844545c51a5b2a524b22a2fe9d0b353b827d24b4 upstream.

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
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c63f5e32630ee..56b2dadd623b2 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -464,7 +464,7 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc && !is_read_io(fio->op))
-		wbc_account_io(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_io(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	bio_set_op_attrs(bio, fio->op, fio->op_flags);
 
@@ -533,7 +533,7 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc)
-		wbc_account_io(fio->io_wbc, bio_page, PAGE_SIZE);
+		wbc_account_io(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	io->last_block_in_bio = fio->new_blkaddr;
 	f2fs_trace_ios(fio, 0);
-- 
2.39.2

