Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C11579C1E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240789AbiGSMgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240210AbiGSMfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043E77A52D;
        Tue, 19 Jul 2022 05:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10F63B81B2E;
        Tue, 19 Jul 2022 12:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745D8C341C6;
        Tue, 19 Jul 2022 12:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232799;
        bh=Mkvf0EX9t/n0RX1AyTZNR8hPmODfZOits7KU9Qsew+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXbocjIN//zUUUeGVBOFjnCHpnaCLolKB3PMwjoP5D+L+zcEGy5M/FiDJ/PSVpCGo
         6GT2+Lzhp+oewfyh1CSMCp+nZ9ZNe6GNHB9+0quJ38AR452JJH/Xy5kLEjNTgLvD+F
         OmsKYyrhCuFIPFPAXPZSsDGHjLPO5TlmLOFXCmfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/167] net: stmmac: dwc-qos: Disable split header for Tegra194
Date:   Tue, 19 Jul 2022 13:53:01 +0200
Message-Id: <20220719114701.360777010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 029c1c2059e9c4b38f97a06204cdecd10cfbeb8a ]

There is a long-standing issue with the Synopsys DWC Ethernet driver
for Tegra194 where random system crashes have been observed [0]. The
problem occurs when the split header feature is enabled in the stmmac
driver. In the bad case, a larger than expected buffer length is
received and causes the calculation of the total buffer length to
overflow. This results in a very large buffer length that causes the
kernel to crash. Why this larger buffer length is received is not clear,
however, the feedback from the NVIDIA design team is that the split
header feature is not supported for Tegra194. Therefore, disable split
header support for Tegra194 to prevent these random crashes from
occurring.

[0] https://lore.kernel.org/linux-tegra/b0b17697-f23e-8fa5-3757-604a86f3a095@nvidia.com/

Fixes: 67afd6d1cfdf ("net: stmmac: Add Split Header support and enable it in XGMAC cores")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20220706083913.13750-1-jonathanh@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index bc91fd867dcd..358fc26f8d1f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -361,6 +361,7 @@ static int tegra_eqos_probe(struct platform_device *pdev,
 	data->fix_mac_speed = tegra_eqos_fix_speed;
 	data->init = tegra_eqos_init;
 	data->bsp_priv = eqos;
+	data->sph_disable = 1;
 
 	err = tegra_eqos_init(pdev, eqos);
 	if (err < 0)
-- 
2.35.1



