Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F12521786
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241515AbiEJN1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242909AbiEJNZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:25:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E6B20D252;
        Tue, 10 May 2022 06:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 986E461532;
        Tue, 10 May 2022 13:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A540DC385C9;
        Tue, 10 May 2022 13:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188681;
        bh=QAylgGAnWTHI63CrZv++ZasyUi2vG4ZKOEZ/qv6ifDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPE89+DAkhAz+QzAQpdM+e0td3hqnlZzHx6Qevn4W7uTelYK5sDUWR8tz7QljN8Jy
         yOYeOEc/aJQzHZGEF5zTDtEivLZAORHzszPrH/o4II1JO5PbsRB3904c0WJpG67zfA
         kSqeNQKUOva/xKdXkR1EcaeN0AorW9ujvtY4oplA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Tainping Fang <tianping.fang@mediatek.com>
Subject: [PATCH 4.19 01/88] usb: mtu3: fix USB 3.0 dual-role-switch from device to host
Date:   Tue, 10 May 2022 15:06:46 +0200
Message-Id: <20220510130733.781213599@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Macpaul Lin <macpaul.lin@mediatek.com>

commit 456244aeecd54249096362a173dfe06b82a5cafa upstream.

Issue description:
  When an OTG port has been switched to device role and then switch back
  to host role again, the USB 3.0 Host (XHCI) will not be able to detect
  "plug in event of a connected USB 2.0/1.0 ((Highspeed and Fullspeed)
  devices until system reboot.

Root cause and Solution:
  There is a condition checking flag "ssusb->otg_switch.is_u3_drd" in
  toggle_opstate(). At the end of role switch procedure, toggle_opstate()
  will be called to set DC_SESSION and SOFT_CONN bit. If "is_u3_drd" was
  set and switched the role to USB host 3.0, bit DC_SESSION and SOFT_CONN
  will be skipped hence caused the port cannot detect connected USB 2.0
  (Highspeed and Fullspeed) devices. Simply remove the condition check to
  solve this issue.

Fixes: d0ed062a8b75 ("usb: mtu3: dual-role mode support")
Cc: stable@vger.kernel.org
Tested-by: Fabien Parent <fparent@baylibre.com>
Reviewed-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Signed-off-by: Tainping Fang <tianping.fang@mediatek.com>
Link: https://lore.kernel.org/r/20220419081245.21015-1-macpaul.lin@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mtu3/mtu3_dr.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/usb/mtu3/mtu3_dr.c
+++ b/drivers/usb/mtu3/mtu3_dr.c
@@ -30,10 +30,8 @@ enum mtu3_vbus_id_state {
 
 static void toggle_opstate(struct ssusb_mtk *ssusb)
 {
-	if (!ssusb->otg_switch.is_u3_drd) {
-		mtu3_setbits(ssusb->mac_base, U3D_DEVICE_CONTROL, DC_SESSION);
-		mtu3_setbits(ssusb->mac_base, U3D_POWER_MANAGEMENT, SOFT_CONN);
-	}
+	mtu3_setbits(ssusb->mac_base, U3D_DEVICE_CONTROL, DC_SESSION);
+	mtu3_setbits(ssusb->mac_base, U3D_POWER_MANAGEMENT, SOFT_CONN);
 }
 
 /* only port0 supports dual-role mode */


