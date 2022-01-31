Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C190C4A442C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359084AbiAaL1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359148AbiAaLZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9318AC08EAC8;
        Mon, 31 Jan 2022 03:15:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52D82B82A5F;
        Mon, 31 Jan 2022 11:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BA3C340E8;
        Mon, 31 Jan 2022 11:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627731;
        bh=JYdwXVjLD3x1rCvNs/UGJbi7gDiPUI4GZnEf8WfRi5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2OM3qz+B2eYVAN3e0LVBzckNl9CdNacLXLjPg7diva6Y+IcmvathDoYlZXSgUZwF
         jcNbN6MPDjfQxJBK++7R5v1JkdVSXyFFG1E6qgr23NrkvN4r0SLuHkzHat1i3bqHk9
         p0EVwKjg3zx9z5QBaNM4qjWcLGhJzj+z0XDlOhYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH 5.15 168/171] usb: dwc3: xilinx: fix uninitialized return value
Date:   Mon, 31 Jan 2022 11:57:13 +0100
Message-Id: <20220131105235.700071067@linuxfoundation.org>
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

commit b470947c3672f7eb7c4c271d510383d896831cc2 upstream.

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
 drivers/usb/dwc3/dwc3-xilinx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -99,7 +99,7 @@ static int dwc3_xlnx_init_zynqmp(struct
 	struct device		*dev = priv_data->dev;
 	struct reset_control	*crst, *hibrst, *apbrst;
 	struct phy		*usb3_phy;
-	int			ret;
+	int			ret = 0;
 	u32			reg;
 
 	usb3_phy = devm_phy_optional_get(dev, "usb3-phy");


