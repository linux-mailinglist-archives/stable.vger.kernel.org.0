Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D5960A70C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbiJXMrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbiJXMoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:44:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE4C7CE00;
        Mon, 24 Oct 2022 05:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16A1A61290;
        Mon, 24 Oct 2022 11:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D123C433D7;
        Mon, 24 Oct 2022 11:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612360;
        bh=se1kNYoyh1c3+l4JRa6OE9QKY6HWsSzNgEKBIgh4c+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2KODyvsjmxhGUQOv7XeVbNfMt4FZyY4rQfbQjEiKeItJn8QOPCIx45N9d6pliRrN
         ahxiPB3Xb2UPqwaXpIumEeOH+2H5xv16kmHcIsw2paqH1IsKAAw1ak9UIub1VMzeB4
         KsG9l8YbbW3tf4k0mw/A5OUiXTJ1ap/oeOLYwFLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 138/210] phy: qualcomm: call clk_disable_unprepare in the error handling
Date:   Mon, 24 Oct 2022 13:30:55 +0200
Message-Id: <20221024113001.469398282@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit c3966ced8eb8dc53b6c8d7f97d32cc8a2107d83e ]

Smatch reports the following error:

drivers/phy/qualcomm/phy-qcom-usb-hsic.c:82 qcom_usb_hsic_phy_power_on()
warn: 'uphy->cal_clk' from clk_prepare_enable() not released on lines:
58.
drivers/phy/qualcomm/phy-qcom-usb-hsic.c:82 qcom_usb_hsic_phy_power_on()
warn: 'uphy->cal_sleep_clk' from clk_prepare_enable() not released on
lines: 58.
drivers/phy/qualcomm/phy-qcom-usb-hsic.c:82 qcom_usb_hsic_phy_power_on()
warn: 'uphy->phy_clk' from clk_prepare_enable() not released on lines:
58.

Fix this by calling proper clk_disable_unprepare calls.

Fixes: 0b56e9a7e835 ("phy: Group vendor specific phy drivers")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20220914051334.69282-1-dzm91@hust.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-usb-hsic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-usb-hsic.c b/drivers/phy/qualcomm/phy-qcom-usb-hsic.c
index c110563a73cb..00926df4bc5b 100644
--- a/drivers/phy/qualcomm/phy-qcom-usb-hsic.c
+++ b/drivers/phy/qualcomm/phy-qcom-usb-hsic.c
@@ -57,8 +57,10 @@ static int qcom_usb_hsic_phy_power_on(struct phy *phy)
 
 	/* Configure pins for HSIC functionality */
 	pins_default = pinctrl_lookup_state(uphy->pctl, PINCTRL_STATE_DEFAULT);
-	if (IS_ERR(pins_default))
-		return PTR_ERR(pins_default);
+	if (IS_ERR(pins_default)) {
+		ret = PTR_ERR(pins_default);
+		goto err_ulpi;
+	}
 
 	ret = pinctrl_select_state(uphy->pctl, pins_default);
 	if (ret)
-- 
2.35.1



