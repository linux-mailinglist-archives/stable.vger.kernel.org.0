Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286DC51A967
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiEDRNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356693AbiEDRJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF231573B;
        Wed,  4 May 2022 09:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9672618AC;
        Wed,  4 May 2022 16:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042EFC385A5;
        Wed,  4 May 2022 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683322;
        bh=tKZj744Ki6jJM/kUR5/uSIXL2DmzSoeiIvGPzX9mJc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRpyS4ucYue8RFMSyyCi5RobqG4qkEO+3P1LN503huEMpWrtfGd9AS+lUuMOsSjQs
         /gFVZaUce+tsUpHzPh88m44siEy6PCqsOngMTbcmdo4rjlcNc0az/BG89zolZ/INqd
         y5S8DLCYPRbNBjM2D0TlF5dab7XlmokLA17840QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Tainping Fang <tianping.fang@mediatek.com>
Subject: [PATCH 5.17 001/225] usb: mtu3: fix USB 3.0 dual-role-switch from device to host
Date:   Wed,  4 May 2022 18:43:59 +0200
Message-Id: <20220504153110.258558138@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/usb/mtu3/mtu3_dr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/mtu3/mtu3_dr.c b/drivers/usb/mtu3/mtu3_dr.c
index a6b04831b20b..9b8aded3d95e 100644
--- a/drivers/usb/mtu3/mtu3_dr.c
+++ b/drivers/usb/mtu3/mtu3_dr.c
@@ -21,10 +21,8 @@ static inline struct ssusb_mtk *otg_sx_to_ssusb(struct otg_switch_mtk *otg_sx)
 
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
-- 
2.36.0



