Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2065E549370
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378733AbiFMNmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379271AbiFMNkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00502205DB;
        Mon, 13 Jun 2022 04:31:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 824C7B80E59;
        Mon, 13 Jun 2022 11:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0393C36B09;
        Mon, 13 Jun 2022 11:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119865;
        bh=EmEjY/2oupTS6JKEbxG775P6fh8XyKSAcBZ6LBmEp34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJfiz9xPcJhBUNqtz3TEiqwhtrD47b8m46ErJbOACoAVMreUeJNXxt4qMlK8/AbrB
         GiCHzqDZn2R7Qtn7xjs9NI2TF0vnadmXVVr5DwQNEDSezdYAIGOOThHxLbHcK4c3k1
         IOI2JXXXolpHEM4BzFbg4wfoOVP/OPO8o7KSWEkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickens <hughd@google.com>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 166/339] m68knommu: set ZERO_PAGE() to the allocated zeroed page
Date:   Mon, 13 Jun 2022 12:09:51 +0200
Message-Id: <20220613094931.716276473@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Ungerer <gerg@linux-m68k.org>

[ Upstream commit dc068f46217970d9516f16cd37972a01d50dc055 ]

The non-MMU m68k pagetable ZERO_PAGE() macro is being set to the
somewhat non-sensical value of "virt_to_page(0)". The zeroth page
is not in any way guaranteed to be a page full of "0". So the result
is that ZERO_PAGE() will almost certainly contain random values.

We already allocate a real "empty_zero_page" in the mm setup code shared
between MMU m68k and non-MMU m68k. It is just not hooked up to the
ZERO_PAGE() macro for the non-MMU m68k case.

Fix ZERO_PAGE() to use the allocated "empty_zero_page" pointer.

I am not aware of any specific issues caused by the old code.

Link: https://lore.kernel.org/linux-m68k/2a462b23-5b8e-bbf4-ec7d-778434a3b9d7@google.com/T/#t
Reported-by: Hugh Dickens <hughd@google.com>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/pgtable_no.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/pgtable_no.h b/arch/m68k/include/asm/pgtable_no.h
index 87151d67d91e..bce5ca56c388 100644
--- a/arch/m68k/include/asm/pgtable_no.h
+++ b/arch/m68k/include/asm/pgtable_no.h
@@ -42,7 +42,8 @@ extern void paging_init(void);
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
  */
-#define ZERO_PAGE(vaddr)	(virt_to_page(0))
+extern void *empty_zero_page;
+#define ZERO_PAGE(vaddr)	(virt_to_page(empty_zero_page))
 
 /*
  * All 32bit addresses are effectively valid for vmalloc...
-- 
2.35.1



