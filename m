Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9658063B014
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiK1RsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbiK1RrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:47:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E17F2DA97;
        Mon, 28 Nov 2022 09:41:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1637A612C4;
        Mon, 28 Nov 2022 17:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07DCC433B5;
        Mon, 28 Nov 2022 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657315;
        bh=+ONobpLrDw5TROlXUBEEikrRoAPbBafYwvdqkA9idtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tx5diBUSdVOb+KRZFsvHaAJNeGM6lsoguu7HI3og7z0BcqKo6Cc1BgfuHo7prcoHC
         tEDwkK6XiCfxDKgB6GDrwdCEkIu66MVQIEMHl+dh1MIwEkGEZSZkD/vrOuLaewJG5k
         f7LnmYzwDkXdDx4kZia/LGw+wP1V2JXBrgCcy5wV1QJ63Bix2rA2K3aAarz+3+4Ke6
         Hu00sXSie0hq1R4LcFitTXf2KpgxjyD2jQjvkmHKKMF+6RUGBv6XHWXHsdkPAVZjzE
         9zD5pktZgJ83eWcZkVgh/71qfoD1tI4j1zq/gMfjGBgNoSmJi51mEseoYL9/JPZDX7
         dvHzD7TlR2hIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/19] usb: dwc3: gadget: Disable GUSB2PHYCFG.SUSPHY for End Transfer
Date:   Mon, 28 Nov 2022 12:41:17 -0500
Message-Id: <20221128174120.1442235-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174120.1442235-1-sashal@kernel.org>
References: <20221128174120.1442235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 3aa07f72894d209fcf922ad686cbb28cf005aaad ]

If there's a disconnection while operating in eSS, there may be a delay
in VBUS drop response from the connector. In that case, the internal
link state may drop to operate in usb2 speed while the controller thinks
the VBUS is still high. The driver must make sure to disable
GUSB2PHYCFG.SUSPHY when sending endpoint command while in usb2 speed.
The End Transfer command may be called, and only that command needs to
go through at this point. Let's keep it simple and unconditionally
disable GUSB2PHYCFG.SUSPHY whenever we issue the command.

This scenario is not seen in real hardware. In a rare case, our
prototype type-c controller/interface may have a slow response
triggerring this issue.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/5651117207803c26e2f22ddf4e5ce9e865dcf7c7.1668045468.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 347ba7e4bd81..d48c52c21145 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -291,7 +291,8 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned int cmd,
 	 *
 	 * DWC_usb3 3.30a and DWC_usb31 1.90a programming guide section 3.2.2
 	 */
-	if (dwc->gadget->speed <= USB_SPEED_HIGH) {
+	if (dwc->gadget->speed <= USB_SPEED_HIGH ||
+	    DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_ENDTRANSFER) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
 		if (unlikely(reg & DWC3_GUSB2PHYCFG_SUSPHY)) {
 			saved_config |= DWC3_GUSB2PHYCFG_SUSPHY;
-- 
2.35.1

