Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1807D5AEB97
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241094AbiIFOLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241579AbiIFOKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D9687685;
        Tue,  6 Sep 2022 06:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D17E961552;
        Tue,  6 Sep 2022 13:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2C1C433C1;
        Tue,  6 Sep 2022 13:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472045;
        bh=A2SlET5mA2JB6GyGY8Cy5ilZkG92iGR0V0gDf6pDXZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhYSa2wkm7S72P63Ne6T3vyZFD93NoVnZCjtFvb1IeO9Q+7sNKQnOsm9hbpYnat2/
         MvXiQVMBhEeZFFPt9TYvUAf/uuk3S8r95s3j0Jf1U8n/woPue+atuIKh7laAuXmH+c
         3QisGAmDPvwtbMNH4RAZGvgyBl9SMCAaxO/z7rJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.19 128/155] s390/hugetlb: fix prepare_hugepage_range() check for 2 GB hugepages
Date:   Tue,  6 Sep 2022 15:31:16 +0200
Message-Id: <20220906132834.852956422@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit 7c8d42fdf1a84b1a0dd60d6528309c8ec127e87c upstream.

The alignment check in prepare_hugepage_range() is wrong for 2 GB
hugepages, it only checks for 1 MB hugepage alignment.

This can result in kernel crash in __unmap_hugepage_range() at the
BUG_ON(start & ~huge_page_mask(h)) alignment check, for mappings
created with MAP_FIXED at unaligned address.

Fix this by correctly handling multiple hugepage sizes, similar to the
generic version of prepare_hugepage_range().

Fixes: d08de8e2d867 ("s390/mm: add support for 2GB hugepages")
Cc: <stable@vger.kernel.org> # 4.8+
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/hugetlb.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/hugetlb.h
+++ b/arch/s390/include/asm/hugetlb.h
@@ -28,9 +28,11 @@ pte_t huge_ptep_get_and_clear(struct mm_
 static inline int prepare_hugepage_range(struct file *file,
 			unsigned long addr, unsigned long len)
 {
-	if (len & ~HPAGE_MASK)
+	struct hstate *h = hstate_file(file);
+
+	if (len & ~huge_page_mask(h))
 		return -EINVAL;
-	if (addr & ~HPAGE_MASK)
+	if (addr & ~huge_page_mask(h))
 		return -EINVAL;
 	return 0;
 }


