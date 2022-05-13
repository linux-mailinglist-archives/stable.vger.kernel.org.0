Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A230A526427
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380734AbiEMO1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380735AbiEMOZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:25:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AEA6B67A;
        Fri, 13 May 2022 07:25:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0E6662198;
        Fri, 13 May 2022 14:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAC7C36AF6;
        Fri, 13 May 2022 14:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451921;
        bh=5bib3ZlM1WmxHuZRocWWOlskoPQq6BEw+c52UWjFo70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rr3hmb0G4sAt63ozbC/GrwwKcvK5WnhBcxE//DpR229O4ZigS2dpkiYMQbN/iEh4W
         jlga90oTVKWx5rjZTYdGoxRgqJOMxWWMTz7SpjRQlsAuYN/R227kcegB5Zf4xH30z6
         ZdywT8YsRYjHscej2V+es0gXSp4iEyBTseQgzEHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        David Rientjes <rientjes@google.com>,
        Fam Zheng <fam.zheng@bytedance.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lars Persson <lars.persson@axis.com>,
        Peter Xu <peterx@redhat.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 07/14] mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()
Date:   Fri, 13 May 2022 16:23:23 +0200
Message-Id: <20220513142227.599609402@linuxfoundation.org>
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

commit e763243cc6cb1fcc720ec58cfd6e7c35ae90a479 upstream.

userfaultfd calls copy_huge_page_from_user() which does not do any cache
flushing for the target page.  Then the target page will be mapped to
the user space with a different address (user address), which might have
an alias issue with the kernel address used to copy the data from the
user to.

Fix this issue by flushing dcache in copy_huge_page_from_user().

Link: https://lkml.kernel.org/r/20220210123058.79206-4-songmuchun@bytedance.com
Fixes: fa4d75c1de13 ("userfaultfd: hugetlbfs: add copy_huge_page_from_user for hugetlb userfaultfd support")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4836,6 +4836,8 @@ long copy_huge_page_from_user(struct pag
 		if (rc)
 			break;
 
+		flush_dcache_page(subpage);
+
 		cond_resched();
 	}
 	return ret_val;


