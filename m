Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF556648F4
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238969AbjAJSQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238877AbjAJSP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:15:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E15DBE20
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:14:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 196C76184D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08299C433EF;
        Tue, 10 Jan 2023 18:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374450;
        bh=It2lpO+vmP57BtC0O3umVks7IOxY/Vn6pKoBK7nykgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCN1ubDPKMftNqlPHQ6sl84DJeR+vm3/V5SJaYqJg5Ua08SpSnzgW1cJdjX55vf4C
         Y5Se7CJALOcsXpTa3RCgutvdfatmDO44rBJA5NrLLrWQ6g/heXXbO1nDilTWifk41o
         yR5pOszb26/IgCYLIuSflUI9TwkxfDiSnCcHuPf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 005/159] usb: dwc3: gadget: Ignore End Transfer delay on teardown
Date:   Tue, 10 Jan 2023 19:02:33 +0100
Message-Id: <20230110180018.471278155@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

commit c4e3ef5685393c5051b52cf1e94b8891d49793ab upstream.

If we delay sending End Transfer for Setup TRB to be prepared, we need
to check if the End Transfer was in preparation for a driver
teardown/soft-disconnect. In those cases, just send the End Transfer
command without delay.

In the case of soft-disconnect, there's a very small chance the command
may not go through immediately. But should it happen, the Setup TRB will
be prepared during the polling of the controller halted state, allowing
the command to go through then.

In the case of disabling endpoint due to reconfiguration (e.g.
set_interface(alt-setting) or usb reset), then it's driven by the host.
Typically the host wouldn't immediately cancel the control request and
send another control transfer to trigger the End Transfer command
timeout.

Fixes: 4db0fbb60136 ("usb: dwc3: gadget: Don't delay End Transfer on delayed_status")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/f1617a323e190b9cc408fb8b65456e32b5814113.1670546756.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1717,6 +1717,7 @@ static int __dwc3_stop_active_transfer(s
 	else if (!ret)
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
 
+	dep->flags &= ~DWC3_EP_DELAY_STOP;
 	return ret;
 }
 
@@ -3722,8 +3723,10 @@ void dwc3_stop_active_transfer(struct dw
 	if (dep->number <= 1 && dwc->ep0state != EP0_DATA_PHASE)
 		return;
 
+	if (interrupt && (dep->flags & DWC3_EP_DELAY_STOP))
+		return;
+
 	if (!(dep->flags & DWC3_EP_TRANSFER_STARTED) ||
-	    (dep->flags & DWC3_EP_DELAY_STOP) ||
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
 		return;
 


