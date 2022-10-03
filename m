Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1B55F29B2
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiJCHY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiJCHXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:23:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12B44AD46;
        Mon,  3 Oct 2022 00:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7539760F97;
        Mon,  3 Oct 2022 07:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8C6C433D6;
        Mon,  3 Oct 2022 07:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781321;
        bh=q4QHpmaaAtyn9aGU+5Hj6gU92GcrlTjqLaYaAGTdoRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiGRdWREUGDqgAFTR47DcKuYwyh5xl6pASgVqHt/ExfaF+IkTzdyLTJshm5x+BuKk
         q2ak8EOpvWV90W2uVCOxFGfTc2Ivg2alPsCSFsSlB1yHH8K+/Yz/VWFG8VvhsNzqOz
         aN8RygwfZfhtpy67iVjIQcD9z4itx6eoRIvzfffc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Zhu <hongxing.zhu@nxp.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Richard Leitner <richard.leitner@skidata.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 052/101] reset: imx7: Fix the iMX8MP PCIe PHY PERST support
Date:   Mon,  3 Oct 2022 09:10:48 +0200
Message-Id: <20221003070725.756039201@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 051d9eb403887bb11852b7a4f744728a6a4b1b58 ]

On i.MX7/iMX8MM/iMX8MQ, the initialized default value of PERST bit(BIT3)
of SRC_PCIEPHY_RCR is 1b'1.
But i.MX8MP has one inversed default value 1b'0 of PERST bit.

And the PERST bit should be kept 1b'1 after power and clocks are stable.
So fix the i.MX8MP PCIe PHY PERST support here.

Fixes: e08672c03981 ("reset: imx7: Add support for i.MX8MP SoC")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Marek Vasut <marex@denx.de>
Tested-by: Richard Leitner <richard.leitner@skidata.com>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/1661845564-11373-5-git-send-email-hongxing.zhu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-imx7.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/reset/reset-imx7.c b/drivers/reset/reset-imx7.c
index 185a333df66c..d2408725eb2c 100644
--- a/drivers/reset/reset-imx7.c
+++ b/drivers/reset/reset-imx7.c
@@ -329,6 +329,7 @@ static int imx8mp_reset_set(struct reset_controller_dev *rcdev,
 		break;
 
 	case IMX8MP_RESET_PCIE_CTRL_APPS_EN:
+	case IMX8MP_RESET_PCIEPHY_PERST:
 		value = assert ? 0 : bit;
 		break;
 	}
-- 
2.35.1



