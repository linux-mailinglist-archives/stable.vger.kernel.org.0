Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B064F487D3D
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 20:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiAGToA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 14:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbiAGToA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 14:44:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA08C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 11:44:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED45B61F1F
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 19:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53217C36AE9;
        Fri,  7 Jan 2022 19:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641584639;
        bh=m61fuw1pNqrst7HLX3tjWWgGYWOPsNFFFghJhYPmSmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbgPV3t8QrUmD2HnDIOaXpJIDDPm6qaXONETzG3lIat9eubaqXRAustox8oo0GtfW
         YRzJNxtvnJDXpsENKajOs0xiY1yRuRRDAN1KUuQ8pV5420B2iG2pVyPslI36nWvEqs
         UD/CTkBWE4duTwiFm4BdC67WFkqXcL8vmudiqBb4AKnlftH6Cwv1/Fq6WA+aR21sYA
         c4egkzXda5F++epcEqSYvKlffLED26LsdKZX4EeXXQZKWhglk+6EnWHfJSNjgjI3Bi
         5TG+k/VVIg2XiBm0RiZDWZ0YUxwQAv+hKG/QMs0oEa5y4/mbLIvBu5tq0nHIpnn049
         BiJutRHUN2wkw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH RFC 4.9 2/5] arm64: Remove a redundancy in sysreg.h
Date:   Fri,  7 Jan 2022 12:43:32 -0700
Message-Id: <20220107194335.3090066-3-nathan@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107194335.3090066-1-nathan@kernel.org>
References: <20220107194335.3090066-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Traby <stefan@hello-penguin.com>

commit d38338e396ee0571b3502962fd2fbaec4d2d9a8f upstream.

This is really trivial; there is a dup (1 << 16) in the code

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Stefan Traby <stefan@hello-penguin.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 88bbe364b6ae..7a9f0a71f441 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -95,8 +95,8 @@
 #define SCTLR_ELx_M	1
 
 #define SCTLR_EL2_RES1	((1 << 4)  | (1 << 5)  | (1 << 11) | (1 << 16) | \
-			 (1 << 16) | (1 << 18) | (1 << 22) | (1 << 23) | \
-			 (1 << 28) | (1 << 29))
+			 (1 << 18) | (1 << 22) | (1 << 23) | (1 << 28) | \
+			 (1 << 29))
 
 #define SCTLR_ELx_FLAGS	(SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | \
 			 SCTLR_ELx_SA | SCTLR_ELx_I)
-- 
2.34.1

