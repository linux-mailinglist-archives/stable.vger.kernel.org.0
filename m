Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE83E5950E5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiHPEs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbiHPEq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:46:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738A2A2208;
        Mon, 15 Aug 2022 13:43:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3A74CE12E9;
        Mon, 15 Aug 2022 20:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBCDC433D6;
        Mon, 15 Aug 2022 20:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596192;
        bh=05K6e8DDsGvu0xMBaRum+fYSQ7upnYPuRy7qrtX142g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2TRFBWoZLO2g8vy0UCxYJ1T3YCAfiZzwkdMN7BRvzlm20rgETjS2WiuY6G8SAiPD
         rN89gfgtfzqXOCXowzy+k1autXLxzYbauQLawTxZoMDMMBoWHVgq7pjz2fCrwb5v0X
         1tKR+ED5MZrwA2jrqhhJNXhl7PX35liXSl+wZm1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil V L <sunilvl@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0974/1157] riscv: spinwait: Fix hartid variable type
Date:   Mon, 15 Aug 2022 20:05:30 +0200
Message-Id: <20220815180518.681002556@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Sunil V L <sunilvl@ventanamicro.com>

[ Upstream commit c029e487e7c00e5594a4ae946952605db34e359b ]

The hartid variable is of type int but compared with
ULONG_MAX(INVALID_HARTID). This issue is fixed by changing
the hartid variable type to unsigned long.

Fixes: c78f94f35cf6 ("RISC-V: Use __cpu_up_stack/task_pointer only for spinwait method")

Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20220527051743.2829940-3-sunilvl@ventanamicro.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpu_ops_spinwait.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/cpu_ops_spinwait.c b/arch/riscv/kernel/cpu_ops_spinwait.c
index c662a7cf10a4..d98d19226b5f 100644
--- a/arch/riscv/kernel/cpu_ops_spinwait.c
+++ b/arch/riscv/kernel/cpu_ops_spinwait.c
@@ -20,7 +20,7 @@ void *__cpu_spinwait_task_pointer[NR_CPUS] __section(".data");
 static void cpu_update_secondary_bootdata(unsigned int cpuid,
 				   struct task_struct *tidle)
 {
-	int hartid = cpuid_to_hartid_map(cpuid);
+	unsigned long hartid = cpuid_to_hartid_map(cpuid);
 
 	/*
 	 * The hartid must be less than NR_CPUS to avoid out-of-bound access
@@ -29,7 +29,7 @@ static void cpu_update_secondary_bootdata(unsigned int cpuid,
 	 * spinwait booting is not the recommended approach for any platforms
 	 * booting Linux in S-mode and can be disabled in the future.
 	 */
-	if (hartid == INVALID_HARTID || hartid >= NR_CPUS)
+	if (hartid == INVALID_HARTID || hartid >= (unsigned long) NR_CPUS)
 		return;
 
 	/* Make sure tidle is updated */
-- 
2.35.1



