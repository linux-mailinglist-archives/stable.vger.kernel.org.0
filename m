Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7DC50F74B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiDZJIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347906AbiDZJGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B01B42FC;
        Tue, 26 Apr 2022 01:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A218F603E0;
        Tue, 26 Apr 2022 08:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998D6C385A0;
        Tue, 26 Apr 2022 08:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962821;
        bh=/gJsLD6N+b5xNTzzF4Bzt0cAnW+Ky2AHaiBFQ8+lpCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5fXbhJY9iJC2HqVobCmKJJKIZozadcs/BcieG7y+OhRsZ76MBT1GoaN5LtfvRQd/
         KMJeoRWty1wAdJK45hEGDVnX7iwbvNWktHmhDnU7HWbzWxTnkptOANs5d3t0RjJGPO
         jNU7wY9QlVIdW3drFel7awCarXtls+xCoQiBJghQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 061/146] reset: renesas: Check return value of reset_control_deassert()
Date:   Tue, 26 Apr 2022 10:20:56 +0200
Message-Id: <20220426081751.781790686@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit da18980a855edf44270f05455e0ec3f2472f64cc ]

Deasserting the reset is vital, therefore bail out in case of error.

Suggested-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/b2131908-0110-006b-862f-080517f3e2d8@gmail.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-rzg2l-usbphy-ctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/reset-rzg2l-usbphy-ctrl.c b/drivers/reset/reset-rzg2l-usbphy-ctrl.c
index 1e8315038850..a8dde4606360 100644
--- a/drivers/reset/reset-rzg2l-usbphy-ctrl.c
+++ b/drivers/reset/reset-rzg2l-usbphy-ctrl.c
@@ -121,7 +121,9 @@ static int rzg2l_usbphy_ctrl_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(priv->rstc),
 				     "failed to get reset\n");
 
-	reset_control_deassert(priv->rstc);
+	error = reset_control_deassert(priv->rstc);
+	if (error)
+		return error;
 
 	priv->rcdev.ops = &rzg2l_usbphy_ctrl_reset_ops;
 	priv->rcdev.of_reset_n_cells = 1;
-- 
2.35.1



