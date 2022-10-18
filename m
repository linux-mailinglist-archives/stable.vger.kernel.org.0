Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A4B601F87
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiJRAZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiJRAYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:24:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126948FD67;
        Mon, 17 Oct 2022 17:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2200561323;
        Tue, 18 Oct 2022 00:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57530C433D7;
        Tue, 18 Oct 2022 00:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051848;
        bh=BU+x9o1av8bBc3J6PmkaP2U3PQN9nJvvwxkW9a1MNlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPiGiGuAzAUkpbe05sHwscTlOwOhESXVMwhTFintgWuwQ93p1/T1oaM9oXwpeFbI9
         C1IWN+WNbI4tfVuOf51oQnRAWjDk3Mr64pdldflglLAkg6Ivk5M+3Q3p1UuvELg7Ln
         MtNqpr5h1NzaioqZb9Zm/bLUQpY9djShQx1FIHneZUg0nbBv9yHyAC67NX7uGm/yrM
         eaXyKslUpBK8Aued17nMjGbNu5/mZKNqon0EjrTJo+WF/OSEccEtaKiLrWmxGKrDIL
         4rG2zjhzHpMbsgLyEu4UjyhBms1XTeEBF6nRQ1rcYLixOPOrCyrFXKAYD4rDEUQDpI
         ib6xFglNxfjiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        aik@ozlabs.ru, christophe.leroy@csgroup.eu, dja@axtens.net,
        amodra@au1.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 09/16] powerpc/64: don't refer nr_cpu_ids in asm code when it's undefined
Date:   Mon, 17 Oct 2022 20:10:22 -0400
Message-Id: <20221018001029.2731620-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001029.2731620-1-sashal@kernel.org>
References: <20221018001029.2731620-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>

[ Upstream commit 546a073d628111e3338af689938407e77d5dc38f ]

generic_secondary_common_init() calls LOAD_REG_ADDR(r7, nr_cpu_ids)
conditionally on CONFIG_SMP. However, if 'NR_CPUS == 1', kernel doesn't
use the nr_cpu_ids, and in C code, it's just:
  #if NR_CPUS == 1
  #define nr_cpu_ids
  ...

This series makes declaration of nr_cpu_ids conditional on NR_CPUS == 1,
and that reveals the issue, because compiler can't link the
LOAD_REG_ADDR(r7, nr_cpu_ids) against nonexisting symbol.

Current code looks unsafe for those who build kernel with CONFIG_SMP=y and
NR_CPUS == 1. This is weird configuration, but not disallowed.

Fix the linker error by replacing LOAD_REG_ADDR() with LOAD_REG_IMMEDIATE()
conditionally on NR_CPUS == 1.

As the following patch adds CONFIG_FORCE_NR_CPUS option that has the
similar effect on nr_cpu_ids, make the generic_secondary_common_init()
conditional on it too.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_64.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 2d6581db0c7b..86f9970d8631 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -392,8 +392,12 @@ generic_secondary_common_init:
 #else
 	LOAD_REG_ADDR(r8, paca_ptrs)	/* Load paca_ptrs pointe	 */
 	ld	r8,0(r8)		/* Get base vaddr of array	 */
+#if (NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)
+	LOAD_REG_IMMEDIATE(r7, NR_CPUS)
+#else
 	LOAD_REG_ADDR(r7, nr_cpu_ids)	/* Load nr_cpu_ids address       */
 	lwz	r7,0(r7)		/* also the max paca allocated 	 */
+#endif
 	li	r5,0			/* logical cpu id                */
 1:
 	sldi	r9,r5,3			/* get paca_ptrs[] index from cpu id */
-- 
2.35.1

