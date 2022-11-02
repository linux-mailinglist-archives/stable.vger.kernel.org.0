Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526AF6157DE
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiKBCkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiKBCkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:40:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E591412A97
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91294B82071
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D157C433D7;
        Wed,  2 Nov 2022 02:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356829;
        bh=BXzkTdTl7AOnCfWFFgc/RoC1rzosCR+GtPQ8iJBHS5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKdDgZs8k8dqxuE0LGx4FrcqyLvXT8RdYUVXt7YM2wKVPmnsMyJulMVV9RxmJoliR
         UjRvPqVO1xOB6OD7MkIKAvV4SWVifpNHXcQfNmyZdtiBVCAI63pgwYAyhXyAnh3XTQ
         hMzPhKLaTYFGNMWNfYZH8/EycwCs81wUK3cYNPtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.0 028/240] usb: dwc3: gadget: Dont delay End Transfer on delayed_status
Date:   Wed,  2 Nov 2022 03:30:03 +0100
Message-Id: <20221102022112.040273441@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 drivers/usb/dwc3/gadget.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1683,6 +1683,16 @@ static int __dwc3_stop_active_transfer(s
 	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
 	memset(&params, 0, sizeof(params));
 	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
+	/*
+	 * If the End Transfer command was timed out while the device is
+	 * not in SETUP phase, it's possible that an incoming Setup packet
+	 * may prevent the command's completion. Let's retry when the
+	 * ep0state returns to EP0_SETUP_PHASE.
+	 */
+	if (ret == -ETIMEDOUT && dep->dwc->ep0state != EP0_SETUP_PHASE) {
+		dep->flags |= DWC3_EP_DELAY_STOP;
+		return 0;
+	}
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
@@ -3702,7 +3712,7 @@ void dwc3_stop_active_transfer(struct dw
 	 * timeout. Delay issuing the End Transfer command until the Setup TRB is
 	 * prepared.
 	 */
-	if (dwc->ep0state != EP0_SETUP_PHASE) {
+	if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status) {
 		dep->flags |= DWC3_EP_DELAY_STOP;
 		return;
 	}


