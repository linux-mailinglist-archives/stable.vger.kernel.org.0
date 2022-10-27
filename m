Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4230960FDBF
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbiJ0Q6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236596AbiJ0Q6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B7216D8BA
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7633B623EC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE50C433D6;
        Thu, 27 Oct 2022 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889914;
        bh=xmOwF3lFTxii+2ksU1wTsuc1o52x2grEL8f/o5NdLs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7I7LodIb6XnRA/1ChSkS99KZWCNMXaFjZr/Q4OZPIQkxz0A7ODI6fd/jR9H/G/mh
         wVzNDvtrqPG/raaEJ0EC/05oJ5Pzbe4p6C52+pVcVFLwiaSktwJkNS2yaMXoM1ZGmX
         LTb0C8itf55d7SdPt8BGdNdI9UTUwHRyWZhDwktM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 46/94] net: phylink: add mac_managed_pm in phylink_config structure
Date:   Thu, 27 Oct 2022 18:54:48 +0200
Message-Id: <20221027165059.000311127@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
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

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit 96de900ae78e7dbedc937fd91bafe2934579c65a ]

The recent commit

'commit 744d23c71af3 ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state")'

requires the MAC driver explicitly tell the phy driver who is
managing the PM, otherwise you will see warning during resume
stage.

Add a boolean property in the phylink_config structure so that
the MAC driver can use it to tell the PHY driver if it wants to
manage the PM.

Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 3 +++
 include/linux/phylink.h   | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9bd69328dc4d..7bbbe69a7b0a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1431,6 +1431,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	if (phy_interrupt_is_valid(phy))
 		phy_request_interrupt(phy);
 
+	if (pl->config->mac_managed_pm)
+		phy->mac_managed_pm = true;
+
 	return 0;
 }
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..a3adf7fe7eaf 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -88,6 +88,7 @@ enum phylink_op_type {
  *	(See commit 7cceb599d15d ("net: phylink: avoid mac_config calls")
  * @poll_fixed_state: if true, starts link_poll,
  *		      if MAC link is at %MLO_AN_FIXED mode.
+ * @mac_managed_pm: if true, indicate the MAC driver is responsible for PHY PM.
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
@@ -100,6 +101,7 @@ struct phylink_config {
 	enum phylink_op_type type;
 	bool legacy_pre_march2020;
 	bool poll_fixed_state;
+	bool mac_managed_pm;
 	bool ovr_an_inband;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
-- 
2.35.1



