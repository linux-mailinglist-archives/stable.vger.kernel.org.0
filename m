Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B1660474F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiJSNhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbiJSNgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:36:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1C014EC76;
        Wed, 19 Oct 2022 06:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 112DAB82481;
        Wed, 19 Oct 2022 09:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8097EC433D7;
        Wed, 19 Oct 2022 09:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170340;
        bh=87uGXaQ29FHYXgH/kJOHi/LtGmbeg5m3Y9g0xl9SUtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhK51HPNIoATH1qbakHg0/bIndU2cOmNW8maIJsaNtaJjcbZmr14R4L5RCVcES50e
         LJw32ou8TzFknosVKqUwiWs9Spo0I6RZDL5wNpc+RJclotlqslFHNf/P1N/zYJY2U/
         RbmHSD5keV7AwB44p9KLc6wdga+YtxeY/QbJtlnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 618/862] powerpc/64/interrupt: Fix false warning in context tracking due to idle state
Date:   Wed, 19 Oct 2022 10:31:45 +0200
Message-Id: <20221019083317.242763603@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 56adbb7a8b6cc7fc9b940829c38494e53c9e57d1 ]

Commit 171476775d32 ("context_tracking: Convert state to atomic_t")
added a CONTEXT_IDLE state which can be encountered by interrupts from
kernel mode in the idle thread, causing a false positive warning.

Fixes: 171476775d32 ("context_tracking: Convert state to atomic_t")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220926054305.2671436-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/interrupt.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/interrupt.h b/arch/powerpc/include/asm/interrupt.h
index 8069dbc4b8d1..b61555e30c7c 100644
--- a/arch/powerpc/include/asm/interrupt.h
+++ b/arch/powerpc/include/asm/interrupt.h
@@ -195,7 +195,8 @@ static inline void interrupt_enter_prepare(struct pt_regs *regs)
 		 * so avoid recursion.
 		 */
 		if (TRAP(regs) != INTERRUPT_PROGRAM) {
-			CT_WARN_ON(ct_state() != CONTEXT_KERNEL);
+			CT_WARN_ON(ct_state() != CONTEXT_KERNEL &&
+				   ct_state() != CONTEXT_IDLE);
 			if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG))
 				BUG_ON(is_implicit_soft_masked(regs));
 		}
-- 
2.35.1



