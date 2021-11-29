Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7931D46272B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhK2XBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbhK2W7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:59:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC8EC125CF0;
        Mon, 29 Nov 2021 10:28:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53046B815CF;
        Mon, 29 Nov 2021 18:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76835C53FC7;
        Mon, 29 Nov 2021 18:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210495;
        bh=aPq8bX4NlpgxaEms5NstHD3WVNYV94IJqQwEqYO5lrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VA9xA6cS0g5ZInBvANdP8uOYTx4eC+LwOkUZPmh2b3z82CCFLfK2Ipy3esKzrVAjx
         Wrsx7uFYJTFjVyWw4QeYkO0e8j9AcpDuANtTpuqzNKg+V3S3UeVAHFlsMXpGBHxRLR
         kp0MKyZaCQNEGDDqrFYDZAgchpejxGAfPWMFDaOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 007/121] usb: dwc3: gadget: Ignore NoStream after End Transfer
Date:   Mon, 29 Nov 2021 19:17:18 +0100
Message-Id: <20211129181711.890016345@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit d74dc3e9f58c28689cef1faccf918e06587367d3 upstream.

The End Transfer command from a stream endpoint will generate a NoStream
event, and we should ignore it. Currently we set the flag
DWC3_EP_IGNORE_NEXT_NOSTREAM to track this prior to sending the command,
and it will be cleared on the next stream event. However, a stream event
may be generated before the End Transfer command completion and
prematurely clear the flag. Fix this by setting the flag on End Transfer
completion instead.

Fixes: 140ca4cfea8a ("usb: dwc3: gadget: Handle stream transfers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/cee1253af4c3600edb878d11c9c08b040817ae23.1635203975.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3007,6 +3007,14 @@ static void dwc3_gadget_endpoint_command
 	if (cmd != DWC3_DEPCMD_ENDTRANSFER)
 		return;
 
+	/*
+	 * The END_TRANSFER command will cause the controller to generate a
+	 * NoStream Event, and it's not due to the host DP NoStream rejection.
+	 * Ignore the next NoStream event.
+	 */
+	if (dep->stream_capable)
+		dep->flags |= DWC3_EP_IGNORE_NEXT_NOSTREAM;
+
 	dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
 	dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 	dwc3_gadget_ep_cleanup_cancelled_requests(dep);
@@ -3229,14 +3237,6 @@ static void dwc3_stop_active_transfer(st
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
-	/*
-	 * The END_TRANSFER command will cause the controller to generate a
-	 * NoStream Event, and it's not due to the host DP NoStream rejection.
-	 * Ignore the next NoStream event.
-	 */
-	if (dep->stream_capable)
-		dep->flags |= DWC3_EP_IGNORE_NEXT_NOSTREAM;
-
 	if (!interrupt)
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 	else


