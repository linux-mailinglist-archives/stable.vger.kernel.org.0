Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1681165814E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbiL1Q1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiL1Q00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:26:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317DE1C934
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:22:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C59B86157B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B43C433D2;
        Wed, 28 Dec 2022 16:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244577;
        bh=BjqH3xmJbkBB968RtFhygLTCvU7XxDnjI0w1+HtpK2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3iTO7WqYywY6A7kGr8bLfebe2OK3zXe3x7aaaImHQy9y08xCf5N3by1OeNJcH7wO
         yk1uSHYSJ/PMQGrxmbE6LxsQ+dIs7ixvE7E1eDxVjJYE/tuHUzqV09RXEaBIiKVI98
         WkHIWGC4RlCEd3P/BmJEmQL+X/MN+lBCLbxpwx3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Stuebner <heiko@sntech.de>,
        Samuel Holland <samuel@sholland.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0679/1146] riscv: Fix crash during early errata patching
Date:   Wed, 28 Dec 2022 15:36:58 +0100
Message-Id: <20221228144348.587791457@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 0c49688174f5347c3f8012e84c0ffa0d2b2890c8 ]

The patch function for the T-Head PBMT errata calls __pa_symbol() before
relocation. This crashes when CONFIG_DEBUG_VIRTUAL is enabled, because
__pa_symbol() forwards to __phys_addr_symbol(), and __phys_addr_symbol()
checks against the absolute kernel start/end address.

Fix this by checking against the kernel map instead of a symbol address.

Fixes: a35707c3d850 ("riscv: add memory-type errata for T-Head")
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20221126060920.65009-1-samuel@sholland.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/physaddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/physaddr.c b/arch/riscv/mm/physaddr.c
index 19cf25a74ee2..9b18bda74154 100644
--- a/arch/riscv/mm/physaddr.c
+++ b/arch/riscv/mm/physaddr.c
@@ -22,7 +22,7 @@ EXPORT_SYMBOL(__virt_to_phys);
 phys_addr_t __phys_addr_symbol(unsigned long x)
 {
 	unsigned long kernel_start = kernel_map.virt_addr;
-	unsigned long kernel_end = (unsigned long)_end;
+	unsigned long kernel_end = kernel_start + kernel_map.size;
 
 	/*
 	 * Boundary checking aginst the kernel image mapping.
-- 
2.35.1



