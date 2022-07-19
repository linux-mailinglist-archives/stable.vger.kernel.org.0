Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352F3579D43
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbiGSMuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241667AbiGSMsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:48:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A45D8D5DE;
        Tue, 19 Jul 2022 05:19:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C87B1B81B10;
        Tue, 19 Jul 2022 12:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2436FC341C6;
        Tue, 19 Jul 2022 12:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233128;
        bh=rgXUttIrCJXhvzmAYfs7u6gm3QoGgvQv12sDrFaR+NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=saoscKWLpcMEYxPjuCCHKFRUasGZNXccDEkqiKKPAR+GTsPRNtXkdYHkNCU1V55kQ
         zpqZUwsBthor76/OgeA3HC2/EpENZH+nr4Y8ZOT5C8nkrqJtrkfi/B+Gcm6+sJJ5dz
         ZQ1nnVv/Ml8OVkEs2gr+9zJcNY0KYPJ1lj17Yo1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 016/231] mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages
Date:   Tue, 19 Jul 2022 13:51:41 +0200
Message-Id: <20220719114715.404069935@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>

commit 73f37dbcfe1763ee2294c7717a1f571e27d17fd8 upstream.

When fallocate() is used on a shmem file, the pages we allocate can end up
with !PageUptodate.

Since UFFDIO_CONTINUE tries to find the existing page the user wants to
map with SGP_READ, we would fail to find such a page, since
shmem_getpage_gfp returns with a "NULL" pagep for SGP_READ if it discovers
!PageUptodate.  As a result, UFFDIO_CONTINUE returns -EFAULT, as it would
do if the page wasn't found in the page cache at all.

This isn't the intended behavior.  UFFDIO_CONTINUE is just trying to find
if a page exists, and doesn't care whether it still needs to be cleared or
not.  So, instead of SGP_READ, pass in SGP_NOALLOC.  This is the same,
except for one critical difference: in the !PageUptodate case, SGP_NOALLOC
will clear the page and then return it.  With this change, UFFDIO_CONTINUE
works properly (succeeds) on a shmem file which has been fallocated, but
otherwise not modified.

Link: https://lkml.kernel.org/r/20220610173812.1768919-1-axelrasmussen@google.com
Fixes: 153132571f02 ("userfaultfd/shmem: support UFFDIO_CONTINUE for shmem")
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -231,7 +231,10 @@ static int mcontinue_atomic_pte(struct m
 	struct page *page;
 	int ret;
 
-	ret = shmem_getpage(inode, pgoff, &page, SGP_READ);
+	ret = shmem_getpage(inode, pgoff, &page, SGP_NOALLOC);
+	/* Our caller expects us to return -EFAULT if we failed to find page. */
+	if (ret == -ENOENT)
+		ret = -EFAULT;
 	if (ret)
 		goto out;
 	if (!page) {


