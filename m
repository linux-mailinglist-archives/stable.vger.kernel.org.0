Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CAB411C57
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245075AbhITRIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344549AbhITRGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:06:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 474C561381;
        Mon, 20 Sep 2021 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156913;
        bh=zSrXsRy/cjyxPF3BV2aGoNTixPP6AP1kZmQh/3pEJj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeJb8hroed0PUo0xba/8K1FnwBLncFl7P5d0GFCp+biwJ39xnNUMaeKcak67KDXjQ
         /cWhSe0gxHeyg+t80ikYi3DQ4FwiZgUNlvrbHYs7fmMnwBy6CCKbF6YdKrhVYyPGok
         dfS27NGATWe92yhVRaHg55vi5kiwVVdlFm5gANO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kelly Devilliv <kelly.devilliv@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 111/175] usb: host: fotg210: fix the endpoints transactional opportunities calculation
Date:   Mon, 20 Sep 2021 18:42:40 +0200
Message-Id: <20210920163921.702598733@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kelly Devilliv <kelly.devilliv@gmail.com>

[ Upstream commit c2e898764245c852bc8ee4857613ba4f3a6d761d ]

Now that usb_endpoint_maxp() only returns the lowest
11 bits from wMaxPacketSize, we should make use of the
usb_endpoint_* helpers instead and remove the unnecessary
max_packet()/hb_mult() macro.

Signed-off-by: Kelly Devilliv <kelly.devilliv@gmail.com>
Link: https://lore.kernel.org/r/20210627125747.127646-3-kelly.devilliv@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/fotg210-hcd.c | 36 ++++++++++++++++------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 15249e664b89..725abc08550e 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -2537,11 +2537,6 @@ static unsigned qh_completions(struct fotg210_hcd *fotg210,
 	return count;
 }
 
-/* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
-#define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))
-/* ... and packet size, for any kind of endpoint descriptor */
-#define max_packet(wMaxPacketSize) ((wMaxPacketSize) & 0x07ff)
-
 /* reverse of qh_urb_transaction:  free a list of TDs.
  * used for cleanup after errors, before HC sees an URB's TDs.
  */
@@ -2627,7 +2622,7 @@ static struct list_head *qh_urb_transaction(struct fotg210_hcd *fotg210,
 		token |= (1 /* "in" */ << 8);
 	/* else it's already initted to "out" pid (0 << 8) */
 
-	maxpacket = max_packet(usb_maxpacket(urb->dev, urb->pipe, !is_input));
+	maxpacket = usb_maxpacket(urb->dev, urb->pipe, !is_input);
 
 	/*
 	 * buffer gets wrapped in one or more qtds;
@@ -2741,9 +2736,11 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 		gfp_t flags)
 {
 	struct fotg210_qh *qh = fotg210_qh_alloc(fotg210, flags);
+	struct usb_host_endpoint *ep;
 	u32 info1 = 0, info2 = 0;
 	int is_input, type;
 	int maxp = 0;
+	int mult;
 	struct usb_tt *tt = urb->dev->tt;
 	struct fotg210_qh_hw *hw;
 
@@ -2758,14 +2755,15 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 
 	is_input = usb_pipein(urb->pipe);
 	type = usb_pipetype(urb->pipe);
-	maxp = usb_maxpacket(urb->dev, urb->pipe, !is_input);
+	ep = usb_pipe_endpoint(urb->dev, urb->pipe);
+	maxp = usb_endpoint_maxp(&ep->desc);
+	mult = usb_endpoint_maxp_mult(&ep->desc);
 
 	/* 1024 byte maxpacket is a hardware ceiling.  High bandwidth
 	 * acts like up to 3KB, but is built from smaller packets.
 	 */
-	if (max_packet(maxp) > 1024) {
-		fotg210_dbg(fotg210, "bogus qh maxpacket %d\n",
-				max_packet(maxp));
+	if (maxp > 1024) {
+		fotg210_dbg(fotg210, "bogus qh maxpacket %d\n", maxp);
 		goto done;
 	}
 
@@ -2779,8 +2777,7 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 	 */
 	if (type == PIPE_INTERRUPT) {
 		qh->usecs = NS_TO_US(usb_calc_bus_time(USB_SPEED_HIGH,
-				is_input, 0,
-				hb_mult(maxp) * max_packet(maxp)));
+				is_input, 0, mult * maxp));
 		qh->start = NO_FRAME;
 
 		if (urb->dev->speed == USB_SPEED_HIGH) {
@@ -2817,7 +2814,7 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 			think_time = tt ? tt->think_time : 0;
 			qh->tt_usecs = NS_TO_US(think_time +
 					usb_calc_bus_time(urb->dev->speed,
-					is_input, 0, max_packet(maxp)));
+					is_input, 0, maxp));
 			qh->period = urb->interval;
 			if (qh->period > fotg210->periodic_size) {
 				qh->period = fotg210->periodic_size;
@@ -2880,11 +2877,11 @@ static struct fotg210_qh *qh_make(struct fotg210_hcd *fotg210, struct urb *urb,
 			 * to help them do so.  So now people expect to use
 			 * such nonconformant devices with Linux too; sigh.
 			 */
-			info1 |= max_packet(maxp) << 16;
+			info1 |= maxp << 16;
 			info2 |= (FOTG210_TUNE_MULT_HS << 30);
 		} else {		/* PIPE_INTERRUPT */
-			info1 |= max_packet(maxp) << 16;
-			info2 |= hb_mult(maxp) << 30;
+			info1 |= maxp << 16;
+			info2 |= mult << 30;
 		}
 		break;
 	default:
@@ -3954,6 +3951,7 @@ static void iso_stream_init(struct fotg210_hcd *fotg210,
 	int is_input;
 	long bandwidth;
 	unsigned multi;
+	struct usb_host_endpoint *ep;
 
 	/*
 	 * this might be a "high bandwidth" highspeed endpoint,
@@ -3961,14 +3959,14 @@ static void iso_stream_init(struct fotg210_hcd *fotg210,
 	 */
 	epnum = usb_pipeendpoint(pipe);
 	is_input = usb_pipein(pipe) ? USB_DIR_IN : 0;
-	maxp = usb_maxpacket(dev, pipe, !is_input);
+	ep = usb_pipe_endpoint(dev, pipe);
+	maxp = usb_endpoint_maxp(&ep->desc);
 	if (is_input)
 		buf1 = (1 << 11);
 	else
 		buf1 = 0;
 
-	maxp = max_packet(maxp);
-	multi = hb_mult(maxp);
+	multi = usb_endpoint_maxp_mult(&ep->desc);
 	buf1 |= maxp;
 	maxp *= multi;
 
-- 
2.30.2



