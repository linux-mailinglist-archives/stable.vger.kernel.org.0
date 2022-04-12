Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F23B4FDA31
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353278AbiDLHdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355524AbiDLH1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F704EA39;
        Tue, 12 Apr 2022 00:07:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73071616A9;
        Tue, 12 Apr 2022 07:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA40C385A1;
        Tue, 12 Apr 2022 07:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747266;
        bh=LAxfqD32x6ZFr0TQ72MXLdGPukvlyZn5mmFfZ5YXYLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=04DJ7WyPfh0MQ9zadbxYynNpJ+5N3dkN9aFkRk9pA/ofbcZt6bp/1N2AWuQDqtxLo
         Cx1p8WUjBmlw6l4tIbhDAZv7iKBWXufil65SwBY4mbk657yNN5UCciJE8eJi+q2JDo
         kFxHr6wDyoiqumxNP4CnZll+lztUeA66wmqx59f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 002/343] um: fix and optimize xor select template for CONFIG64 and timetravel mode
Date:   Tue, 12 Apr 2022 08:27:00 +0200
Message-Id: <20220412062951.172858976@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>

[ Upstream commit e3a33af812c611d99756e2ec61e9d7068d466bdf ]

Due to dropped inclusion of asm-generic/xor.h, xor_block_8regs symbol is
missing with CONFIG64 and break compilation, as the asm/xor_64.h also did
not include it. The patch recreate the logic from arch/x86, which check
whether AVX is available and add fallbacks for 32bit and 64bit config of
um.

A very minor additional "fix" is, the return of the macro parameter
instead of NULL, as this is the original intent of the macro, but
this does not change the actual behavior.

Fixes: c0ecca6604b8 ("um: enable the use of optimized xor routines in UML")
Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/xor.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/um/include/asm/xor.h b/arch/um/include/asm/xor.h
index f512704a9ec7..22b39de73c24 100644
--- a/arch/um/include/asm/xor.h
+++ b/arch/um/include/asm/xor.h
@@ -4,8 +4,10 @@
 
 #ifdef CONFIG_64BIT
 #undef CONFIG_X86_32
+#define TT_CPU_INF_XOR_DEFAULT (AVX_SELECT(&xor_block_sse_pf64))
 #else
 #define CONFIG_X86_32 1
+#define TT_CPU_INF_XOR_DEFAULT (AVX_SELECT(&xor_block_8regs))
 #endif
 
 #include <asm/cpufeature.h>
@@ -16,7 +18,7 @@
 #undef XOR_SELECT_TEMPLATE
 /* pick an arbitrary one - measuring isn't possible with inf-cpu */
 #define XOR_SELECT_TEMPLATE(x)	\
-	(time_travel_mode == TT_MODE_INFCPU ? &xor_block_8regs : NULL)
+	(time_travel_mode == TT_MODE_INFCPU ? TT_CPU_INF_XOR_DEFAULT : x))
 #endif
 
 #endif
-- 
2.35.1



