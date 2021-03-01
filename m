Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C65328FB6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbhCATzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhCATod (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BCD26522F;
        Mon,  1 Mar 2021 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619559;
        bh=FXyUN6mPqd37HOZDi4nQevb3kLIw+Q+l9fL4/yhn+7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iAIxiUZVB++BOUiP63OoGAypKHh1CdJHqYyKnNMDnDzu3spASON2OiOy8Jvfmn5wH
         RjMiKfuVUtU9g5oitxLxrqWv0nAdVanD5y2mKxad1C1uuU4TsOerz/sArGOaeGpSO6
         so43keGB9nwfGYOFi9Qdlp8VcSH1Zs/YMi3ir5SE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 499/663] phy: lantiq: rcu-usb2: wait after clock enable
Date:   Mon,  1 Mar 2021 17:12:27 +0100
Message-Id: <20210301161206.539325474@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Kresin <dev@kresin.me>

commit 36acd5e24e3000691fb8d1ee31cf959cb1582d35 upstream.

Commit 65dc2e725286 ("usb: dwc2: Update Core Reset programming flow.")
revealed that the phy isn't ready immediately after enabling it's
clocks. The dwc2_check_core_version() fails and the dwc2 usb driver
errors out.

Add a short delay to let the phy get up and running. There isn't any
documentation how much time is required, the value was chosen based on
tests.

Signed-off-by: Mathias Kresin <dev@kresin.me>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: <stable@vger.kernel.org> # v5.7+
Link: https://lore.kernel.org/r/20210107224901.2102479-1-dev@kresin.me
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/lantiq/phy-lantiq-rcu-usb2.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
+++ b/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
@@ -124,8 +124,16 @@ static int ltq_rcu_usb2_phy_power_on(str
 	reset_control_deassert(priv->phy_reset);
 
 	ret = clk_prepare_enable(priv->phy_gate_clk);
-	if (ret)
+	if (ret) {
 		dev_err(dev, "failed to enable PHY gate\n");
+		return ret;
+	}
+
+	/*
+	 * at least the xrx200 usb2 phy requires some extra time to be
+	 * operational after enabling the clock
+	 */
+	usleep_range(100, 200);
 
 	return ret;
 }


