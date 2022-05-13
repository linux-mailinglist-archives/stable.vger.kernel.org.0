Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC1D526418
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376717AbiEMO0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380804AbiEMO0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:26:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190C7703C9;
        Fri, 13 May 2022 07:25:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B4C4B83067;
        Fri, 13 May 2022 14:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E0AC34100;
        Fri, 13 May 2022 14:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451924;
        bh=BnUqdEQGEPbknIZnHajauNa2KvRNMzyeBw1rjKiAtH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMEotatgWKMp6SH6FqwD0Bdc0urJX4Ghj9sNvw7fI7+Z+zSy46m6f3W5umdM8rnMG
         IKz4I/KsM8ezMnBhZ1Pxb5FWnJJUjYd9J7gfh/vG4IRs3yF5BAba5q8ZqTP82KwU2h
         ElI4HEbLNa5HPXT9gOGkruGRGJgWPTO4hrjJsKj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        David Rientjes <rientjes@google.com>,
        Fam Zheng <fam.zheng@bytedance.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lars Persson <lars.persson@axis.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 08/14] mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()
Date:   Fri, 13 May 2022 16:23:24 +0200
Message-Id: <20220513142227.628984243@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142227.381154244@linuxfoundation.org>
References: <20220513142227.381154244@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 7c25a0b89a487878b0691e6524fb5a8827322194 upstream.

userfaultfd calls mcopy_atomic_pte() and __mcopy_atomic() which do not
do any cache flushing for the target page.  Then the target page will be
mapped to the user space with a different address (user address), which
might have an alias issue with the kernel address used to copy the data
from the user to.  Fix this by insert flush_dcache_page() after
copy_from_user() succeeds.

Link: https://lkml.kernel.org/r/20220210123058.79206-7-songmuchun@bytedance.com
Fixes: b6ebaedb4cb1 ("userfaultfd: avoid mmap_sem read recursion in mcopy_atomic")
Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -56,6 +56,8 @@ static int mcopy_atomic_pte(struct mm_st
 			/* don't free the page */
 			goto out;
 		}
+
+		flush_dcache_page(page);
 	} else {
 		page = *pagep;
 		*pagep = NULL;
@@ -565,6 +567,7 @@ retry:
 				err = -EFAULT;
 				goto out;
 			}
+			flush_dcache_page(page);
 			goto retry;
 		} else
 			BUG_ON(page);


