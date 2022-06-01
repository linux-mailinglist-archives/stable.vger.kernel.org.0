Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A55C53A776
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354084AbiFAOB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354159AbiFAOAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D78FA26C5;
        Wed,  1 Jun 2022 06:56:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13987B81AE7;
        Wed,  1 Jun 2022 13:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5928EC34119;
        Wed,  1 Jun 2022 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091738;
        bh=p/08dZfZ7CBeLXRE9nPAnm/+jHFflppoG/BYqplNPyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oI+weow2Hxnk/ca6LkJimSB3MFXtgSAFdQP+VHnVeZNcv3YGMTe93wqGtBlOulhL5
         KyLeHbTAE67fIFjNA+tSCDxjU3KMlrkJyFo7uiF8eHlmgtW178NKk+7m+L6Ub0/hfx
         azVqByBKUthIpq48dSuBQRkoKyDJzT2VcsxqIehJ9XpIngEtscqxDWqt8YUMDpygxz
         MY4Gg8cZKZEAJPr/XKseRy6Nv+rJp6THGHk5lt8xEPho9vTR37mHRtHjWAPkMfBBbL
         7JstK1rs6p73NLMqhBQcUjdBtBsQFD2bbPrMUk6kyiOJLcsNpt5Tx2IOO6EsoN5QKa
         AWkwFheT7zrYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com, pcc@google.com,
        will@kernel.org, catalin.marinas@arm.com,
        linux-alpha@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 33/48] alpha: fix alloc_zeroed_user_highpage_movable()
Date:   Wed,  1 Jun 2022 09:54:06 -0400
Message-Id: <20220601135421.2003328-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit f9c668d281aa20e38c9bda3b7b0adeb8891aa15e ]

Due to a typo, the final argument to alloc_page_vma() didn't refer to a
real variable.  This only affected CONFIG_NUMA, which was marked BROKEN in
2006 and removed from alpha in 2021.  Found due to a refactoring patch.

Link: https://lkml.kernel.org/r/20220504182857.4013401-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/page.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
index 18f48a6f2ff6..8f3f5eecba28 100644
--- a/arch/alpha/include/asm/page.h
+++ b/arch/alpha/include/asm/page.h
@@ -18,7 +18,7 @@ extern void clear_page(void *page);
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 
 #define alloc_zeroed_user_highpage_movable(vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vmaddr)
+	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
 
 extern void copy_page(void * _to, void * _from);
-- 
2.35.1

