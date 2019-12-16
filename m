Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6198B1217F9
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfLPSkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729144AbfLPSCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:02:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9FBE2072D;
        Mon, 16 Dec 2019 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519360;
        bh=CJTseLSNVffxAdzFxRFh4J7A9zO0vfoNVnyFMxsRKJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPLLqAoU4kInFOkmON6SuFmsdPkorFNtzch92p1tGoE7w5grZoFRRW7wkvrtvpo+e
         K1h7+9jW7fYTsbZMCFbT0IKdD6/iKrLHZWhc5Sq4NAMME48Q5FZOWa/EfQev6QkFmn
         ZKCA25XXqKLy/XaoyzJDIc/AjglNl8o+IfAX5MmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.19 034/140] usb: dwc3: ep0: Clear started flag on completion
Date:   Mon, 16 Dec 2019 18:48:22 +0100
Message-Id: <20191216174758.476591105@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 2d7b78f59e020b07fc6338eefe286f54ee2d6773 upstream.

Clear ep0's DWC3_EP_TRANSFER_STARTED flag if the END_TRANSFER command is
completed. Otherwise, we can't start control transfer again after
END_TRANSFER.

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/ep0.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -1110,6 +1110,9 @@ static void dwc3_ep0_xfernotready(struct
 void dwc3_ep0_interrupt(struct dwc3 *dwc,
 		const struct dwc3_event_depevt *event)
 {
+	struct dwc3_ep	*dep = dwc->eps[event->endpoint_number];
+	u8		cmd;
+
 	switch (event->endpoint_event) {
 	case DWC3_DEPEVT_XFERCOMPLETE:
 		dwc3_ep0_xfer_complete(dwc, event);
@@ -1122,7 +1125,12 @@ void dwc3_ep0_interrupt(struct dwc3 *dwc
 	case DWC3_DEPEVT_XFERINPROGRESS:
 	case DWC3_DEPEVT_RXTXFIFOEVT:
 	case DWC3_DEPEVT_STREAMEVT:
+		break;
 	case DWC3_DEPEVT_EPCMDCMPLT:
+		cmd = DEPEVT_PARAMETER_CMD(event->parameters);
+
+		if (cmd == DWC3_DEPCMD_ENDTRANSFER)
+			dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 		break;
 	}
 }


