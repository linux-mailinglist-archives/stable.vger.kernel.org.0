Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D955E315CB
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 22:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfEaUEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 16:04:51 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42129 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbfEaUEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 16:04:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id e6so3356395pgd.9
        for <stable@vger.kernel.org>; Fri, 31 May 2019 13:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=112Zovjtx8ZJr1t4s7LUgNI3HCAGsmSvfOjQRnyMJCU=;
        b=XxlXQ2LA/Fd9NkSesPvODwD6A3tksGsqrm9lVeOG5pHiO8te7bj9+Wr9ALiY1LHYhc
         kfp/43WLVOLMo+N8RMOwetkmI60RcS4TH5h1vGced56vFH3ZHuCo9C0hTL920OCrQE8Z
         gKTi52cWIJxbFcnl6g8BP21BCKYbdUciAUYB0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=112Zovjtx8ZJr1t4s7LUgNI3HCAGsmSvfOjQRnyMJCU=;
        b=cUma8/xpm3k7kbb88ArfAlB57MYMkAA/Dwz/4EdF3adtMg2JElqANEBqOcrBFv3dfF
         ISTFiyvAnM4zPZkIEQbyIy7gmWUwgXqMXZo4v5CFXeu0EpeSV8SHA5rNNNuiExc8ApQi
         dfx+UI8eVA0eHF4lOoJWmG5rcbdtgl47HVIZOdguNxcpefDrXkXa13zZ7GxWp338wVS2
         rGJDYDqlJp5FD+aZF0GPQbWLdUMFvmOT5wzdv5LL2S/KN3TB2MJGjlR9bxZQrKLk+ShR
         xvnEZtRP440h6OMhB6ybd/T3zTbTOmOUntJHAzy2C88wG3o0oEaNifOfdOs7/N2dobmw
         r45w==
X-Gm-Message-State: APjAAAUzDugPzW3Pm/U6AtQM3i2irgYu257N+PA8t4sOBlPFkGPbxOAd
        cVdmxV+VAF1JG6W/ITcPX3Pvng==
X-Google-Smtp-Source: APXvYqxeTGnGGkTjihI9uH7d87T5xK7nlJC61qOLzE4WGy41v83odHoZijRIrqBW0NIFX0gqq5wJVw==
X-Received: by 2002:a62:3287:: with SMTP id y129mr7161023pfy.101.1559333089720;
        Fri, 31 May 2019 13:04:49 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id z4sm6856910pfa.142.2019.05.31.13.04.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 13:04:49 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Minas Harutyunyan <hminas@synopsys.com>
Cc:     linux-rockchip@lists.infradead.org,
        Stefan Wahren <stefan.wahren@i2se.com>, tfiga@chromium.org,
        mka@chromium.org, groeck@chromium.org,
        Martin Schiller <ms@dev.tdt.de>,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: dwc2: host: Fix wMaxPacketSize handling (fix webcam regression)
Date:   Fri, 31 May 2019 13:04:12 -0700
Message-Id: <20190531200412.129429-1-dianders@chromium.org>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

 drivers/usb/dwc2/hcd.c       | 29 +++++++++++++++++------------
 drivers/usb/dwc2/hcd.h       | 20 +++++++++++---------
 drivers/usb/dwc2/hcd_intr.c  |  5 +++--
 drivers/usb/dwc2/hcd_queue.c | 10 ++++++----
 4 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index b50ec3714fd8..5c51bf5506d1 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -2608,7 +2608,7 @@ static int dwc2_assign_and_init_hc(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh)
 	chan->dev_addr = dwc2_hcd_get_dev_addr(&urb->pipe_info);
 	chan->ep_num = dwc2_hcd_get_ep_num(&urb->pipe_info);
 	chan->speed = qh->dev_speed;
-	chan->max_packet = dwc2_max_packet(qh->maxp);
+	chan->max_packet = qh->maxp;
 
 	chan->xfer_started = 0;
 	chan->halt_status = DWC2_HC_XFER_NO_HALT_STATUS;
@@ -2686,7 +2686,7 @@ static int dwc2_assign_and_init_hc(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh)
 		 * This value may be modified when the transfer is started
 		 * to reflect the actual transfer length
 		 */
