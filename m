Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE32D4A4264
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245201AbiAaLLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57342 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376998AbiAaLJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D684B82A5C;
        Mon, 31 Jan 2022 11:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBBFC340E8;
        Mon, 31 Jan 2022 11:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627365;
        bh=/O5ULg9U3NkwqzR/0Avq3jo3LXQjoxTI7QzSubb6GLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHrhR3fHNGMoj7G0eoygTV05am1ICLUyi2inqy22A1IhPZ7Q3WQeU0sMhXWNhP2e+
         Ido67G6h8yxp6n+JzPXlYAtkcaJpDJ5EXOzcd3YM1fP+mzcigaR+d1ub3hVJXgpiew
         nD5EhXEHesZGDqmwxSvaNE1YhZ3g22oPWmI0xTvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH 5.15 059/171] usb: dwc3: xilinx: Fix error handling when getting USB3 PHY
Date:   Mon, 31 Jan 2022 11:55:24 +0100
Message-Id: <20220131105232.020652201@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 2cc9b1c93b1c4caa2d971856c0780fb5f7d04692 upstream.

The code that looked up the USB3 PHY was ignoring all errors other than
EPROBE_DEFER in an attempt to handle the PHY not being present. Fix and
simplify the code by using devm_phy_optional_get and dev_err_probe so
that a missing PHY is not treated as an error and unexpected errors
are handled properly.

Fixes: 84770f028fab ("usb: dwc3: Add driver for Xilinx platforms")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220126000253.1586760-3-robert.hancock@calian.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -102,12 +102,12 @@ static int dwc3_xlnx_init_zynqmp(struct
 	int			ret;
 	u32			reg;
 
-	usb3_phy = devm_phy_get(dev, "usb3-phy");
-	if (PTR_ERR(usb3_phy) == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
+	usb3_phy = devm_phy_optional_get(dev, "usb3-phy");
+	if (IS_ERR(usb3_phy)) {
+		ret = PTR_ERR(usb3_phy);
+		dev_err_probe(dev, ret,
+			      "failed to get USB3 PHY\n");
 		goto err;
-	} else if (IS_ERR(usb3_phy)) {
-		usb3_phy = NULL;
 	}
 
 	/*


