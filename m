Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96B2548F71
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380279AbiFMN6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380732AbiFMNzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:55:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F02C81486;
        Mon, 13 Jun 2022 04:35:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7FB84CE1230;
        Mon, 13 Jun 2022 11:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D07C34114;
        Mon, 13 Jun 2022 11:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120135;
        bh=IBEvw16s7AhnUjLXu1kcyc7no2h3G3sNQlwhqQ+fxto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkPFMvVuUlCBh/11sanA9CkiyesSXBxzqaGcoxR86YZYyCd0+BRmVD2frDYkEIW9c
         woJ26t+KnBW83Uj8E5QG1D/r6kKv6dgdPp0ZtErNYyBspT0M9lnmLrCVpyO1c5gZcF
         LPAqR4cSLIPBmbHh0XO9o54SDLpv9V/1VLhAZ9CY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 243/339] usb: dwc3: gadget: Only End Transfer for ep0 data phase
Date:   Mon, 13 Jun 2022 12:11:08 +0200
Message-Id: <20220613094934.024486970@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6936d8ce8981..bf2eaa09d73c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3685,6 +3685,17 @@ static void dwc3_reset_gadget(struct dwc3 *dwc)
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



