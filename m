Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A30F59DA1A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352232AbiHWKFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348401AbiHWKDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:03:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8292F7C75B;
        Tue, 23 Aug 2022 01:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F173C61524;
        Tue, 23 Aug 2022 08:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4ADC433D6;
        Tue, 23 Aug 2022 08:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243890;
        bh=mo4pZi3hofheKli2BHAplF58RB11yRXOjPYawuE3wUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAONnbskTZWbdZNZtSSYtWLITsKfvs245HHvFUhukvjk/cufYyLITVUGPP8CnurrF
         BstRlm1+ZvuASK0aSK2pfyYWQdJzYW7UHCp8VA4logps8nra+gMsLi3f+mqsmWOaT8
         sv8Lx0yPbCmIRenZfSy/oluMlv9Uz40aLroptafM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>,
        stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 004/244] x86/mm: Use proper mask when setting PUD mapping
Date:   Tue, 23 Aug 2022 10:22:43 +0200
Message-Id: <20220823080059.236036421@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -646,7 +646,7 @@ phys_pud_init(pud_t *pud_page, unsigned
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
 
-			prot = __pgprot(pgprot_val(prot) | __PAGE_KERNEL_LARGE);
+			prot = __pgprot(pgprot_val(prot) | _PAGE_PSE);
 
 			set_pte_init((pte_t *)pud,
 				     pfn_pte((paddr & PUD_MASK) >> PAGE_SHIFT,


