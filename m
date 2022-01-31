Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925DC4A3F29
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 10:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238556AbiAaJYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 04:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiAaJYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 04:24:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A94C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 01:24:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E33DCE10E6
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 09:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30DBC340E8;
        Mon, 31 Jan 2022 09:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643621077;
        bh=Soq3weMdREJkHX5LRONHFKswdHRa9ZR/VYPVD2WQ/bw=;
        h=Subject:To:From:Date:From;
        b=hZEDeJt3hVQ+Akl4sPtcmoeyxK1Ps1L0csxLWill7uvJnOT3HlkIABMiRLsGzGXh+
         Fuzx1aorveSlUw2gZYl2tR2PKQiStSF8LGUh4GwCqSjxhr7fc60fAqGlTKPN4UNrdl
         CnYhK2FxRDAGyxzG1i9t8jKP17cUb57+2fFjXGAk=
Subject: patch "usb: dwc3: xilinx: fix uninitialized return value" added to usb-linus
To:     robert.hancock@calian.com, gregkh@linuxfoundation.org,
        nathan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 10:24:34 +0100
Message-ID: <164362107465184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: xilinx: fix uninitialized return value

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b470947c3672f7eb7c4c271d510383d896831cc2 Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Thu, 27 Jan 2022 16:15:00 -0600
Subject: usb: dwc3: xilinx: fix uninitialized return value

A previous patch to skip part of the initialization when a USB3 PHY was
not present could result in the return value being uninitialized in that
case, causing spurious probe failures. Initialize ret to 0 to avoid this.

Fixes: 9678f3361afc ("usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0 mode")
Cc: <stable@vger.kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220127221500.177021-1-robert.hancock@calian.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-xilinx.c b/drivers/usb/dwc3/dwc3-xilinx.c
index e14ac15e24c3..a6f3a9b38789 100644
--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -99,7 +99,7 @@ static int dwc3_xlnx_init_zynqmp(struct dwc3_xlnx *priv_data)
 	struct device		*dev = priv_data->dev;
 	struct reset_control	*crst, *hibrst, *apbrst;
 	struct phy		*usb3_phy;
-	int			ret;
+	int			ret = 0;
 	u32			reg;
 
 	usb3_phy = devm_phy_optional_get(dev, "usb3-phy");
-- 
2.35.1


