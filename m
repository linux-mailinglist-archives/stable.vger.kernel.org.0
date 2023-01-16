Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE76166CDC0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbjAPRjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbjAPRjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:39:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC80E4C0F4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C01CB81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F18C433EF;
        Mon, 16 Jan 2023 17:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889310;
        bh=NG1V1OjiPa8ivM7ZmaAqN/9we+H8Ja4W5HsutwAI8BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfF35Yc/WTDqlWsf4ekXJfpBLTdr+oQf0HfuA3fzjqZWQfpas1TNjHQ4VLFjU4LS6
         qyBM7iQz2sfZcMZr8xdmoldp949mDNNVE1DIYjfsEIDjfkENdzp0yIrXg4BdRxOa6+
         lcI2RGvHDZBog+sob1SV5UMkl3QRZRxk6vOMRMhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 337/338] nfc: pn533: Wait for out_urbs completion in pn533_usb_send_frame()
Date:   Mon, 16 Jan 2023 16:53:30 +0100
Message-Id: <20230116154835.779539923@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Minsuk Kang <linuxlovemin@yonsei.ac.kr>

[ Upstream commit 9dab880d675b9d0dd56c6428e4e8352a3339371d ]

Fix a use-after-free that occurs in hcd when in_urb sent from
pn533_usb_send_frame() is completed earlier than out_urb. Its callback
frees the skb data in pn533_send_async_complete() that is used as a
transfer buffer of out_urb. Wait before sending in_urb until the
callback of out_urb is called. To modify the callback of out_urb alone,
separate the complete function of out_urb and ack_urb.

Found by a modified version of syzkaller.

BUG: KASAN: use-after-free in dummy_timer
Call Trace:
 memcpy (mm/kasan/shadow.c:65)
 dummy_perform_transfer (drivers/usb/gadget/udc/dummy_hcd.c:1352)
 transfer (drivers/usb/gadget/udc/dummy_hcd.c:1453)
 dummy_timer (drivers/usb/gadget/udc/dummy_hcd.c:1972)
 arch_static_branch (arch/x86/include/asm/jump_label.h:27)
 static_key_false (include/linux/jump_label.h:207)
 timer_expire_exit (include/trace/events/timer.h:127)
 call_timer_fn (kernel/time/timer.c:1475)
 expire_timers (kernel/time/timer.c:1519)
 __run_timers (kernel/time/timer.c:1790)
 run_timer_softirq (kernel/time/timer.c:1803)

Fixes: c46ee38620a2 ("NFC: pn533: add NXP pn533 nfc device driver")
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/usb.c |   44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -165,10 +165,17 @@ static int pn533_usb_send_ack(struct pn5
 	return usb_submit_urb(phy->ack_urb, flags);
 }
 
+struct pn533_out_arg {
+	struct pn533_usb_phy *phy;
+	struct completion done;
+};
+
 static int pn533_usb_send_frame(struct pn533 *dev,
 				struct sk_buff *out)
 {
 	struct pn533_usb_phy *phy = dev->phy;
+	struct pn533_out_arg arg;
+	void *cntx;
 	int rc;
 
 	if (phy->priv == NULL)
@@ -180,10 +187,17 @@ static int pn533_usb_send_frame(struct p
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
 
+	init_completion(&arg.done);
+	cntx = phy->out_urb->context;
+	phy->out_urb->context = &arg;
+
 	rc = usb_submit_urb(phy->out_urb, GFP_KERNEL);
 	if (rc)
 		return rc;
 
+	wait_for_completion(&arg.done);
+	phy->out_urb->context = cntx;
+
 	if (dev->protocol_type == PN533_PROTO_REQ_RESP) {
 		/* request for response for sent packet directly */
 		rc = pn533_submit_urb_for_response(phy, GFP_KERNEL);
@@ -424,7 +438,31 @@ static int pn533_acr122_poweron_rdr(stru
 	return arg.rc;
 }
 
-static void pn533_send_complete(struct urb *urb)
+static void pn533_out_complete(struct urb *urb)
+{
+	struct pn533_out_arg *arg = urb->context;
+	struct pn533_usb_phy *phy = arg->phy;
+
+	switch (urb->status) {
+	case 0:
+		break; /* success */
+	case -ECONNRESET:
+	case -ENOENT:
+		dev_dbg(&phy->udev->dev,
+			"The urb has been stopped (status %d)\n",
+			urb->status);
+		break;
+	case -ESHUTDOWN:
+	default:
+		nfc_err(&phy->udev->dev,
+			"Urb failure (status %d)\n",
+			urb->status);
+	}
+
+	complete(&arg->done);
+}
+
+static void pn533_ack_complete(struct urb *urb)
 {
 	struct pn533_usb_phy *phy = urb->context;
 
@@ -512,10 +550,10 @@ static int pn533_usb_probe(struct usb_in
 
 	usb_fill_bulk_urb(phy->out_urb, phy->udev,
 			  usb_sndbulkpipe(phy->udev, out_endpoint),
-			  NULL, 0, pn533_send_complete, phy);
+			  NULL, 0, pn533_out_complete, phy);
 	usb_fill_bulk_urb(phy->ack_urb, phy->udev,
 			  usb_sndbulkpipe(phy->udev, out_endpoint),
-			  NULL, 0, pn533_send_complete, phy);
+			  NULL, 0, pn533_ack_complete, phy);
 
 	switch (id->driver_info) {
 	case PN533_DEVICE_STD:


