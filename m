Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F5F67FED8
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 13:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjA2MTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 07:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjA2MTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 07:19:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE2B19F04;
        Sun, 29 Jan 2023 04:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=HThgw7sl6uJJTesezO0n2kqBMrE2goYpe6c6Ta3USks=; b=EefxzS7qsdrMJ33t6t/RxOs1cF
        FV582ZbD9kbJF1oWPtMVHZZ7x8wivZHz9NBnafc9EQr/0K2vJQU+Z0x7LqcsLDBKk+e5XE+FULm5m
        ysdDb9I5zBGFpLdZHmgIt+D1JbL8vXQ0/lI3Tmd9NiWQBASUfqnjCFIWJWcvte7Q1yxLxVnbgjD3C
        hT9MxPZMQLKwITnYkbVY2WgKQpbC0tP1yhBCGCK2cTygOA/QbYOvtLUxyRApWKYorNRdIKmxUUiJe
        epIgGDbsjR/AiXpV3k+fDCKBFtiSlyugH1dyoHv4LUIeXcSMxiWoQEEh8gcw1SD/cLJRSC0C8yszK
        p5EULVgg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pM6e5-009QuN-2U; Sun, 29 Jan 2023 12:18:53 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: [PATCH] fscrypt: Copy the memcg information to the ciphertext page
Date:   Sun, 29 Jan 2023 12:18:51 +0000
Message-Id: <20230129121851.2248378-1-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Both f2fs and ext4 end up passing the ciphertext page to
wbc_account_cgroup_owner().  At the moment, the ciphertext page appears
to belong to no cgroup, so it is accounted to the root_mem_cgroup instead
of whatever cgroup the original page was in.

It's hard to say how far back this is a bug.  The crypto code shared
between ext4 & f2fs was created in May 2015 with commit 0b81d0779072,
but neither filesystem did anything with memcg_data before then.  memcg
writeback accounting was added to ext4 in July 2015 in commit 001e4a8775f6
and it wasn't added to f2fs until January 2018 (commit 578c647879f7).

I'm going with the ext4 commit since this is the first commit where
there was a difference in behaviour between encrypted and unencrypted
filesystems.

Fixes: 001e4a8775f6 ("ext4: implement cgroup writeback support")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/crypto/crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index e78be66bbf01..a4e76f96f291 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -205,6 +205,9 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
 	}
 	SetPagePrivate(ciphertext_page);
 	set_page_private(ciphertext_page, (unsigned long)page);
+#ifdef CONFIG_MEMCG
+	ciphertext_page->memcg_data = page->memcg_data;
+#endif
 	return ciphertext_page;
 }
 EXPORT_SYMBOL(fscrypt_encrypt_pagecache_blocks);
-- 
2.35.1

