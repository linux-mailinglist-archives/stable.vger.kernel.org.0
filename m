Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6DC191A4
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfEIS6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbfEISxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:53:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D94920578;
        Thu,  9 May 2019 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428015;
        bh=g85WHPlSeeNCZmBZ0LD/EXxEDcEyzF+M+UOePGG4gEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPkaMe/EcwJlPPxo2ED6PrO5Z9KpZW8w+9cqTmdt788gfMdQ9cmyISUxP0uSiWjOC
         mIw8U2rEokFQ1AZ+8TPSKUc79AIylEqUR6Lu9Z6mYlkinwgFTA9MVMr8+sM6iUJDYr
         x6/ch/cb1ljsQ9dImooFBVLsrT4RrYmoPXakAWwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Imre Kaloz <kaloz@openwrt.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.0 90/95] Bluetooth: hci_bcm: Fix empty regulator supplies for Intel Macs
Date:   Thu,  9 May 2019 20:42:47 +0200
Message-Id: <20190509181315.527130150@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

commit 62611abc8f37d00e3b0cff0eb2d72fa92b05fd27 upstream.

The code path for Macs goes through bcm_apple_get_resources(), which
skips over the code that sets up the regulator supplies. As a result,
the call to regulator_bulk_enable() / regulator_bulk_disable() results
in a NULL pointer dereference.

This was reported on the kernel.org Bugzilla, bug 202963.

Unbreak Broadcom Bluetooth support on Intel Macs by checking if the
supplies were set up before enabling or disabling them.

The same does not need to be done for the clocks, as the common clock
framework API checks for NULL pointers.

Fixes: 75d11676dccb ("Bluetooth: hci_bcm: Add support for regulator supplies")
Cc: <stable@vger.kernel.org> # 5.0.x
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Imre Kaloz <kaloz@openwrt.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_bcm.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -228,9 +228,15 @@ static int bcm_gpio_set_power(struct bcm
 	int err;
 
 	if (powered && !dev->res_enabled) {
-		err = regulator_bulk_enable(BCM_NUM_SUPPLIES, dev->supplies);
-		if (err)
-			return err;
+		/* Intel Macs use bcm_apple_get_resources() and don't
+		 * have regulator supplies configured.
+		 */
+		if (dev->supplies[0].supply) {
+			err = regulator_bulk_enable(BCM_NUM_SUPPLIES,
+						    dev->supplies);
+			if (err)
+				return err;
+		}
 
 		/* LPO clock needs to be 32.768 kHz */
 		err = clk_set_rate(dev->lpo_clk, 32768);
@@ -259,7 +265,13 @@ static int bcm_gpio_set_power(struct bcm
 	if (!powered && dev->res_enabled) {
 		clk_disable_unprepare(dev->txco_clk);
 		clk_disable_unprepare(dev->lpo_clk);
-		regulator_bulk_disable(BCM_NUM_SUPPLIES, dev->supplies);
+
+		/* Intel Macs use bcm_apple_get_resources() and don't
+		 * have regulator supplies configured.
+		 */
+		if (dev->supplies[0].supply)
+			regulator_bulk_disable(BCM_NUM_SUPPLIES,
+					       dev->supplies);
 	}
 
 	/* wait for device to power on and come out of reset */


