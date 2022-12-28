Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB338658070
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbiL1QSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiL1QRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042941AA19
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8635B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13361C433F2;
        Wed, 28 Dec 2022 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244125;
        bh=BjqH3xmJbkBB968RtFhygLTCvU7XxDnjI0w1+HtpK2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRQ5Qnuq+HQn7Sjwn9/gpm1lzxGNWzZp6Qhkqo/BgFAbwE2kQeklJ4LPMrE3p1C80
         BUrsqWW4CBVSRzwLeXaERgQArFtkJKZTjUg+kna01P6ToRHC+OMOPSJGfaBaHFXbbO
         kzwPY3KFZWl07Vm/4aYTowy6QXOuIlgaPXTQu7bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Stuebner <heiko@sntech.de>,
        Samuel Holland <samuel@sholland.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0655/1073] riscv: Fix crash during early errata patching
Date:   Wed, 28 Dec 2022 15:37:23 +0100
Message-Id: <20221228144345.836824674@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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



