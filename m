Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F0C52642A
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380776AbiEMO1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358882AbiEMO0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:26:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6032F2D8;
        Fri, 13 May 2022 07:26:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FB10B8305B;
        Fri, 13 May 2022 14:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42130C34100;
        Fri, 13 May 2022 14:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452009;
        bh=LlQbheZQzV7Mk0qNq8vbWSUFM1smMc3+eMIRlpmwgXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KV47AoiEIkpKoNg1ijZxYQCnnG76e13cx9ysV9fX+0Hi4ZdRVBiPhvr6FsG52KLvJ
         7p3xtJdG8UAI4pDRDTq3qXroCfTXJOl2UTgjjgp8wWtDfgp5CyrQrDo4tgIVeHQsO6
         OFlmAvXAyIH9siYkov7M5S4rDHs00OThNlY26sug=
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
Subject: [PATCH 5.4 18/18] mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()
Date:   Fri, 13 May 2022 16:23:44 +0200
Message-Id: <20220513142229.682741906@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.153291230@linuxfoundation.org>
References: <20220513142229.153291230@linuxfoundation.org>
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
@@ -53,6 +53,8 @@ static int mcopy_atomic_pte(struct mm_st
 			/* don't free the page */
 			goto out;
 		}
+
+		flush_dcache_page(page);
 	} else {
 		page = *pagep;
 		*pagep = NULL;
@@ -572,6 +574,7 @@ retry:
 				err = -EFAULT;
 				goto out;
 			}
+			flush_dcache_page(page);
 			goto retry;
 		} else
 			BUG_ON(page);


