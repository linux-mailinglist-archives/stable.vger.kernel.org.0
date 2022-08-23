Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1769459DFBB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244350AbiHWMDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376258AbiHWMCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:02:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291CDDAB88;
        Tue, 23 Aug 2022 02:36:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA8F461485;
        Tue, 23 Aug 2022 09:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BC3C433B5;
        Tue, 23 Aug 2022 09:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247389;
        bh=xVV0l/Pd2MYjbdMgeA4Tm9OMCqwYPPiHSBBgogv6Dhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4NJ/SeVWQxKU35ih8ZXyMJBxNPDvOKVRnQvC66HbW8DCP4gO35oOB0d0x3QdGVCE
         /z4Vx3AGKQhDLytw/IfisyLk6E5UsVcLpO8Qgx8PabD0U4GjJG+nzvAbTAxL+2EvC7
         HgJUnElCC56O8pyz+xtadFvqo0UrohAju1DQ9qKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 003/158] x86/mm: Use proper mask when setting PUD mapping
Date:   Tue, 23 Aug 2022 10:25:35 +0200
Message-Id: <20220823080046.179441523@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Aaron Lu <aaron.lu@intel.com>

commit 88e0a74902f894fbbc55ad3ad2cb23b4bfba555c upstream.

Commit c164fbb40c43f("x86/mm: thread pgprot_t through
init_memory_mapping()") mistakenly used __pgprot() which doesn't respect
__default_kernel_pte_mask when setting PUD mapping.

Fix it by only setting the one bit we actually need (PSE) and leaving
the other bits (that have been properly masked) alone.

Fixes: c164fbb40c43 ("x86/mm: thread pgprot_t through init_memory_mapping()")
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -645,7 +645,7 @@ phys_pud_init(pud_t *pud_page, unsigned
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
 
-			prot = __pgprot(pgprot_val(prot) | __PAGE_KERNEL_LARGE);
+			prot = __pgprot(pgprot_val(prot) | _PAGE_PSE);
 
 			set_pte_init((pte_t *)pud,
 				     pfn_pte((paddr & PUD_MASK) >> PAGE_SHIFT,


