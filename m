Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FF1541CC4
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378736AbiFGWEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382809AbiFGWD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:03:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1CA195792;
        Tue,  7 Jun 2022 12:14:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DCF36192C;
        Tue,  7 Jun 2022 19:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E621C385A2;
        Tue,  7 Jun 2022 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629293;
        bh=W+FTR3kkajvWd2nZMl638Zr2vjMDmiXlj6AHR6X5zLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYmZZLxNCP+vJALt1oCgoRSwVPNPOL9L5eBEqPuAZoiBh5YQNFhCUbjFvelwTbRZB
         PcsUp1GyG5iI9PYseSSAN8XJeFQrHOgRTFfGSl3388P3Ma9sVzBIrfe5Pms5zCqua0
         5DqMGrSfiZDCFOMtdvgHjiphT78LCntdyUwHVOQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Russell Currey <ruscur@russell.cc>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 640/879] powerpc/powernv: Get STF barrier requirements from device-tree
Date:   Tue,  7 Jun 2022 19:02:38 +0200
Message-Id: <20220607165021.423783578@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell Currey <ruscur@russell.cc>

[ Upstream commit d2a3c131981d4498571908df95c3c9393a00adf5 ]

The device-tree property no-need-store-drain-on-priv-state-switch is
equivalent to H_CPU_BEHAV_NO_STF_BARRIER from the
H_CPU_GET_CHARACTERISTICS hcall on pseries.

Since commit 84ed26fd00c5 ("powerpc/security: Add a security feature for
STF barrier") powernv systems with this device-tree property have been
enabling the STF barrier when they have no need for it.  This patch
fixes this by clearing the STF barrier feature on those systems.

Fixes: 84ed26fd00c5 ("powerpc/security: Add a security feature for STF barrier")
Reported-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220404101536.104794-2-ruscur@russell.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/setup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 378f7e5f18d2..824c3ad7a0fa 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -102,6 +102,9 @@ static void __init init_fw_feat_flags(struct device_node *np)
 
 	if (fw_feature_is("enabled", "no-need-l1d-flush-kernel-on-user-access", np))
 		security_ftr_clear(SEC_FTR_L1D_FLUSH_UACCESS);
+
+	if (fw_feature_is("enabled", "no-need-store-drain-on-priv-state-switch", np))
+		security_ftr_clear(SEC_FTR_STF_BARRIER);
 }
 
 static void __init pnv_setup_security_mitigations(void)
-- 
2.35.1



