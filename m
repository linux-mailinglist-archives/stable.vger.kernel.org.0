Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4948563DEC1
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiK3Sk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiK3Sk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:40:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D779097012
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:40:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7293A61D21
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F92C433C1;
        Wed, 30 Nov 2022 18:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833625;
        bh=wrwmUT9CGF7VPCAMKuCM/INJr3l8x1wMFRTeW9wPXOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=de0CFRgmXJD+DgYoaVlkkhSMnBM1vpqsE+2RjnBE1llmAxIHwylf+menTQM6ThZhY
         kZ7GW0Kvcnk+0vErFPwAASs976C/TIJM/77UQ4JRJviPZH0p/G8qCrybElJK9XqyIf
         x7N1jjA7nt687CZq8w87BePuomEKSjtNT5Xn30jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Kelley <mikelley@microsoft.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, stable@kernel.org
Subject: [PATCH 5.15 163/206] x86/ioremap: Fix page aligned size calculation in __ioremap_caller()
Date:   Wed, 30 Nov 2022 19:23:35 +0100
Message-Id: <20221130180537.178310022@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

commit 4dbd6a3e90e03130973688fd79e19425f720d999 upstream.

Current code re-calculates the size after aligning the starting and
ending physical addresses on a page boundary. But the re-calculation
also embeds the masking of high order bits that exceed the size of
the physical address space (via PHYSICAL_PAGE_MASK). If the masking
removes any high order bits, the size calculation results in a huge
value that is likely to immediately fail.

Fix this by re-calculating the page-aligned size first. Then mask any
high order bits using PHYSICAL_PAGE_MASK.

Fixes: ffa71f33a820 ("x86, ioremap: Fix incorrect physical address handling in PAE mode")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/1668624097-14884-2-git-send-email-mikelley@microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/ioremap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -216,9 +216,15 @@ __ioremap_caller(resource_size_t phys_ad
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PHYSICAL_PAGE_MASK;
+	phys_addr &= PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
+	/*
+	 * Mask out any bits not part of the actual physical
+	 * address, like memory encryption bits.
+	 */
+	phys_addr &= PHYSICAL_PAGE_MASK;
+
 	retval = memtype_reserve(phys_addr, (u64)phys_addr + size,
 						pcm, &new_pcm);
 	if (retval) {


