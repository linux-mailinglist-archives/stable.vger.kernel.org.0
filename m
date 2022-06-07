Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3445404E3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbiFGRTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345748AbiFGRTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:19:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DD11059D8;
        Tue,  7 Jun 2022 10:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD9A8B82239;
        Tue,  7 Jun 2022 17:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201B5C34115;
        Tue,  7 Jun 2022 17:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622346;
        bh=sN1Kk7yA6tgJ56jtZ7RfRBdgp59iuwFaAZOanZaTchg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsTKQAD4ph0U5mGKx7//4MpuDy2zISm/xcYVt+YdlkBRNYpvIUUjR5VkwMTvt3QBG
         hr224BwMKaomasD4slaSIs07lWQDqWhLkV1XI0SWUz1SXA9AOJ2Lhrfm8bArXqdY61
         CtuNrGpVhtfrCWiYC6TwPftJRms5YApJlPRAbtxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 005/452] riscv: Fix irq_work when SMP is disabled
Date:   Tue,  7 Jun 2022 18:57:42 +0200
Message-Id: <20220607164908.693223778@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

commit 2273272823db6f67d57761df8116ae32e7f05bed upstream.

irq_work is triggered via an IPI, but the IPI infrastructure is not
included in uniprocessor kernels. As a result, irq_work never runs.
Fall back to the tick-based irq_work implementation on uniprocessor
configurations.

Fixes: 298447928bb1 ("riscv: Support irq_work via self IPIs")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20220430030025.58405-1-samuel@sholland.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/irq_work.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/irq_work.h
+++ b/arch/riscv/include/asm/irq_work.h
@@ -4,7 +4,7 @@
 
 static inline bool arch_irq_work_has_interrupt(void)
 {
-	return true;
+	return IS_ENABLED(CONFIG_SMP);
 }
 extern void arch_irq_work_raise(void);
 #endif /* _ASM_RISCV_IRQ_WORK_H */


