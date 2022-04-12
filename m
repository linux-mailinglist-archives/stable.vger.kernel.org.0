Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B345B4FD64F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350833AbiDLHW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352334AbiDLHNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:13:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB35C1D331;
        Mon, 11 Apr 2022 23:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12095B81B44;
        Tue, 12 Apr 2022 06:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57797C385A1;
        Tue, 12 Apr 2022 06:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746477;
        bh=LAxfqD32x6ZFr0TQ72MXLdGPukvlyZn5mmFfZ5YXYLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lg5tNmjnL1YHpi5xDdDngh4X0cn0E2XHXTe4fbkt8369BNHf+sUS+XfS1X2fF9Zle
         O9Et76JodfwzlSw4vBOPoKn1YVBWN1iKvB1A8KxZbjRgpyPZEsVTIGCJu5d1BAiNSK
         qKeK7GzlQBNIe9hhuZnCtSQG6NjfJc6eLrIG8FQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 002/285] um: fix and optimize xor select template for CONFIG64 and timetravel mode
Date:   Tue, 12 Apr 2022 08:27:39 +0200
Message-Id: <20220412062943.744489101@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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



