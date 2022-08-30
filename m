Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347915A64D8
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 15:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiH3Nd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 09:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiH3Ndz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 09:33:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6145D6B9B
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 06:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C162B81BF1
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 13:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90151C4347C;
        Tue, 30 Aug 2022 13:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661866432;
        bh=TRMXO79xHp8Akg7bczBglaL6RinWVd0WAsdbvdMSHlY=;
        h=Subject:To:From:Date:From;
        b=1zruejkM5xdHJRy+iVRj2HqhRGKd2A4VHjY/KFgbff0pD06yqHkxP6a9/P7TIElkU
         hUMnOTVI4flYIUo2QON/Ny3CuD/AphLUNLK/HFvHZqJY1SE2aPmbv90nNnFLcMcRou
         3X1szFWBEomcl+44Akt42f6VrTRa+EZ8Vf1PwctU=
Subject: patch "usb: cdns3: fix issue with rearming ISO OUT endpoint" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 30 Aug 2022 15:33:41 +0200
Message-ID: <166186642141172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: fix issue with rearming ISO OUT endpoint

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b46a6b09fa056042a302b181a1941f0056944603 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Thu, 25 Aug 2022 08:21:37 +0200
Subject: usb: cdns3: fix issue with rearming ISO OUT endpoint

ISO OUT endpoint is enabled during queuing first usb request
in transfer ring and disabled when TRBERR is reported by controller.
After TRBERR and before next transfer added to TR driver must again
reenable endpoint but does not.
To solve this issue during processing TRBERR event driver must
set the flag EP_UPDATE_EP_TRBADDR in priv_ep->flags field.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20220825062137.5766-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 4f11c311acaf..5adcb349718c 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1691,6 +1691,7 @@ static int cdns3_check_ep_interrupt_proceed(struct cdns3_endpoint *priv_ep)
 				ep_cfg &= ~EP_CFG_ENABLE;
 				writel(ep_cfg, &priv_dev->regs->ep_cfg);
 				priv_ep->flags &= ~EP_QUIRK_ISO_OUT_EN;
+				priv_ep->flags |= EP_UPDATE_EP_TRBADDR;
 			}
 			cdns3_transfer_completed(priv_dev, priv_ep);
 		} else if (!(priv_ep->flags & EP_STALLED) &&
-- 
2.37.2


