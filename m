Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248BC592555
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243061AbiHNQmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243363AbiHNQkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:40:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA258558A;
        Sun, 14 Aug 2022 09:31:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8795C60FBE;
        Sun, 14 Aug 2022 16:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5ABAC433C1;
        Sun, 14 Aug 2022 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494668;
        bh=Ozh6pKstKR8EmXCauJAdcp4MKdVlb4V3CinW1snpBUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGLlz9bYUKWlpX6Uy+7ggI0lEvG8n2TiI3yo2IOGt2USuL2sl7EgbDlT3IS2PMT3C
         gmMW8lTIWxdjO/ShL8xkL+wd8lOaA9EbDKsyKD4SOuSQL/3ofWz3xrQAhIfyzeA/jj
         voKrnbuXZTIfaBxCL1YLerDBiAPSfLynv9gnei0S9taXKlvAW8YMRyiY2UF7D89fNl
         xEKa0sV8wJKyN7eaw25ZU3Gv4yocHl6agBYTdid3JTxgFJB+kdfTKNQy6ApTpfXupP
         tPgarX9Au4i83Pq2oZ/fj1gxiVSzGQ6Uo+fR2E5Mcshkx7mhBukTJ8pjynGkoMvlEC
         CBM54jYXv4Eow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, robh@kernel.org,
        frank.rowand@sony.com, nick.child@ibm.com, npiggin@gmail.com,
        adobriyan@gmail.com, clg@kaod.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 6/8] powerpc/64: Init jump labels before parse_early_param()
Date:   Sun, 14 Aug 2022 12:30:39 -0400
Message-Id: <20220814163041.2399552-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814163041.2399552-1-sashal@kernel.org>
References: <20220814163041.2399552-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhouyi Zhou <zhouzhouyi@gmail.com>

[ Upstream commit ca829e05d3d4f728810cc5e4b468d9ebc7745eb3 ]

On 64-bit, calling jump_label_init() in setup_feature_keys() is too
late because static keys may be used in subroutines of
parse_early_param() which is again subroutine of early_init_devtree().

For example booting with "threadirqs":

  static_key_enable_cpuslocked(): static key '0xc000000002953260' used before call to jump_label_init()
  WARNING: CPU: 0 PID: 0 at kernel/jump_label.c:166 static_key_enable_cpuslocked+0xfc/0x120
  ...
  NIP static_key_enable_cpuslocked+0xfc/0x120
  LR  static_key_enable_cpuslocked+0xf8/0x120
  Call Trace:
    static_key_enable_cpuslocked+0xf8/0x120 (unreliable)
    static_key_enable+0x30/0x50
    setup_forced_irqthreads+0x28/0x40
    do_early_param+0xa0/0x108
    parse_args+0x290/0x4e0
    parse_early_options+0x48/0x5c
    parse_early_param+0x58/0x84
    early_init_devtree+0xd4/0x518
    early_setup+0xb4/0x214

So call jump_label_init() just before parse_early_param() in
early_init_devtree().

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
[mpe: Add call trace to change log and minor wording edits.]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220726015747.11754-1-zhouzhouyi@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 11b4ecec04ee..1413d72689d2 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -682,6 +682,13 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_root, NULL);
 	of_scan_flat_dt(early_init_dt_scan_memory_ppc, NULL);
 
+	/*
+	 * As generic code authors expect to be able to use static keys
+	 * in early_param() handlers, we initialize the static keys just
+	 * before parsing early params (it's fine to call jump_label_init()
+	 * more than once).
+	 */
+	jump_label_init();
 	parse_early_param();
 
 	/* make sure we've parsed cmdline for mem= before this */
-- 
2.35.1

