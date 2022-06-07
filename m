Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1002C540A45
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244879AbiFGSTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352082AbiFGSQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB5D133271;
        Tue,  7 Jun 2022 10:50:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B2EE6159C;
        Tue,  7 Jun 2022 17:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3F7C341C5;
        Tue,  7 Jun 2022 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624224;
        bh=RpktX0h64ke1ndML5ud9B+DvdtiuU/h/XzPH811aUtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F57r+Lf6hvh7XuHvgOXZ3nMYdr4NUgQvAOT9nzpawF0nEqwordjWlu1+e/GIs+hmU
         Ylm+zfhB8SEShYYDmWlDs1DDIW31mfbDhAK4hYiLLDrXHpTbJwxe4ALdwyBlMPkJXb
         Lm+LPAHHk7y4oZbRXPXylRuUkonIHzhD/4SdKNHzOntt6/z9k3HC178I+8Q9DBEnRd
         05eZX0WQPgiD2OngZqV/mN1igqkG2RL2gST7URTK024uIMrn9tnkpi9yGDUucYqUK7
         8Nho4OFx38QhW+qr0/vpDCLW1MhXTw/R/lemM41McUY3uhBjRDvvkcHdFRo30BheHh
         4Yk4/660NXqJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 21/68] usb: dwc3: gadget: Only End Transfer for ep0 data phase
Date:   Tue,  7 Jun 2022 13:47:47 -0400
Message-Id: <20220607174846.477972-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit ace17b6ee4f92ab0375d12a1b42494f8590a96b6 ]

The driver shouldn't be able to issue End Transfer to the control
endpoint at anytime. Typically we should only do so in error cases such
as invalid/unexpected direction of Data Phase as described in the
control transfer flow of the programming guide. It _may_ end started
data phase during controller deinitialization from soft disconnect or
driver removal. However, that should not happen because the driver
should be maintained in EP0_SETUP_PHASE during driver tear-down. On
soft-connect, the controller should be reset from a soft-reset and there
should be no issue starting the control endpoint.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3c6643678863a26702e4115e9e19d7d94a30d49c.1650593829.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 0b9c2493844a..05856bcaf2f7 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3673,6 +3673,17 @@ static void dwc3_reset_gadget(struct dwc3 *dwc)
 void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	bool interrupt)
 {
+	struct dwc3 *dwc = dep->dwc;
+
+	/*
+	 * Only issue End Transfer command to the control endpoint of a started
+	 * Data Phase. Typically we should only do so in error cases such as
+	 * invalid/unexpected direction as described in the control transfer
+	 * flow of the programming guide.
+	 */
+	if (dep->number <= 1 && dwc->ep0state != EP0_DATA_PHASE)
+		return;
+
 	if (!(dep->flags & DWC3_EP_TRANSFER_STARTED) ||
 	    (dep->flags & DWC3_EP_DELAY_STOP) ||
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
-- 
2.35.1

