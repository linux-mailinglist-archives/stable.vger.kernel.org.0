Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59D6621502
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbiKHOH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbiKHOHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:07:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFF8686AD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:07:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC9D0615C0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D50C433D6;
        Tue,  8 Nov 2022 14:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916434;
        bh=cd+tMQ4IWxAT1i/b7JAxR5h3N/jAiWSboMJC0z6jfjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHatN6BczeNkDSkEm+e0HGNHsKg5KLyocLEel0KIVHFglBK+N6zX9/N4TCOyd1h1v
         G1vtHTjvc/7noWiwsjbAF/M8I4SK3PLQjVqBayIYZGpigubucGHbbm0UJ3DUW1qPk8
         1CX+UH/C2n5DAuDnKohz1TN6RBiVwOnY/CsO4Xew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 002/197] usb: dwc3: gadget: Dont delay End Transfer on delayed_status
Date:   Tue,  8 Nov 2022 14:37:20 +0100
Message-Id: <20221108133354.886962066@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit 4db0fbb601361767144e712beb96704b966339f5 upstream.

The gadget driver may wait on the request completion when it sets the
USB_GADGET_DELAYED_STATUS. Make sure that the End Transfer command can
go through if the dwc->delayed_status is set so that the request can
complete. When the delayed_status is set, the Setup packet is already
processed, and the next phase should be either Data or Status. It's
unlikely that the host would cancel the control transfer and send a new
Setup packet during End Transfer command. But if that's the case, we can
try again when ep0state returns to EP0_SETUP_PHASE.

Fixes: e1ee843488d5 ("usb: dwc3: gadget: Force sending delayed status during soft disconnect")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3f9f59e5d74efcbaee444cf4b30ef639cc7b124e.1666146954.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 530ef3232418..0ed9826a4c47 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3712,7 +3712,7 @@ void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	 * timeout. Delay issuing the End Transfer command until the Setup TRB is
 	 * prepared.
 	 */
-	if (dwc->ep0state != EP0_SETUP_PHASE) {
+	if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status) {
 		dep->flags |= DWC3_EP_DELAY_STOP;
 		return;
 	}
-- 
2.35.1



