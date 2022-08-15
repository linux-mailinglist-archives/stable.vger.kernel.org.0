Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EAA5945DB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347116AbiHOWDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345496AbiHOV76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:59:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693D621F;
        Mon, 15 Aug 2022 12:35:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69F936114B;
        Mon, 15 Aug 2022 19:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58084C433C1;
        Mon, 15 Aug 2022 19:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592087;
        bh=mZgyq4mZcLQWF74aSysmnrWML+QTOy4RTquSjSzQl3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZE/Y4zwEsh49GlbgalCIRkSYqzttPpq2WbNZ/Ba45w+lzLVcGWZaUkVHogaJBy78
         Hwuecq0DdYmeqSyDKUXGeWOy0/kPY7dZXZ15gxhnbATZ793MVlDgaTuvsjQOAqyUmD
         6FGky/UJC6KzfcmPe4uwwVPC0M2a+XnjSwC6pO6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0732/1095] phy: qcom-qmp: fix the QSERDES_V5_COM_CMN_MODE register
Date:   Mon, 15 Aug 2022 20:02:11 +0200
Message-Id: <20220815180459.679762967@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 488987b2d5cade4e7680f7e81590435a848d1fa9 ]

Change QSERDES_V5_COM_CMN_MODE to be defined to 0x1a0 rather than 0x1a4.
The only user of this register name (sm8450_qmp_gen4x2_pcie_serdes_tbl)
should use the 0x1a0 register, as stated in the downstream dtsi tree.

Fixes: 2c91bf6bf290 ("phy: qcom-qmp: Add SM8450 PCIe1 PHY support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220705094320.1313312-2-dmitry.baryshkov@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.h b/drivers/phy/qualcomm/phy-qcom-qmp.h
index 06b2556ed93a..b9a91520439c 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.h
@@ -1116,7 +1116,8 @@
 #define QSERDES_V5_COM_CORE_CLK_EN			0x174
 #define QSERDES_V5_COM_CMN_CONFIG			0x17c
 #define QSERDES_V5_COM_CMN_MISC1			0x19c
-#define QSERDES_V5_COM_CMN_MODE				0x1a4
+#define QSERDES_V5_COM_CMN_MODE				0x1a0
+#define QSERDES_V5_COM_CMN_MODE_CONTD			0x1a4
 #define QSERDES_V5_COM_VCO_DC_LEVEL_CTRL		0x1a8
 #define QSERDES_V5_COM_BIN_VCOCAL_CMP_CODE1_MODE0	0x1ac
 #define QSERDES_V5_COM_BIN_VCOCAL_CMP_CODE2_MODE0	0x1b0
-- 
2.35.1



