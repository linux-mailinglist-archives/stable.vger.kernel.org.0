Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EC05B72FD
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiIMOzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234916AbiIMOy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:54:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A8961DA8;
        Tue, 13 Sep 2022 07:27:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A12B6149A;
        Tue, 13 Sep 2022 14:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCFCC433C1;
        Tue, 13 Sep 2022 14:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079224;
        bh=HIwObJix9snZnRkVEs8M9xKIS0QUfoTij0k/p3Vp2Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uM/vAbnfheuMmFiwIBiXACB0HgEHzwb0BnVkHzAHdGRg3Zq0nrYJT/wSUbcHmzQzq
         JvFPrixhoa+OVD2LVr3ylD8YK7JJrhNYm1rwXbf1qcysKA83UrwOgl8UGp6hDQx9qC
         Gev6L+8H/H/yNuBzlVUZ6ztxnV1S43Q4IGIaezeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 051/108] s390/hugetlb: fix prepare_hugepage_range() check for 2 GB hugepages
Date:   Tue, 13 Sep 2022 16:06:22 +0200
Message-Id: <20220913140355.826614561@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
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
@@ -35,9 +35,11 @@ static inline bool is_hugepage_only_rang
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


