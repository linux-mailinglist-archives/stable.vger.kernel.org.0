Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C292558CE98
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 21:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243446AbiHHTfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 15:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiHHTfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 15:35:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33E72E0
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 12:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=s4LgfjgMSKwodnJCulgKaAjoW6t9ZjF90g5FC669hGQ=; b=t2bXWmVScpPPjMd+JapjtU+qWL
        SRzNQkk6dpcKCvWIg5HeaC1qiplG03fkYj1DGdIdsA/a19UDoDYBTfEgfbedbVAhl61HYBhbFlD+e
        3C/A8Xe4NT6cOQ9xLykyuR6OViT1thsiXdq1AfQH82Rt2j5e1cmvs4MGVFHiYPJtLrLIGZaJIgtCN
        ecyXGtMhBBGLfaSICuKtXzlPBSyL3+jHn7ZP2ZDcRce7dQ8+NBW+u7zfB/BL0kokwOzuCKxqnQhH4
        zGiA7wGAjBRjJiihqbkKTzq6/1N14uOlhcxEECAFBfOZ7UzmjDoY8L13qUaliQ2iC9za2NWHX/pbU
        i1In/vFQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oL8WR-00EAs8-GG; Mon, 08 Aug 2022 19:34:45 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-mm@kvack.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hughd@google.com,
        stable@vger.kernel.org,
        William Kucharski <william.kucharski@oracle.com>
Subject: [PATCH 02/59] shmem: Update folio if shmem_replace_page() updates the page
Date:   Mon,  8 Aug 2022 20:33:30 +0100
Message-Id: <20220808193430.3378317-3-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220808193430.3378317-1-willy@infradead.org>
References: <20220808193430.3378317-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we allocate a new page, we need to make sure that our folio matches
that new page.  If we don't, we store the wrong folio in the shmem page
cache which will lead to data corruption.  This problem will be solved
by changing shmem_replace_page() to shmem_replace_folio(), but this
patch is the minimal fix.

Fixes: da08e9b79323 ("mm/shmem: convert shmem_swapin_page() to shmem_swapin_folio()")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index e975fcd9d2e1..4ae43cffeda3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1780,6 +1780,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 
 	if (shmem_should_replace_folio(folio, gfp)) {
 		error = shmem_replace_page(&page, gfp, info, index);
+		folio = page_folio(page);
 		if (error)
 			goto failed;
 	}
-- 
2.35.1

