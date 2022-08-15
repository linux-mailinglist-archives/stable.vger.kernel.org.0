Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED5594175
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346146AbiHOUtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346151AbiHOUtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:49:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D705B81E0;
        Mon, 15 Aug 2022 12:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 627646069E;
        Mon, 15 Aug 2022 19:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A63AC433C1;
        Mon, 15 Aug 2022 19:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590548;
        bh=+iw9H9HE5DC6fgpz+aGX4rOtBTIwTitF/Aqy17elXPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mnh3u/gqYL36Y3vsVffq/sZwf28uprhqXEe2TJD5VWIyCZZb8n5o5Gb6rwIOC3Iao
         i9n1DNHbVP4EyBdgiCrX6ga4ojg8eo3hlRqixw1/+7oATLYp+ozlCazlZH4sYNK/hR
         TqND1JJ8Q8YUoAxieKO19WNULeiWa7yNZT7PlyiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0293/1095] arm64: Expand ESR_ELx_WFx_ISS_TI to match its ARMv8.7 definition
Date:   Mon, 15 Aug 2022 19:54:52 +0200
Message-Id: <20220815180441.903354670@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



