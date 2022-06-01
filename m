Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28C353A6F9
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353941AbiFAN5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353939AbiFAN4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:56:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533149BAEB;
        Wed,  1 Jun 2022 06:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0BF9B81AF5;
        Wed,  1 Jun 2022 13:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAB7C385A5;
        Wed,  1 Jun 2022 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091693;
        bh=+iw9H9HE5DC6fgpz+aGX4rOtBTIwTitF/Aqy17elXPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gO5PdHOLs/YNv2PkxN13AXIguPfwz9uWU7xD5UKETAN4u5fKqTZ0NcLL6pNSOxvUO
         Tf7TmvYkmgVygKJQwqGssjay9argdb9d3Caf9ZLY7/JsAH41kvQIQjDGlgP762MQ5U
         QWtLJQArReaFkKAJBfPr2ugiOdQdOJOQerYj4rJSfrVP0oTOVmKEOeV78hRcZLeWaR
         a0Sd2eDLV5BFkc9Rp2anCbZUFHfoC3C1eypx6prcp/Kc09eNLSVFy1YBss00xqmGKc
         kNTVXD3peaAFlAV84TJx3KGniuKRGQrlty9Dv2Ibccc6VtOiJE7CbPLRkoxFuUYPDk
         ldi/dVWeKBLMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        alexandru.elisei@arm.com, broonie@kernel.org, mark.rutland@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 15/48] arm64: Expand ESR_ELx_WFx_ISS_TI to match its ARMv8.7 definition
Date:   Wed,  1 Jun 2022 09:53:48 -0400
Message-Id: <20220601135421.2003328-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
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
index d52a0b269ee8..65c2201b11b2 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -133,7 +133,8 @@
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
-#define ESR_ELx_WFx_ISS_TI	(UL(1) << 0)
+#define ESR_ELx_WFx_ISS_TI	(UL(3) << 0)
+#define ESR_ELx_WFx_ISS_WFxT	(UL(2) << 0)
 #define ESR_ELx_WFx_ISS_WFI	(UL(0) << 0)
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
@@ -146,7 +147,8 @@
 #define DISR_EL1_ESR_MASK	(ESR_ELx_AET | ESR_ELx_EA | ESR_ELx_FSC)
 
 /* ESR value templates for specific events */
-#define ESR_ELx_WFx_MASK	(ESR_ELx_EC_MASK | ESR_ELx_WFx_ISS_TI)
+#define ESR_ELx_WFx_MASK	(ESR_ELx_EC_MASK |			\
+				 (ESR_ELx_WFx_ISS_TI & ~ESR_ELx_WFx_ISS_WFxT))
 #define ESR_ELx_WFx_WFI_VAL	((ESR_ELx_EC_WFx << ESR_ELx_EC_SHIFT) |	\
 				 ESR_ELx_WFx_ISS_WFI)
 
-- 
2.35.1

