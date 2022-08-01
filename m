Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0137058699D
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiHAMFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbiHAME0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:04:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0655B57273;
        Mon,  1 Aug 2022 04:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40839B81163;
        Mon,  1 Aug 2022 11:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F60C433C1;
        Mon,  1 Aug 2022 11:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354864;
        bh=kdVP2qKbvN4yMUOSpwx8raN54nwWbc4Q2QdJKyqjSgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2Grp/VLrbgeiJ9i73E0u7sUBuRpnr7yOdB1PBtZwIqxjGNlWhZGvMbKFY8IEjykH
         RnDB1sCO+Coc1c20CVcrR9Xu4ENi8ViC5Tquulf4YqiutcHqSfnQ6g20ncgvChwpG1
         d0rWHzBOS+8BM+FQJRxuoRb2ndD2OwDmqvxEFTFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 07/69] hugetlb: fix memoryleak in hugetlb_mcopy_atomic_pte
Date:   Mon,  1 Aug 2022 13:46:31 +0200
Message-Id: <20220801114134.777267366@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit da9a298f5fad0dc615079a340da42928bc5b138e upstream.

When alloc_huge_page fails, *pagep is set to NULL without put_page first.
So the hugepage indicated by *pagep is leaked.

Link: https://lkml.kernel.org/r/20220709092629.54291-1-linmiaohe@huawei.com
Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5314,6 +5314,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 
 		page = alloc_huge_page(dst_vma, dst_addr, 0);
 		if (IS_ERR(page)) {
+			put_page(*pagep);
 			ret = -ENOMEM;
 			*pagep = NULL;
 			goto out;


