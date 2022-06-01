Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E6953A7C1
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354301AbiFAOC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355399AbiFAOBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:01:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089A334B8E;
        Wed,  1 Jun 2022 06:58:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72D11B8175B;
        Wed,  1 Jun 2022 13:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD760C385A5;
        Wed,  1 Jun 2022 13:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091895;
        bh=+udP+nB4QQfzc2QUh5mctex81lBpLkJIeF+huJ+fd1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7G4hbLxwFQ/9+kXtH9AWGfNxfmMQzDO8b3a9Yzh6IBRKRDuF1lS3ZXZnEWygaO1D
         hgixZdzqi5y9YzmhUt94jXIfJFVjBAjCT2RqKtx52EU9h4i9DHs8iBdOuQYkr3zsz4
         LTCFUAWY3DNC+wq0LYVc+ONIY7AWZ7uLvrvBUbWs6alhysCtezHEjvHpEgCJTCfyTf
         rGLRT4Wt+mtNW4gFdfJh5JI5tHd4mMv/wVpOWGxwOXrC1blTvg2y+xXj4wDy+Aa5/u
         GerTmDp/RhPaMdHN/RAJcgRHm9R3aTY7P7SeJhJhMXj9QCDWkKsYj3vXGnYVz3BPid
         pMBYZGr3cQNPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        broonie@kernel.org, alexandru.elisei@arm.com, mark.rutland@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 09/26] arm64: Expand ESR_ELx_WFx_ISS_TI to match its ARMv8.7 definition
Date:   Wed,  1 Jun 2022 09:57:42 -0400
Message-Id: <20220601135759.2004435-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135759.2004435-1-sashal@kernel.org>
References: <20220601135759.2004435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 6a437208cb942a2dd98f7e1c3fd347ed3d425ffc ]

Starting with FEAT_WFXT in ARMv8.7, the TI field in the ISS
that is reported on a WFx trap is expanded by one bit to
allow the description of WFET and WFIT.

Special care is taken to exclude the WFxT bit from the mask
used to match WFI so that it also matches WFIT when trapped from
EL0.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220419182755.601427-2-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/esr.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 4a76f566e44f..2a9e7deda17a 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -132,7 +132,8 @@
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
-#define ESR_ELx_WFx_ISS_TI	(UL(1) << 0)
+#define ESR_ELx_WFx_ISS_TI	(UL(3) << 0)
+#define ESR_ELx_WFx_ISS_WFxT	(UL(2) << 0)
 #define ESR_ELx_WFx_ISS_WFI	(UL(0) << 0)
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
@@ -145,7 +146,8 @@
 #define DISR_EL1_ESR_MASK	(ESR_ELx_AET | ESR_ELx_EA | ESR_ELx_FSC)
 
 /* ESR value templates for specific events */
-#define ESR_ELx_WFx_MASK	(ESR_ELx_EC_MASK | ESR_ELx_WFx_ISS_TI)
+#define ESR_ELx_WFx_MASK	(ESR_ELx_EC_MASK |			\
+				 (ESR_ELx_WFx_ISS_TI & ~ESR_ELx_WFx_ISS_WFxT))
 #define ESR_ELx_WFx_WFI_VAL	((ESR_ELx_EC_WFx << ESR_ELx_EC_SHIFT) |	\
 				 ESR_ELx_WFx_ISS_WFI)
 
-- 
2.35.1

