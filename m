Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76D6F7EA7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbfKKSm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:42:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729101AbfKKSm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:42:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EA0F214E0;
        Mon, 11 Nov 2019 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497745;
        bh=GGeF/A/IxlzVMrdJWGEfYUJExzFeprEI4NYDhNWrlrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeQcI/muKiuwFYI+5dg6bkXUoZwI7KtxsYEIMFGuVHr0bqrK1Hgy3lYM3Q+cKDMMx
         U9+7CCwbUVY5FD2NopK6g38NysU7xaRPpEGPHhiAU9kAYU6HVOD/ZzU3L6QuOpcKG7
         vIO399fW403zSsTrUzSb8rG/gyM2ihyvzrcYOkKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.19 046/125] can: peak_usb: fix a potential out-of-sync while decoding packets
Date:   Mon, 11 Nov 2019 19:28:05 +0100
Message-Id: <20191111181446.396985869@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit de280f403f2996679e2607384980703710576fed upstream.

When decoding a buffer received from PCAN-USB, the first timestamp read in
a packet is a 16-bit coded time base, and the next ones are an 8-bit
offset to this base, regardless of the type of packet read.

This patch corrects a potential loss of synchronization by using a
timestamp index read from the buffer, rather than an index of received
data packets, to determine on the sizeof the timestamp to be read from the
packet being decoded.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Fixes: 46be265d3388 ("can: usb: PEAK-System Technik PCAN-USB specific part")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/peak_usb/pcan_usb.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -108,7 +108,7 @@ struct pcan_usb_msg_context {
 	u8 *end;
 	u8 rec_cnt;
 	u8 rec_idx;
-	u8 rec_data_idx;
+	u8 rec_ts_idx;
 	struct net_device *netdev;
 	struct pcan_usb *pdev;
 };
@@ -555,10 +555,15 @@ static int pcan_usb_decode_status(struct
 	mc->ptr += PCAN_USB_CMD_ARGS;
 
 	if (status_len & PCAN_USB_STATUSLEN_TIMESTAMP) {
-		int err = pcan_usb_decode_ts(mc, !mc->rec_idx);
+		int err = pcan_usb_decode_ts(mc, !mc->rec_ts_idx);
 
 		if (err)
 			return err;
+
+		/* Next packet in the buffer will have a timestamp on a single
+		 * byte
+		 */
+		mc->rec_ts_idx++;
 	}
 
 	switch (f) {
@@ -640,10 +645,13 @@ static int pcan_usb_decode_data(struct p
 
 	cf->can_dlc = get_can_dlc(rec_len);
 
-	/* first data packet timestamp is a word */
-	if (pcan_usb_decode_ts(mc, !mc->rec_data_idx))
+	/* Only first packet timestamp is a word */
+	if (pcan_usb_decode_ts(mc, !mc->rec_ts_idx))
 		goto decode_failed;
 
+	/* Next packet in the buffer will have a timestamp on a single byte */
+	mc->rec_ts_idx++;
+
 	/* read data */
 	memset(cf->data, 0x0, sizeof(cf->data));
 	if (status_len & PCAN_USB_STATUSLEN_RTR) {
@@ -696,7 +704,6 @@ static int pcan_usb_decode_msg(struct pe
 		/* handle normal can frames here */
 		} else {
 			err = pcan_usb_decode_data(&mc, sl);
-			mc.rec_data_idx++;
 		}
 	}
 


