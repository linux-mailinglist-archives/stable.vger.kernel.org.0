Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0700E5410B1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354427AbiFGT25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356887AbiFGT2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBF61A197F;
        Tue,  7 Jun 2022 11:11:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B157D617B3;
        Tue,  7 Jun 2022 18:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF62BC385A2;
        Tue,  7 Jun 2022 18:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625488;
        bh=sN1Kk7yA6tgJ56jtZ7RfRBdgp59iuwFaAZOanZaTchg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmpkcbNICkEGZwGAOY3D6GblqvTmvJokDWpavPxq49+EMqX6LeND7seTOHXLL8UiH
         UgFze2ysy1od9OU1oJAnUAEbHFcYZmkTDSGy+tm9XZ4ceBUPAbCtWCIXKoFLFeOG2L
         h2RqGhZxvq2iip9jn6MHsV/pxoCjcKEPHJSK0xYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.17 007/772] riscv: Fix irq_work when SMP is disabled
Date:   Tue,  7 Jun 2022 18:53:19 +0200
Message-Id: <20220607164949.214119054@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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


