Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F785942AA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349960AbiHOVxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349970AbiHOVwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:52:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47107107F1B;
        Mon, 15 Aug 2022 12:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D0416114B;
        Mon, 15 Aug 2022 19:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C7EC433C1;
        Mon, 15 Aug 2022 19:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591995;
        bh=g1Bx1HzdKI7GlDoXKpbcU4VMK32z9g/6QCn0thKghpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2smWI5GT0vrNB+BuDYCh5iWsiVHLbmdhYXJjM3tYZ+CUdJEN7eIY3+H7TwODzI8U
         RouW+0KC+teKeCuC26iMmULeIxQMzDBW4lD62irqmtM/a4PCEelZq1pClv4Kk7Ytaw
         NTcjp4W6oo9Tb/uNl3Hh6RvwL+/GW0r8uUEjQBYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0715/1095] mm: rmap: use the correct parameter name for DEFINE_PAGE_VMA_WALK
Date:   Mon, 15 Aug 2022 20:01:54 +0200
Message-Id: <20220815180458.976610783@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Yang Shi <shy828301@gmail.com>

[ Upstream commit 507db7927cd181d409dd495c8384b8e14c21c600 ]

The parameter used by DEFINE_PAGE_VMA_WALK is _page not page, fix the
parameter name.  It didn't cause any build error, it is probably because
the only caller is write_protect_page() from ksm.c, which pass in page.

Link: https://lkml.kernel.org/r/20220512174551.81279-1-shy828301@gmail.com
Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rmap.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 17230c458341..a0c4a870bb48 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -220,8 +220,8 @@ struct page_vma_mapped_walk {
 #define DEFINE_PAGE_VMA_WALK(name, _page, _vma, _address, _flags)	\
 	struct page_vma_mapped_walk name = {				\
 		.pfn = page_to_pfn(_page),				\
-		.nr_pages = compound_nr(page),				\
-		.pgoff = page_to_pgoff(page),				\
+		.nr_pages = compound_nr(_page),				\
+		.pgoff = page_to_pgoff(_page),				\
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
-- 
2.35.1



