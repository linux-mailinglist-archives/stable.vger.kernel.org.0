Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3019D4B3B0E
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 12:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiBMLTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 06:19:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiBMLTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 06:19:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C755B3F9
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 03:19:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2FC761030
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 11:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB07C004E1;
        Sun, 13 Feb 2022 11:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644751147;
        bh=6/86ek7byl9W9LbaqiMjbmmFxA66AQt+mNnF+2KS7NA=;
        h=Subject:To:Cc:From:Date:From;
        b=LMGOKjoKKCl8xjR4f8wvllHJDAmhsKyAzbpcZrcm7hjo6toAZhI+MQSP2MIPtV1l6
         fgRJFLgHldFZZZSmzwekJwk30NBnst0F6vDWGtgeGwtNWHbbpMojuenYprAsP+/8JF
         9EMj2Hka7orM7KKHmtY5FJriVhb4S9pBadGa2tV0=
Subject: FAILED: patch "[PATCH] usb: dwc3: xilinx: fix uninitialized return value" failed to apply to 5.16-stable tree
To:     robert.hancock@calian.com, gregkh@linuxfoundation.org,
        nathan@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Feb 2022 12:18:56 +0100
Message-ID: <16447511361422@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b470947c3672f7eb7c4c271d510383d896831cc2 Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Thu, 27 Jan 2022 16:15:00 -0600
Subject: [PATCH] usb: dwc3: xilinx: fix uninitialized return value

A previous patch to skip part of the initialization when a USB3 PHY was
not present could result in the return value being uninitialized in that
case, causing spurious probe failures. Initialize ret to 0 to avoid this.

Fixes: 9678f3361afc ("usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0 mode")
Cc: <stable@vger.kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220127221500.177021-1-robert.hancock@calian.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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

