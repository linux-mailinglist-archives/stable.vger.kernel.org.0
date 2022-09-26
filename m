Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0D25EA283
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiIZLJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237411AbiIZLII (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:08:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7AA5FF56;
        Mon, 26 Sep 2022 03:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40D60B80942;
        Mon, 26 Sep 2022 10:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E8CC433D6;
        Mon, 26 Sep 2022 10:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188467;
        bh=N3t1Fk/3q7GjP5+7SHbkjr93tAC2v25ZVbxLpcJQ0sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBIk/4AkRF3XVB3Nf/5q7zpebIPiX3VQed/iepNI0g9IPF2yEi5o4DHER3dOQ9l/D
         jl9ZoX3JGk6ZLP0zg+Opoe0quQ/XLc+j1J7azRjkHMDFiU3ig7tjDy5JCnrinKwRvm
         dkzMkwbW4Y83BCC1kGVs7WIvTqRqi4O5jU1X68Ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/148] usb: dwc3: gadget: Avoid starting DWC3 gadget during UDC unbind
Date:   Mon, 26 Sep 2022 12:10:39 +0200
Message-Id: <20220926100756.259989964@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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
index fd5d42ec5350..dbae57725f52 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1028,6 +1028,7 @@ struct dwc3_scratchpad_array {
  * @tx_fifo_resize_max_num: max number of fifos allocated during txfifo resize
  * @hsphy_interface: "utmi" or "ulpi"
  * @connected: true when we're connected to a host, false otherwise
+ * @softconnect: true when gadget connect is called, false when disconnect runs
  * @delayed_status: true when gadget driver asks for delayed status
  * @ep0_bounced: true when we used bounce buffer
  * @ep0_expect_in: true when we expect a DATA IN transfer
@@ -1247,6 +1248,7 @@ struct dwc3 {
 	const char		*hsphy_interface;
 
 	unsigned		connected:1;
+	unsigned		softconnect:1;
 	unsigned		delayed_status:1;
 	unsigned		ep0_bounced:1;
 	unsigned		ep0_expect_in:1;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 322754a7f91c..5f9a0ab09f4b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2442,7 +2442,7 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 	int			ret;
 
 	is_on = !!is_on;
-
+	dwc->softconnect = is_on;
 	/*
 	 * Per databook, when we want to stop the gadget, if a control transfer
 	 * is still in process, complete it and get the core into setup phase.
@@ -4421,7 +4421,7 @@ int dwc3_gadget_resume(struct dwc3 *dwc)
 {
 	int			ret;
 
-	if (!dwc->gadget_driver)
+	if (!dwc->gadget_driver || !dwc->softconnect)
 		return 0;
 
 	ret = __dwc3_gadget_start(dwc);
-- 
2.35.1



