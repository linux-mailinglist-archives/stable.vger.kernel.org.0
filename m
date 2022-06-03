Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973F353C9E4
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 14:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244203AbiFCMQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 08:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244222AbiFCMQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 08:16:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9238E39B9C;
        Fri,  3 Jun 2022 05:15:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AEEBB8229C;
        Fri,  3 Jun 2022 12:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3662C385A9;
        Fri,  3 Jun 2022 12:15:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="c3mcp+J+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654258553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oRsHxHQzO9b36Wu7d91EDPUtT5qXNW3912jYDw/ciis=;
        b=c3mcp+J+qUuufS2+xBe8Ii9kTqaeIMNB6W/woJj8yZqwjHzz9spVBuRHXD5MyzJIRw+Znw
        Sv2ZWHqUZu6dNBVJwJq15W+sAGxXcU3gVt5AYH8ICM6+yal0iL4Erteq+dy7pZqFGMp0dt
        qNk8lOYjQprBB4UmUtI0s4BmkDGCYns=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2573374e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 3 Jun 2022 12:15:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux@armlinux.org.uk, rmk+kernel@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
Date:   Fri,  3 Jun 2022 14:15:43 +0200
Message-Id: <20220603121543.360283-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stephen reported that a static key warning splat appears during early
boot on arm64 systems that credit randomness from device trees that
contain an "rng-seed" property, because setup_machine_fdt() is called
before jump_label_init() during setup_arch(), which was fixed by
73e2d827a501 ("arm64: Initialize jump labels before
setup_machine_fdt()").

Upon cursory inspection, the same basic issue appears to apply to arm32
as well. So this commit adds a call to jump_label_init() just before
setup_machine_fdt().

Reported-by: Stephen Boyd <swboyd@chromium.org>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: stable@vger.kernel.org
Fixes: f5bda35fba61 ("random: use static branch for crng_ready()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/arm/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 1e8a50a97edf..3ff80b1ee0b5 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1101,6 +1101,7 @@ void __init setup_arch(char **cmdline_p)
 		atags_vaddr = FDT_VIRT_BASE(__atags_pointer);
 
 	setup_processor();
+	jump_label_init();
 	if (atags_vaddr) {
 		mdesc = setup_machine_fdt(atags_vaddr);
 		if (mdesc)
-- 
2.35.1

