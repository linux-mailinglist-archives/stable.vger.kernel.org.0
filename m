Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100B6694939
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjBMO5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjBMO5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:57:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B3E1DB97
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:56:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 645F2B80E62
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9409C433D2;
        Mon, 13 Feb 2023 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300184;
        bh=zfY/whVn6HYIuiXAw3hxr53jrQkSstb/81pyrNbv6wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTNOmdmMJ54xBcMZBB0qbKyNaTihWoekWoVmCXHkHOGz1N3x1mZnJKyASwX2x22wY
         xNS5p7ONrE5+CNNk4W26jeS6mH0Iwq5ojSQp2CE7tZaDbaDFRpT7ahyQX4ugBFXuSM
         N1yxjuZ+zyKjimadVdKC4vnw3KjzUkU9DGm7aJP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sachin Sant <sachinp@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 096/114] powerpc/64s/interrupt: Fix interrupt exit race with security mitigation switch
Date:   Mon, 13 Feb 2023 15:48:51 +0100
Message-Id: <20230213144747.144563374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

commit 2ea31e2e62bbc4d11c411eeb36f1b02841dbcab1 upstream.

The RFI and STF security mitigation options can flip the
interrupt_exit_not_reentrant static branch condition concurrently with
the interrupt exit code which tests that branch.

Interrupt exit tests this condition to set MSR[EE|RI] for exit, then
again in the case a soft-masked interrupt is found pending, to recover
the MSR so the interrupt can be replayed before attempting to exit
again. If the condition changes between these two tests, the MSR and irq
soft-mask state will become corrupted, leading to warnings and possible
crashes. For example, if the branch is initially true then false,
MSR[EE] will be 0 but PACA_IRQ_HARD_DIS clear and EE may not get
enabled, leading to warnings in irq_64.c.

Fixes: 13799748b957 ("powerpc/64: use interrupt restart table to speed up return from interrupt")
Cc: stable@vger.kernel.org # v5.14+
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230206042240.92103-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/interrupt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -50,16 +50,18 @@ static inline bool exit_must_hard_disabl
  */
 static notrace __always_inline bool prep_irq_for_enabled_exit(bool restartable)
 {
+	bool must_hard_disable = (exit_must_hard_disable() || !restartable);
+
 	/* This must be done with RI=1 because tracing may touch vmaps */
 	trace_hardirqs_on();
 
-	if (exit_must_hard_disable() || !restartable)
+	if (must_hard_disable)
 		__hard_EE_RI_disable();
 
 #ifdef CONFIG_PPC64
 	/* This pattern matches prep_irq_for_idle */
 	if (unlikely(lazy_irq_pending_nocheck())) {
-		if (exit_must_hard_disable() || !restartable) {
+		if (must_hard_disable) {
 			local_paca->irq_happened |= PACA_IRQ_HARD_DIS;
 			__hard_RI_enable();
 		}


