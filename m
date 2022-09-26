Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8525EA19F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbiIZKwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbiIZKux (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:50:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918EA5925E;
        Mon, 26 Sep 2022 03:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 447A0609FB;
        Mon, 26 Sep 2022 10:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503F0C433C1;
        Mon, 26 Sep 2022 10:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188050;
        bh=LdqUkDwiVByAfptd8Zpgf3tQs+tvoNgQfJBpzOXPdCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1oi7HUxhHnbmwWCqJONiwb7KEqiXfDWFstk3Up2d3er0lwy3H9tXLLwQFkMWokwR
         a8xSirOi7/vJiUPLi87oPvW96n4w/MVGvi7YmHNe7RMoo9oHCAL4+fmeZru+5/Ninh
         fX8+ux/tCUMwtH5ECU+wCPeZLm0sNRwq+stPFTfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/141] usb: dwc3: gadget: Avoid starting DWC3 gadget during UDC unbind
Date:   Mon, 26 Sep 2022 12:10:33 +0200
Message-Id: <20220926100754.882378786@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Cheng <wcheng@codeaurora.org>

[ Upstream commit 8217f07a50236779880f13e87f99224cd9117f83 ]

There is a race present where the DWC3 runtime resume runs in parallel
to the UDC unbind sequence.  This will eventually lead to a possible
scenario where we are enabling the run/stop bit, without a valid
composition defined.

Thread#1 (handling UDC unbind):
usb_gadget_remove_driver()
-->usb_gadget_disconnect()
  -->dwc3_gadget_pullup(0)
--> continue UDC unbind sequence
-->Thread#2 is running in parallel here

Thread#2 (handing next cable connect)
__dwc3_set_mode()
  -->pm_runtime_get_sync()
    -->dwc3_gadget_resume()
      -->dwc->gadget_driver is NOT NULL yet
      -->dwc3_gadget_run_stop(1)
      --> _dwc3gadget_start()
...

Fix this by tracking the pullup disable routine, and avoiding resuming
of the DWC3 gadget.  Once the UDC is re-binded, that will trigger the
pullup enable routine, which would handle enabling the DWC3 gadget.

Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/20210917021852.2037-1-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 040f2dbd2010 ("usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.h   | 2 ++
 drivers/usb/dwc3/gadget.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 79e1b82e5e05..1cb1601a6d98 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1010,6 +1010,7 @@ struct dwc3_scratchpad_array {
  * @tx_max_burst_prd: max periodic ESS transmit burst size
  * @hsphy_interface: "utmi" or "ulpi"
  * @connected: true when we're connected to a host, false otherwise
+ * @softconnect: true when gadget connect is called, false when disconnect runs
  * @delayed_status: true when gadget driver asks for delayed status
  * @ep0_bounced: true when we used bounce buffer
  * @ep0_expect_in: true when we expect a DATA IN transfer
@@ -1218,6 +1219,7 @@ struct dwc3 {
 	const char		*hsphy_interface;
 
 	unsigned		connected:1;
+	unsigned		softconnect:1;
 	unsigned		delayed_status:1;
 	unsigned		ep0_bounced:1;
 	unsigned		ep0_expect_in:1;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index a2a10c05ef3f..85a0159f12ec 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2127,7 +2127,7 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 	int			ret;
 
 	is_on = !!is_on;
-
+	dwc->softconnect = is_on;
 	/*
 	 * Per databook, when we want to stop the gadget, if a control transfer
 	 * is still in process, complete it and get the core into setup phase.
@@ -4048,7 +4048,7 @@ int dwc3_gadget_resume(struct dwc3 *dwc)
 {
 	int			ret;
 
-	if (!dwc->gadget_driver)
+	if (!dwc->gadget_driver || !dwc->softconnect)
 		return 0;
 
 	ret = __dwc3_gadget_start(dwc);
-- 
2.35.1



