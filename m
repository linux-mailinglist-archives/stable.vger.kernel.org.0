Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36421451E06
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349145AbhKPAew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344466AbhKOTYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D60006367C;
        Mon, 15 Nov 2021 18:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002676;
        bh=4vS9lJZo6T1JjKPgPYQwQ9UrRKHjDR7YGliKSPFknJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJzBKRFWICXBhyJlcR32cOIDz/81BTJc8GNKjQAvDKDUzWbfK6O/YxEqSkhScKKLl
         qIGggZ1NGvnO9WrlDfZijVhHTCL+fVP7gyXXuborcytStxRHKtsuZAS0NgXU4VDbua
         W/mF0CzyfhofMJuj8VMqSJb7MOFRE3oQ2mouUM58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jack Pham <jackp@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 656/917] usb: dwc3: gadget: Skip resizing EPs TX FIFO if already resized
Date:   Mon, 15 Nov 2021 18:02:31 +0100
Message-Id: <20211115165451.113067814@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

[ Upstream commit 876a75cb520f5869533a30a6ca01545ec817b7a0 ]

Some functions may dynamically enable and disable their endpoints
regularly throughout their operation, particularly when Set Interface
is employed to switch between Alternate Settings.  For instance the
UAC2 function has its respective endpoints for playback & capture
associated with AltSetting 1, in which case those endpoints would not
get enabled until the host activates the AltSetting.  And they
conversely become disabled when the interfaces' AltSetting 0 is
chosen.

With the DWC3 FIFO resizing algorithm recently added, every
usb_ep_enable() call results in a call to resize that EP's TXFIFO,
but if the same endpoint is enabled again and again, this incorrectly
leads to FIFO RAM allocation exhaustion as the mechanism did not
account for the possibility that endpoints can be re-enabled many
times.

Example log splat:

	dwc3 a600000.dwc3: Fifosize(3717) > RAM size(3462) ep3in depth:217973127
	configfs-gadget gadget: u_audio_start_capture:521 Error!
	dwc3 a600000.dwc3: request 000000000be13e18 was not queued to ep3in

Add another bit DWC3_EP_TXFIFO_RESIZED to dep->flags to keep track of
whether an EP had already been resized in the current configuration.
If so, bail out of dwc3_gadget_resize_tx_fifos() to avoid the
calculation error resulting from accumulating the EP's FIFO depth
repeatedly.  This flag is retained across multiple ep_disable() and
ep_enable() calls and is cleared when GTXFIFOSIZn is reset in
dwc3_gadget_clear_tx_fifos() upon receiving the next Set Config.

Fixes: 9f607a309fbe9 ("usb: dwc3: Resize TX FIFOs to meet EP bursting requirements")
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20211021180129.27938-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.h   | 1 +
 drivers/usb/dwc3/gadget.c | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 5612bfdf37da9..0c100901a7845 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -723,6 +723,7 @@ struct dwc3_ep {
 #define DWC3_EP_FORCE_RESTART_STREAM	BIT(9)
 #define DWC3_EP_FIRST_STREAM_PRIMED	BIT(10)
 #define DWC3_EP_PENDING_CLEAR_STALL	BIT(11)
+#define DWC3_EP_TXFIFO_RESIZED		BIT(12)
 
 	/* This last one is specific to EP0 */
 #define DWC3_EP0_DIR_IN		BIT(31)
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 4519d06c9ca2b..ed97e47d32613 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -702,6 +702,7 @@ void dwc3_gadget_clear_tx_fifos(struct dwc3 *dwc)
 				   DWC31_GTXFIFOSIZ_TXFRAMNUM;
 
 		dwc3_writel(dwc->regs, DWC3_GTXFIFOSIZ(num >> 1), size);
+		dep->flags &= ~DWC3_EP_TXFIFO_RESIZED;
 	}
 	dwc->num_ep_resized = 0;
 }
@@ -747,6 +748,10 @@ static int dwc3_gadget_resize_tx_fifos(struct dwc3_ep *dep)
 	if (!usb_endpoint_dir_in(dep->endpoint.desc) || dep->number <= 1)
 		return 0;
 
+	/* bail if already resized */
+	if (dep->flags & DWC3_EP_TXFIFO_RESIZED)
+		return 0;
+
 	ram1_depth = DWC3_RAM1_DEPTH(dwc->hwparams.hwparams7);
 
 	if ((dep->endpoint.maxburst > 1 &&
@@ -807,6 +812,7 @@ static int dwc3_gadget_resize_tx_fifos(struct dwc3_ep *dep)
 	}
 
 	dwc3_writel(dwc->regs, DWC3_GTXFIFOSIZ(dep->number >> 1), fifo_size);
+	dep->flags |= DWC3_EP_TXFIFO_RESIZED;
 	dwc->num_ep_resized++;
 
 	return 0;
@@ -995,7 +1001,7 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	dep->stream_capable = false;
 	dep->type = 0;
-	dep->flags = 0;
+	dep->flags &= DWC3_EP_TXFIFO_RESIZED;
 
 	return 0;
 }
-- 
2.33.0



