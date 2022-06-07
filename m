Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8135417A4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378921AbiFGVER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379136AbiFGVCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D81188E89;
        Tue,  7 Jun 2022 11:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65C72612F2;
        Tue,  7 Jun 2022 18:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DBAC385A2;
        Tue,  7 Jun 2022 18:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627598;
        bh=sN1Kk7yA6tgJ56jtZ7RfRBdgp59iuwFaAZOanZaTchg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1n2MmkOlra/zgC56BapGP0nizZnltjB4odabtXZF2Uiati+ovNcfQLQOC5eMcsOE
         D08GFMoEiOHxd0djJl4uGaoCQqTBA864r628Rvi4D8eBpepP+phzBSmSPlpfh3zeoW
         iFn7fpVrRwHbhyHKDwHGZ6imuf9o2E00htrxuizc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.18 008/879] riscv: Fix irq_work when SMP is disabled
Date:   Tue,  7 Jun 2022 18:52:06 +0200
Message-Id: <20220607165002.913734663@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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


