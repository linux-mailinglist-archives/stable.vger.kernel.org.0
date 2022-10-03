Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCF85F2984
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJCHUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiJCHTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:19:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420E136094;
        Mon,  3 Oct 2022 00:15:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 26DC3CE0AF2;
        Mon,  3 Oct 2022 07:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A56C433D6;
        Mon,  3 Oct 2022 07:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781286;
        bh=BDGFTzj7X2dKvLVLsWyErQjs+PtoFcPQrpCwZNusabE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vylEvwH18PVyXPDkZaDy1nzmlAxYVZ4P/Bli2iYBbjR0TjtRmm3HJRzV7n7xGM20t
         e3ee4kZ4uuMo6Taa/ab+FRpvtr23bm/SQkf1QyZeSjxqB/p2bCxq1YjTAoV8ysDam5
         5ZVMgWn052qOMZm/OAjiIA+sVle7YVlNWh/ycW6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 066/101] net: macb: Fix ZynqMP SGMII non-wakeup source resume failure
Date:   Mon,  3 Oct 2022 09:11:02 +0200
Message-Id: <20221003070726.112181367@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit f22bd29ba19a43e758b192429613e04aa7abb70d ]

When GEM is in SGMII mode and disabled as a wakeup source, the power
management controller can power down the entire full power domain(FPD)
if none of the FPD devices are in use.

Incase of FPD off, there are below ethernet link up issues on non-wakeup
suspend/resume. To fix it add phy_exit() in suspend and phy_init() in the
resume path which reinitializes PS GTR SGMII lanes.

$ echo +20 > /sys/class/rtc/rtc0/wakealarm
$ echo mem > /sys/power/state

After resume:

$ ifconfig eth0 up
xilinx-psgtr fd400000.phy: lane 0 (type 10, protocol 5): PLL lock timeout
phy phy-fd400000.phy.0: phy poweron failed --> -110
xilinx-psgtr fd400000.phy: lane 0 (type 10, protocol 5): PLL lock timeout
SIOCSIFFLAGS: Connection timed out
phy phy-fd400000.phy.0: phy poweron failed --> -110

Fixes: 8b73fa3ae02b ("net: macb: Added ZynqMP-specific initialization")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d89098f4ede8..e9aa41949a4b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5092,6 +5092,7 @@ static int __maybe_unused macb_suspend(struct device *dev)
 	if (!(bp->wol & MACB_WOL_ENABLED)) {
 		rtnl_lock();
 		phylink_stop(bp->phylink);
+		phy_exit(bp->sgmii_phy);
 		rtnl_unlock();
 		spin_lock_irqsave(&bp->lock, flags);
 		macb_reset_hw(bp);
@@ -5181,6 +5182,9 @@ static int __maybe_unused macb_resume(struct device *dev)
 	macb_set_rx_mode(netdev);
 	macb_restore_features(bp);
 	rtnl_lock();
+	if (!device_may_wakeup(&bp->dev->dev))
+		phy_init(bp->sgmii_phy);
+
 	phylink_start(bp->phylink);
 	rtnl_unlock();
 
-- 
2.35.1



