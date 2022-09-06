Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33C45AEB02
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbiIFNvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239826AbiIFNuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:50:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895192D1DF;
        Tue,  6 Sep 2022 06:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6641B81632;
        Tue,  6 Sep 2022 13:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0864FC433D7;
        Tue,  6 Sep 2022 13:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471604;
        bh=A2SlET5mA2JB6GyGY8Cy5ilZkG92iGR0V0gDf6pDXZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPgrDvAh8SEyaSyDKbB/q4E2ESvFcWC8EHXmqUU1RzO8v376A6CNxNfim7HG0RHbB
         JmyGcRCxbUzelnYv32g3Bsh8xIpoe5jdMAmeRGoV0Rii+cW5FhD8c+GgVkkYdSv5q3
         5D4TCTXeCQK/tq3FkO2zH5knTrznn0Xjn8ZMGEM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 083/107] s390/hugetlb: fix prepare_hugepage_range() check for 2 GB hugepages
Date:   Tue,  6 Sep 2022 15:31:04 +0200
Message-Id: <20220906132825.332735623@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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


