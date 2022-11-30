Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF09F63DFF9
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiK3Swg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiK3SwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:52:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B0663D5A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:52:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15789B81CAC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDB5C433D7;
        Wed, 30 Nov 2022 18:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834331;
        bh=wrwmUT9CGF7VPCAMKuCM/INJr3l8x1wMFRTeW9wPXOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BO2lo4UXd7syjafRjss5h0EOuJj0jx8KoyorvALUu0CFaJE1LuM86MMsASjH9CCQM
         0ycA6cG7Bxb2HQYD18RIoZAGUrjP90xbNUfLaSTWTTkoiV5aDdlVmbm+YUbj83XaL3
         FpYNIIPRofhztF7AJCxbp66tvhpQLpO1xmvsgmuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Kelley <mikelley@microsoft.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, stable@kernel.org
Subject: [PATCH 6.0 215/289] x86/ioremap: Fix page aligned size calculation in __ioremap_caller()
Date:   Wed, 30 Nov 2022 19:23:20 +0100
Message-Id: <20221130180548.992890990@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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


