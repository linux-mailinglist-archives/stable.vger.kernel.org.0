Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC91A10BB3F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbfK0VK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:10:57 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:33816 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733097AbfK0VK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 16:10:57 -0500
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0997FC045E;
        Wed, 27 Nov 2019 21:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1574889056; bh=2OBW8CI/YoTEOeVG9b243De50+PNHFFzDpISXYftPY0=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=UtaYXhhNuYGt9J4NwYQp876I0Rkd6cED4+cHpsmV0RlcgYjBM3B8/CVhNqbXe7Igd
         Ox6pF8o6z4PQn0odK1g77U56lBWrug+go8n3UeFRu/pbXAxy39P8tCHJUoWuDUs+gM
         F7ekgQoHTl97aFTaAq4gnMB+6djU9iGhoWJMgAXpZ3vD5RVjP5ZS+wgLuBSUp4LTYE
         d/VtZix2+hM9UVt1iF5pb2/fOHCUYIPd0Z5r9bpVxClC6u6vOyPJYAvvH8wY2Oj2Q1
         zlXwBYSZTY+ur73C0g3vyHxYih4gJ4lk+nm81tnelDWGJ92HuoTLikYkYBZZJQPhYP
         Y3fkmBCKxPLrw==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 8F402A005E;
        Wed, 27 Nov 2019 21:10:54 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Wed, 27 Nov 2019 13:10:54 -0800
Date:   Wed, 27 Nov 2019 13:10:54 -0800
Message-Id: <e116fe1c373b9516346b0c201fac3987db6c2551.1574888929.git.thinhn@synopsys.com>
In-Reply-To: <cover.1574888929.git.thinhn@synopsys.com>
References: <cover.1574888929.git.thinhn@synopsys.com>
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 2/2] usb: dwc3: ep0: Clear started flag on completion
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clear ep0's DWC3_EP_TRANSFER_STARTED flag if the END_TRANSFER command is
completed. Otherwise, we can't start control transfer again after
END_TRANSFER.

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
---
 drivers/usb/dwc3/ep0.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 3996b9c4ff8d..fd1b100d2927 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -1117,6 +1117,9 @@ static void dwc3_ep0_xfernotready(struct dwc3 *dwc,
 void dwc3_ep0_interrupt(struct dwc3 *dwc,
 		const struct dwc3_event_depevt *event)
 {
+	struct dwc3_ep	*dep = dwc->eps[event->endpoint_number];
+	u8		cmd;
+
 	switch (event->endpoint_event) {
 	case DWC3_DEPEVT_XFERCOMPLETE:
 		dwc3_ep0_xfer_complete(dwc, event);
@@ -1129,7 +1132,12 @@ void dwc3_ep0_interrupt(struct dwc3 *dwc,
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
-- 
2.11.0

