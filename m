Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9521493AC
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbfFQV0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730253AbfFQV0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:26:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB38D20657;
        Mon, 17 Jun 2019 21:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806799;
        bh=1auqWFlLgx5PxhjiP+jYgypq9mwZml76tmsvNxt+uXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doIdDaIfIHP6Nm8EfUOxns/2cZc++SQWTr13DESNRm7DZjj0RHuY/f5GoK7EdU6lF
         fkfwlcHj/9NUZx6/axQ/JZ6SET2fX4PFB1mxO5RJcE6QG3Zqpu/KxEo/XhhPWs50NF
         ZecjbGgVdMz8jAydFuLvHMZPACTNK70vLpMuOkNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 4.19 60/75] usb: dwc2: host: Fix wMaxPacketSize handling (fix webcam regression)
Date:   Mon, 17 Jun 2019 23:10:11 +0200
Message-Id: <20190617210755.231495162@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit babd183915e91a64e976b9e8ab682bb56624df76 upstream.

In commit abb621844f6a ("usb: ch9: make usb_endpoint_maxp() return
only packet size") the API to usb_endpoint_maxp() changed.  It used to
just return wMaxPacketSize but after that commit it returned
wMaxPacketSize with the high bits (the multiplier) masked off.  If you
wanted to get the multiplier it was now up to your code to call the
new usb_endpoint_maxp_mult() which was introduced in
commit 541b6fe63023 ("usb: add helper to extract bits 12:11 of
wMaxPacketSize").

Prior to the API change most host drivers were updated, but no update
was made to dwc2.  Presumably it was assumed that dwc2 was too
simplistic to use the multiplier and thus just didn't support a
certain class of USB devices.  However, it turns out that dwc2 did use
the multiplier and many devices using it were working quite nicely.
That means that many USB devices have been broken since the API
change.  One such device is a Logitech HD Pro Webcam C920.

Specifically, though dwc2 didn't directly call usb_endpoint_maxp(), it
did call usb_maxpacket() which in turn called usb_endpoint_maxp().

Let's update dwc2 to work properly with the new API.

Fixes: abb621844f6a ("usb: ch9: make usb_endpoint_maxp() return only packet size")
Cc: stable@vger.kernel.org
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/hcd.c       |   29 +++++++++++++++++------------
 drivers/usb/dwc2/hcd.h       |   20 +++++++++++---------
 drivers/usb/dwc2/hcd_intr.c  |    5 +++--
 drivers/usb/dwc2/hcd_queue.c |   10 ++++++----
 4 files changed, 37 insertions(+), 27 deletions(-)

--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -2805,7 +2805,7 @@ static int dwc2_assign_and_init_hc(struc
 	chan->dev_addr = dwc2_hcd_get_dev_addr(&urb->pipe_info);
 	chan->ep_num = dwc2_hcd_get_ep_num(&urb->pipe_info);
 	chan->speed = qh->dev_speed;
-	chan->max_packet = dwc2_max_packet(qh->maxp);
+	chan->max_packet = qh->maxp;
 
 	chan->xfer_started = 0;
 	chan->halt_status = DWC2_HC_XFER_NO_HALT_STATUS;
@@ -2883,7 +2883,7 @@ static int dwc2_assign_and_init_hc(struc
 		 * This value may be modified when the transfer is started
 		 * to reflect the actual transfer length
 		 */
-		chan->multi_count = dwc2_hb_mult(qh->maxp);
+		chan->multi_count = qh->maxp_mult;
 
 	if (hsotg->params.dma_desc_enable) {
 		chan->desc_list_addr = qh->desc_list_dma;
@@ -3995,19 +3995,21 @@ static struct dwc2_hcd_urb *dwc2_hcd_urb
 
 static void dwc2_hcd_urb_set_pipeinfo(struct dwc2_hsotg *hsotg,
 				      struct dwc2_hcd_urb *urb, u8 dev_addr,
-				      u8 ep_num, u8 ep_type, u8 ep_dir, u16 mps)
+				      u8 ep_num, u8 ep_type, u8 ep_dir,
+				      u16 maxp, u16 maxp_mult)
 {
 	if (dbg_perio() ||
 	    ep_type == USB_ENDPOINT_XFER_BULK ||
 	    ep_type == USB_ENDPOINT_XFER_CONTROL)
 		dev_vdbg(hsotg->dev,
-			 "addr=%d, ep_num=%d, ep_dir=%1x, ep_type=%1x, mps=%d\n",
-			 dev_addr, ep_num, ep_dir, ep_type, mps);
+			 "addr=%d, ep_num=%d, ep_dir=%1x, ep_type=%1x, maxp=%d (%d mult)\n",
+			 dev_addr, ep_num, ep_dir, ep_type, maxp, maxp_mult);
 	urb->pipe_info.dev_addr = dev_addr;
 	urb->pipe_info.ep_num = ep_num;
 	urb->pipe_info.pipe_type = ep_type;
 	urb->pipe_info.pipe_dir = ep_dir;
-	urb->pipe_info.mps = mps;
+	urb->pipe_info.maxp = maxp;
+	urb->pipe_info.maxp_mult = maxp_mult;
 }
 
 /*
@@ -4098,8 +4100,9 @@ void dwc2_hcd_dump_state(struct dwc2_hso
 					dwc2_hcd_is_pipe_in(&urb->pipe_info) ?
 					"IN" : "OUT");
 				dev_dbg(hsotg->dev,
-					"      Max packet size: %d\n",
-					dwc2_hcd_get_mps(&urb->pipe_info));
+					"      Max packet size: %d (%d mult)\n",
+					dwc2_hcd_get_maxp(&urb->pipe_info),
+					dwc2_hcd_get_maxp_mult(&urb->pipe_info));
 				dev_dbg(hsotg->dev,
 					"      transfer_buffer: %p\n",
 					urb->buf);
@@ -4657,8 +4660,10 @@ static void dwc2_dump_urb_info(struct us
 	}
 
 	dev_vdbg(hsotg->dev, "  Speed: %s\n", speed);
-	dev_vdbg(hsotg->dev, "  Max packet size: %d\n",
-		 usb_maxpacket(urb->dev, urb->pipe, usb_pipeout(urb->pipe)));
+	dev_vdbg(hsotg->dev, "  Max packet size: %d (%d mult)\n",
+		 usb_endpoint_maxp(&urb->ep->desc),
+		 usb_endpoint_maxp_mult(&urb->ep->desc));
+
 	dev_vdbg(hsotg->dev, "  Data buffer length: %d\n",
 		 urb->transfer_buffer_length);
 	dev_vdbg(hsotg->dev, "  Transfer buffer: %p, Transfer DMA: %08lx\n",
@@ -4741,8 +4746,8 @@ static int _dwc2_hcd_urb_enqueue(struct
 	dwc2_hcd_urb_set_pipeinfo(hsotg, dwc2_urb, usb_pipedevice(urb->pipe),
 				  usb_pipeendpoint(urb->pipe), ep_type,
 				  usb_pipein(urb->pipe),
-				  usb_maxpacket(urb->dev, urb->pipe,
-						!(usb_pipein(urb->pipe))));
+				  usb_endpoint_maxp(&ep->desc),
+				  usb_endpoint_maxp_mult(&ep->desc));
 
 	buf = urb->transfer_buffer;
 
--- a/drivers/usb/dwc2/hcd.h
+++ b/drivers/usb/dwc2/hcd.h
@@ -171,7 +171,8 @@ struct dwc2_hcd_pipe_info {
 	u8 ep_num;
 	u8 pipe_type;
 	u8 pipe_dir;
-	u16 mps;
+	u16 maxp;
+	u16 maxp_mult;
 };
 
 struct dwc2_hcd_iso_packet_desc {
@@ -264,6 +265,7 @@ struct dwc2_hs_transfer_time {
  *                       - USB_ENDPOINT_XFER_ISOC
  * @ep_is_in:           Endpoint direction
  * @maxp:               Value from wMaxPacketSize field of Endpoint Descriptor
+ * @maxp_mult:          Multiplier for maxp
  * @dev_speed:          Device speed. One of the following values:
  *                       - USB_SPEED_LOW
  *                       - USB_SPEED_FULL
@@ -340,6 +342,7 @@ struct dwc2_qh {
 	u8 ep_type;
 	u8 ep_is_in;
 	u16 maxp;
+	u16 maxp_mult;
 	u8 dev_speed;
 	u8 data_toggle;
 	u8 ping_state;
@@ -503,9 +506,14 @@ static inline u8 dwc2_hcd_get_pipe_type(
 	return pipe->pipe_type;
 }
 
-static inline u16 dwc2_hcd_get_mps(struct dwc2_hcd_pipe_info *pipe)
+static inline u16 dwc2_hcd_get_maxp(struct dwc2_hcd_pipe_info *pipe)
+{
+	return pipe->maxp;
+}
+
+static inline u16 dwc2_hcd_get_maxp_mult(struct dwc2_hcd_pipe_info *pipe)
 {
-	return pipe->mps;
+	return pipe->maxp_mult;
 }
 
 static inline u8 dwc2_hcd_get_dev_addr(struct dwc2_hcd_pipe_info *pipe)
@@ -620,12 +628,6 @@ static inline bool dbg_urb(struct urb *u
 static inline bool dbg_perio(void) { return false; }
 #endif
 
-/* High bandwidth multiplier as encoded in highspeed endpoint descriptors */
-#define dwc2_hb_mult(wmaxpacketsize) (1 + (((wmaxpacketsize) >> 11) & 0x03))
-
-/* Packet size for any kind of endpoint descriptor */
-#define dwc2_max_packet(wmaxpacketsize) ((wmaxpacketsize) & 0x07ff)
-
 /*
  * Returns true if frame1 index is greater than frame2 index. The comparison
  * is done modulo FRLISTEN_64_SIZE. This accounts for the rollover of the
--- a/drivers/usb/dwc2/hcd_intr.c
+++ b/drivers/usb/dwc2/hcd_intr.c
@@ -1617,8 +1617,9 @@ static void dwc2_hc_ahberr_intr(struct d
 
 	dev_err(hsotg->dev, "  Speed: %s\n", speed);
 
-	dev_err(hsotg->dev, "  Max packet size: %d\n",
-		dwc2_hcd_get_mps(&urb->pipe_info));
+	dev_err(hsotg->dev, "  Max packet size: %d (mult %d)\n",
+		dwc2_hcd_get_maxp(&urb->pipe_info),
+		dwc2_hcd_get_maxp_mult(&urb->pipe_info));
 	dev_err(hsotg->dev, "  Data buffer length: %d\n", urb->length);
 	dev_err(hsotg->dev, "  Transfer buffer: %p, Transfer DMA: %08lx\n",
 		urb->buf, (unsigned long)urb->dma);
--- a/drivers/usb/dwc2/hcd_queue.c
+++ b/drivers/usb/dwc2/hcd_queue.c
@@ -708,7 +708,7 @@ static void dwc2_hs_pmap_unschedule(stru
 static int dwc2_uframe_schedule_split(struct dwc2_hsotg *hsotg,
 				      struct dwc2_qh *qh)
 {
-	int bytecount = dwc2_hb_mult(qh->maxp) * dwc2_max_packet(qh->maxp);
+	int bytecount = qh->maxp_mult * qh->maxp;
 	int ls_search_slice;
 	int err = 0;
 	int host_interval_in_sched;
@@ -1332,7 +1332,7 @@ static int dwc2_check_max_xfer_size(stru
 	u32 max_channel_xfer_size;
 	int status = 0;
 
-	max_xfer_size = dwc2_max_packet(qh->maxp) * dwc2_hb_mult(qh->maxp);
+	max_xfer_size = qh->maxp * qh->maxp_mult;
 	max_channel_xfer_size = hsotg->params.max_transfer_size;
 
 	if (max_xfer_size > max_channel_xfer_size) {
@@ -1517,8 +1517,9 @@ static void dwc2_qh_init(struct dwc2_hso
 	u32 prtspd = (hprt & HPRT0_SPD_MASK) >> HPRT0_SPD_SHIFT;
 	bool do_split = (prtspd == HPRT0_SPD_HIGH_SPEED &&
 			 dev_speed != USB_SPEED_HIGH);
-	int maxp = dwc2_hcd_get_mps(&urb->pipe_info);
-	int bytecount = dwc2_hb_mult(maxp) * dwc2_max_packet(maxp);
+	int maxp = dwc2_hcd_get_maxp(&urb->pipe_info);
+	int maxp_mult = dwc2_hcd_get_maxp_mult(&urb->pipe_info);
+	int bytecount = maxp_mult * maxp;
 	char *speed, *type;
 
 	/* Initialize QH */
@@ -1531,6 +1532,7 @@ static void dwc2_qh_init(struct dwc2_hso
 
 	qh->data_toggle = DWC2_HC_PID_DATA0;
 	qh->maxp = maxp;
+	qh->maxp_mult = maxp_mult;
 	INIT_LIST_HEAD(&qh->qtd_list);
 	INIT_LIST_HEAD(&qh->qh_list_entry);
 


