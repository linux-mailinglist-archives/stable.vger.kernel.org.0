Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11CB6088E8
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJVIZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbiJVIXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:23:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C280B169CD6;
        Sat, 22 Oct 2022 00:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9A2360AFA;
        Sat, 22 Oct 2022 07:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE065C433D6;
        Sat, 22 Oct 2022 07:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425438;
        bh=+7vq+AHutYpGIBBik1KRpBUm4rIJ77U6/TMEBYvCzxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmMnhZSOTHy5ozqUrDd7fGFUa6MeQh6SVsw11FEAOThC3r2yKzb5APmPE+nW+Azyx
         l5HBpJMrGiC2x5iXHH+6maHbwh4HZi56ObXd0Fn64kg7Q7no/RAxjzGkm2l/itPDeY
         zkzhn3UqXql6aQ1BMam57CkZhazcd95NfmPnYK/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 502/717] powerpc/64: mark irqs hard disabled in boot paca
Date:   Sat, 22 Oct 2022 09:26:21 +0200
Message-Id: <20221022072520.473745835@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 799f7063c7645f9a751d17f5dfd73b952f962cd2 ]

This prevents interrupts in early boot (e.g., program check) from
enabling MSR[EE], potentially causing endian mismatch or other
crashes when reporting early boot traps.

Fixes: 4423eb5ae32ec ("powerpc/64/interrupt: make normal synchronous interrupts enable MSR[EE] if possible")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220926054305.2671436-3-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/setup_64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 5761f08dae95..6562517bcb3b 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -183,8 +183,10 @@ static void __init fixup_boot_paca(void)
 	get_paca()->cpu_start = 1;
 	/* Allow percpu accesses to work until we setup percpu data */
 	get_paca()->data_offset = 0;
-	/* Mark interrupts disabled in PACA */
+	/* Mark interrupts soft and hard disabled in PACA */
 	irq_soft_mask_set(IRQS_DISABLED);
+	get_paca()->irq_happened = PACA_IRQ_HARD_DIS;
+	WARN_ON(mfmsr() & MSR_EE);
 }
 
 static void __init configure_exceptions(void)
-- 
2.35.1



