Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B340C567C81
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 05:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiGFDVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 23:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGFDVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 23:21:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264901658E;
        Tue,  5 Jul 2022 20:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U90vDWhmtLUBjb7uR4WRLKqovMSNNsXOIU8h7uSvzmI=; b=O9ay8Sm1HAiGOn+laSqNQ9UT9I
        qjvjJX34w8wZjox8wlNh/CeF4TXKKy7kerRsOZGMMhDbvIjl2NeMVSyXnQuOCSu9QYWEPwieQnfcY
        NKn7BmjFe881o29UvYRJBp4s1F2I8K6cnsvKAC8LwbmhpI7r8iL2Wr/1QkjBP9Ixer1B4QpXY8K9E
        u8JTeRPFLuekwEWD2lRmWVE2nTdibJQr6tO1kPMWgOtqRN1bsLYaWR0TZDiR3pv2gDOS3AIs5OFn8
        cKhZ3WbKhylEqTuOWZD85CVkeXBC77TbMHkq8CiE05Ur9YQG8tx4YfF7twXLQHJI8/0ZtAEBVrlOt
        Yq94NsLA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8vbE-0019a9-4Y; Wed, 06 Jul 2022 03:21:12 +0000
Date:   Wed, 6 Jul 2022 04:21:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.15] mm/filemap: fix UAF in find_lock_entries
Message-ID: <YsT/qAPruIimH3+R@casper.infradead.org>
References: <20220706032434.579610-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706032434.579610-1-liushixin2@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 06, 2022 at 11:24:34AM +0800, Liu Shixin wrote:
> Release refcount after xas_set to fix UAF which may cause panic like this:

I think we can do better.  How about this?

diff --git a/mm/filemap.c b/mm/filemap.c
index 00e391e75880..11ae38cc4fd3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2090,7 +2090,9 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
 
 	rcu_read_lock();
 	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
+		unsigned long next_idx = xas.xa_index + 1;
 		if (!xa_is_value(page)) {
+			next_idx = page->index + thp_nr_pages(page);
 			if (page->index < start)
 				goto put;
 			if (page->index + thp_nr_pages(page) - 1 > end)
@@ -2111,14 +2113,11 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t start,
 put:
 		put_page(page);
 next:
-		if (!xa_is_value(page) && PageTransHuge(page)) {
-			unsigned int nr_pages = thp_nr_pages(page);
-
-			/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
-			xas_set(&xas, page->index + nr_pages);
-			if (xas.xa_index < nr_pages)
-				break;
-		}
+		/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
+		if (next_idx < xas.xa_index)
+			break;
+		if (next_idx != xas.xa_index + 1)
+			xas_set(&xas, next_idx);
 	}
 	rcu_read_unlock();
 
