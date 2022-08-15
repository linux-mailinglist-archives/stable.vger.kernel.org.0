Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1E0594C40
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345297AbiHPAoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345911AbiHPAnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:43:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E1ED4198;
        Mon, 15 Aug 2022 13:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6B4FB8113E;
        Mon, 15 Aug 2022 20:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01238C433D6;
        Mon, 15 Aug 2022 20:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596015;
        bh=qV18CXrqDsPNUqyyYXpbc7vK2XRoYEx8HCVgIpmxHzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZ36c4wPjYJKo9k/mi7jvIavSowe9ttlx1hxb7olUWcsCFV96nCGxTzuwIg8kqOtp
         3k1/zEGe/6rEyUTiJFS6QfqT7hckTskZsyZrA7QqfGXYaQYgGpyS0Ij/V1OIusHucA
         fTSHQ5/R7tLCh9Czr/VW0DvoTFvObXPNVq37PUZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0947/1157] MIPS: vdso: Utilize __pa() for gic_pfn
Date:   Mon, 15 Aug 2022 20:05:03 +0200
Message-Id: <20220815180517.440734427@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 8baa65126e19af5ee9f3c07e7bb53da41c39e4b1 ]

The GIC user offset is mapped into every process' virtual address and is
therefore part of the hot-path of arch_setup_additional_pages(). Utilize
__pa() such that we are more optimal even when CONFIG_DEBUG_VIRTUAL is
enabled, and while at it utilize PFN_DOWN() instead of open-coding the
right shift by PAGE_SHIFT.

Reported-by: Greg Ungerer <gerg@kernel.org>
Suggested-by: Serge Semin <fancer.lancer@gmail.com>
Fixes: dfad83cb7193 ("MIPS: Add support for CONFIG_DEBUG_VIRTUAL")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Greg Ungerer <gerg@kernel.org>
Tested-by: Greg Ungerer <gerg@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/vdso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/vdso.c b/arch/mips/kernel/vdso.c
index 3d0cf471f2fe..b2cc2c2dd4bf 100644
--- a/arch/mips/kernel/vdso.c
+++ b/arch/mips/kernel/vdso.c
@@ -159,7 +159,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	/* Map GIC user page. */
 	if (gic_size) {
 		gic_base = (unsigned long)mips_gic_base + MIPS_GIC_USER_OFS;
-		gic_pfn = virt_to_phys((void *)gic_base) >> PAGE_SHIFT;
+		gic_pfn = PFN_DOWN(__pa(gic_base));
 
 		ret = io_remap_pfn_range(vma, base, gic_pfn, gic_size,
 					 pgprot_noncached(vma->vm_page_prot));
-- 
2.35.1