-		chan->multi_count = dwc2_hb_mult(qh->maxp);
+		chan->multi_count = qh->maxp_mult;
 
 	if (hsotg->params.dma_desc_enable) {
 		chan->desc_list_addr = qh->desc_list_dma;
@@ -3806,19 +3806,21 @@ static struct dwc2_hcd_urb *dwc2_hcd_urb_alloc(struct dwc2_hsotg *hsotg,
 
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
@@ -3909,8 +3911,9 @@ void dwc2_hcd_dump_state(struct dwc2_hsotg *hsotg)
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
@@ -4510,8 +4513,10 @@ static void dwc2_dump_urb_info(struct usb_hcd *hcd, struct urb *urb,
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
@@ -4594,8 +4599,8 @@ static int _dwc2_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	dwc2_hcd_urb_set_pipeinfo(hsotg, dwc2_urb, usb_pipedevice(urb->pipe),
 				  usb_pipeendpoint(urb->pipe), ep_type,
 				  usb_pipein(urb->pipe),
-				  usb_maxpacket(urb->dev, urb->pipe,
-						!(usb_pipein(urb->pipe))));
+				  usb_endpoint_maxp(&ep->desc),
+				  usb_endpoint_maxp_mult(&ep->desc));
 
 	buf = urb->transfer_buffer;
 
diff --git a/drivers/usb/dwc2/hcd.h b/drivers/usb/dwc2/hcd.h
index c089ffa1f0a8..ce6445a06588 100644
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
@@ -503,9 +506,14 @@ static inline u8 dwc2_hcd_get_pipe_type(struct dwc2_hcd_pipe_info *pipe)
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
@@ -620,12 +628,6 @@ static inline bool dbg_urb(struct urb *urb)
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
diff --git a/drivers/usb/dwc2/hcd_intr.c b/drivers/usb/dwc2/hcd_intr.c
index 88b5dcf3aefc..a052d39b4375 100644
--- a/drivers/usb/dwc2/hcd_intr.c
+++ b/drivers/usb/dwc2/hcd_intr.c
@@ -1617,8 +1617,9 @@ static void dwc2_hc_ahberr_intr(struct dwc2_hsotg *hsotg,
 
 	dev_err(hsotg->dev, "  Speed: %s\n", speed);
 
-	dev_err(hsotg->dev, "  Max packet size: %d\n",
-		dwc2_hcd_get_mps(&urb->pipe_info));
+	dev_err(hsotg->dev, "  Max packet size: %d (mult %d)\n",
+		dwc2_hcd_get_maxp(&urb->pipe_info),
+		dwc2_hcd_get_maxp_mult(&urb->pipe_info));
 	dev_err(hsotg->dev, "  Data buffer length: %d\n", urb->length);
 	dev_err(hsotg->dev, "  Transfer buffer: %p, Transfer DMA: %08lx\n",
 		urb->buf, (unsigned long)urb->dma);
diff --git a/drivers/usb/dwc2/hcd_queue.c b/drivers/usb/dwc2/hcd_queue.c
index ea3aa640c15c..68bbac64b753 100644
--- a/drivers/usb/dwc2/hcd_queue.c
+++ b/drivers/usb/dwc2/hcd_queue.c
@@ -708,7 +708,7 @@ static void dwc2_hs_pmap_unschedule(struct dwc2_hsotg *hsotg,
 static int dwc2_uframe_schedule_split(struct dwc2_hsotg *hsotg,
 				      struct dwc2_qh *qh)
 {
-	int bytecount = dwc2_hb_mult(qh->maxp) * dwc2_max_packet(qh->maxp);
+	int bytecount = qh->maxp_mult * qh->maxp;
 	int ls_search_slice;
 	int err = 0;
 	int host_interval_in_sched;
@@ -1332,7 +1332,7 @@ static int dwc2_check_max_xfer_size(struct dwc2_hsotg *hsotg,
 	u32 max_channel_xfer_size;
 	int status = 0;
 
-	max_xfer_size = dwc2_max_packet(qh->maxp) * dwc2_hb_mult(qh->maxp);
+	max_xfer_size = qh->maxp * qh->maxp_mult;
 	max_channel_xfer_size = hsotg->params.max_transfer_size;
 
 	if (max_xfer_size > max_channel_xfer_size) {
@@ -1517,8 +1517,9 @@ static void dwc2_qh_init(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh,
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
@@ -1531,6 +1532,7 @@ static void dwc2_qh_init(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh,
 
 	qh->data_toggle = DWC2_HC_PID_DATA0;
 	qh->maxp = maxp;
+	qh->maxp_mult = maxp_mult;
 	INIT_LIST_HEAD(&qh->qtd_list);
 	INIT_LIST_HEAD(&qh->qh_list_entry);
 
-- 
2.22.0.rc1.311.g5d7573a151-goog

