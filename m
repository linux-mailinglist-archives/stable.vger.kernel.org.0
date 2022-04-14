Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84245013A6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345441AbiDNNuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344484AbiDNNlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:41:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C818D1C6;
        Thu, 14 Apr 2022 06:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6128D612E6;
        Thu, 14 Apr 2022 13:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E7BC385A5;
        Thu, 14 Apr 2022 13:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943554;
        bh=ggEp+GW0LsGrBlV1F9X3N68mybpKoEmNH5PJbLSWMEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iE7t9gkkmR5tF68xld74qlPDd8aADq/pwT9e2BqISykl6UmQbH++YU0hU2pJgbLN0
         5XZ8e31FIKTeY2DygrF9U+lM5w4Up9c9ffzgVQshPbXsUYgoQwNM0FXcEmoCTmInhn
         aT9V+tZUOEKoTln/r6hcRrYowKvGTxabSnzuY1K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/475] powerpc/Makefile: Dont pass -mcpu=powerpc64 when building 32-bit
Date:   Thu, 14 Apr 2022 15:09:42 +0200
Message-Id: <20220414110900.642618780@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 2863dd2db23e0407f6c50b8ba5c0e55abef894f1 ]

When CONFIG_GENERIC_CPU=y (true for all our defconfigs) we pass
-mcpu=powerpc64 to the compiler, even when we're building a 32-bit
kernel.

This happens because we have an ifdef CONFIG_PPC_BOOK3S_64/else block in
the Makefile that was written before 32-bit supported GENERIC_CPU. Prior
to that the else block only applied to 64-bit Book3E.

The GCC man page says -mcpu=powerpc64 "[specifies] a pure ... 64-bit big
endian PowerPC ... architecture machine [type], with an appropriate,
generic processor model assumed for scheduling purposes."

It's unclear how that interacts with -m32, which we are also passing,
although obviously -m32 is taking precedence in some sense, as the
32-bit kernel only contains 32-bit instructions.

This was noticed by inspection, not via any bug reports, but it does
affect code generation. Comparing before/after code generation, there
are some changes to instruction scheduling, and the after case (with
-mcpu=powerpc64 removed) the compiler seems more keen to use r8.

Fix it by making the else case only apply to Book3E 64, which excludes
32-bit.

Fixes: 0e00a8c9fd92 ("powerpc: Allow CPU selection also on PPC32")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220215112858.304779-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 9f73fb6b1cc9..b9d2fcf030d0 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -174,7 +174,7 @@ else
 CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=power7,$(call cc-option,-mtune=power5))
 CFLAGS-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mcpu=power5,-mcpu=power4)
 endif
-else
+else ifdef CONFIG_PPC_BOOK3E_64
 CFLAGS-$(CONFIG_GENERIC_CPU) += -mcpu=powerpc64
 endif
 
-- 
2.34.1



