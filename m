Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A043D3185B5
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 08:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBKHdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 02:33:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhBKHdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 02:33:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ACFD61490;
        Thu, 11 Feb 2021 07:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613028760;
        bh=ahqEURpfS6ItRI/OwjSoq1S66+zEpRexf3MN9D7SGyo=;
        h=Subject:To:From:Date:From;
        b=nG37fs3yzFpL3liySFSf/dYj1XbbwPOutNLMjStIByx8Mg3jENRBVtG8vaGX0mFyk
         elwxez2DXcFXAmtLJzgW4Y/Bm9/azxfGoqJqZ7N0waHcydMgdsHBQ6zz5HD4Agj2Sg
         gPdzDpobnKUNEm4z491P0OwXsH80WRnOfxaXwUQg=
Subject: patch "phy: lantiq: rcu-usb2: wait after clock enable" added to char-misc-next
To:     dev@kresin.me, hauke@hauke-m.de,
        martin.blumenstingl@googlemail.com, stable@vger.kernel.org,
        vkoul@kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Feb 2021 08:32:21 +0100
Message-ID: <1613028741111129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    phy: lantiq: rcu-usb2: wait after clock enable

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 36acd5e24e3000691fb8d1ee31cf959cb1582d35 Mon Sep 17 00:00:00 2001
From: Mathias Kresin <dev@kresin.me>
Date: Thu, 7 Jan 2021 23:49:01 +0100
Subject: phy: lantiq: rcu-usb2: wait after clock enable

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
---
 drivers/phy/lantiq/phy-lantiq-rcu-usb2.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c b/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
index a7d126192cf1..29d246ea24b4 100644
--- a/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
+++ b/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
@@ -124,8 +124,16 @@ static int ltq_rcu_usb2_phy_power_on(struct phy *phy)
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
-- 
2.30.1


