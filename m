Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F16141AF
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 20:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfEESBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 14:01:37 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43840 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbfEESBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 14:01:37 -0400
Received: by mail-ed1-f67.google.com with SMTP id w33so10358185edb.10
        for <stable@vger.kernel.org>; Sun, 05 May 2019 11:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2pdCecNGDphLLq/irXt2EarMhjcQS3onZ0w4THJ17/s=;
        b=AC/K1kVNvr41WX9aBa6SWUDHG/SHxc0cmy/7p/73rjS5s7ShAha60B4kICRZj1OKWZ
         2AXpKgY99QnkfgAh9NMFGVl0v12bvxBB31/asrzv7GU4Ujk+1ulnhl9wUD6mDcZ8kCNT
         gt2l0sNlfYSo2zQJzGUhLxu9oLClcVD0N/2HPhfxsGdrz4DcyOfbaS8VJt7s8qEuQkcV
         4ObPO+MNB5MmMyNgy4gM6n0GjzuOKlmadP0QxCg1a7Y+jrgQCN9Im6oy4T+xT6z0X0LG
         /2Wq59KvMUDd4i3P149AGX8wZIkzWkWHdTHXd6jkAiCwypGhwbCIDiJYsV9VIq3pLdRI
         N9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=2pdCecNGDphLLq/irXt2EarMhjcQS3onZ0w4THJ17/s=;
        b=D5n0+R1wht9iv7VwhNQRF8ID/UzWKJJEeKOxETPYENq9Bf/mzObGQ0bhAye23T8ZGE
         YXqF+UlqD5XBRLD4XQaANO5Rz7e7vZgBdwU+RCV6LkqYtb8Rxg5bhCLCRcK2TuoSQm4+
         /UJv5fzcI31pjsbO9FzMDYpK8BbXZPDexJ074XQVvBIBR3T5pLklMatzt3DJ/M7EA61J
         shpvgsfI4JhOLlcmgVGWA8YBQKPIb5k4LRcc46YhLsUnD3riB/BwxOPMh8lUPKd31cBM
         AUHP9RvZgg3jS5xaNC2KF5xglWeW/hEnhuApAqR1mVg1OsMRXx5PZdikFVX76FkayNNZ
         xhDw==
X-Gm-Message-State: APjAAAXnbXctKj69FZtIYbyHWOISgwBBpXyomVIjD868NX9WY/Aw9Xds
        3Wz+eimhC7yEhoj/kuUdsHM=
X-Google-Smtp-Source: APXvYqzK2MHwMFGpZz3m9pN78UTYhXeOBilynCvXR9e6OFASGdSi97ult0/A3x/6juJKHMn/C/fZxg==
X-Received: by 2002:a50:a544:: with SMTP id z4mr21924070edb.71.1557079295684;
        Sun, 05 May 2019 11:01:35 -0700 (PDT)
Received: from alum ([80.71.142.55])
        by smtp.gmail.com with ESMTPSA id q4sm1170264ejb.65.2019.05.05.11.01.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 11:01:32 -0700 (PDT)
Date:   Sun, 5 May 2019 20:01:30 +0200
From:   Malte Leip <malte@leip.net>
To:     gregkh@linuxfoundation.org
Cc:     skhan@linuxfoundation.org, stable@vger.kernel.org
Subject: [PATCH] usb: usbip: fix isoc packet num validation in get_pipe
Message-ID: <20190505180130.ry3w4m4dagmdxnuo@alum>
References: <15570612735029@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15570612735029@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c409ca3be3c6ff3a1eeb303b191184e80d412862 upstream.

Backport of the upstream commit, which fixed c6688ef9f297.
c6688ef9f297 got backported as commit eebf31529012, as the unavailable
function usb_endpoint_maxp_mult had to be replaced. The upstream commit
removed the call to this function, so the backport is straightforward.

Original commit message:

Change the validation of number_of_packets in get_pipe to compare the
number of packets to a fixed maximum number of packets allowed, set to
be 1024. This number was chosen due to it being used by other drivers as
well, for example drivers/usb/host/uhci-q.c

Background/reason:
The get_pipe function in stub_rx.c validates the number of packets in
isochronous mode and aborts with an error if that number is too large,
in order to prevent malicious input from possibly triggering large
memory allocations. This was previously done by checking whether
pdu->u.cmd_submit.number_of_packets is bigger than the number of packets
that would be needed for pdu->u.cmd_submit.transfer_buffer_length bytes
if all except possibly the last packet had maximum length, given by
usb_endpoint_maxp(epd) *  usb_endpoint_maxp_mult(epd). This leads to an
error if URBs with packets shorter than the maximum possible length are
submitted, which is allowed according to
Documentation/driver-api/usb/URB.rst and occurs for example with the
snd-usb-audio driver.

Fixes: eebf31529012 ("usbip: fix stub_rx: harden CMD_SUBMIT path to handle malicious input")
Signed-off-by: Malte Leip <malte@leip.net>
Cc: stable <stable@vger.kernel.org> # 3.18.x

---
 drivers/usb/usbip/stub_rx.c      | 18 +++---------------
 drivers/usb/usbip/usbip_common.h |  7 +++++++
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
index 56cacb68040c..808e3a317954 100644
--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -380,22 +380,10 @@ static int get_pipe(struct stub_device *sdev, struct usbip_header *pdu)
 	}
 
 	if (usb_endpoint_xfer_isoc(epd)) {
-		/* validate packet size and number of packets */
-		unsigned int maxp, packets, bytes;
-
-#define USB_EP_MAXP_MULT_SHIFT  11
-#define USB_EP_MAXP_MULT_MASK   (3 << USB_EP_MAXP_MULT_SHIFT)
-#define USB_EP_MAXP_MULT(m) \
-	(((m) & USB_EP_MAXP_MULT_MASK) >> USB_EP_MAXP_MULT_SHIFT)
-
-		maxp = usb_endpoint_maxp(epd);
-		maxp *= (USB_EP_MAXP_MULT(
-				__le16_to_cpu(epd->wMaxPacketSize)) + 1);
-		bytes = pdu->u.cmd_submit.transfer_buffer_length;
-		packets = DIV_ROUND_UP(bytes, maxp);
-
+		/* validate number of packets */
 		if (pdu->u.cmd_submit.number_of_packets < 0 ||
-		    pdu->u.cmd_submit.number_of_packets > packets) {
+		    pdu->u.cmd_submit.number_of_packets >
+		    USBIP_MAX_ISO_PACKETS) {
 			dev_err(&sdev->udev->dev,
 				"CMD_SUBMIT: isoc invalid num packets %d\n",
 				pdu->u.cmd_submit.number_of_packets);
diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
index 0fc5ace57c0e..af903aa4ad90 100644
--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -134,6 +134,13 @@ extern struct device_attribute dev_attr_usbip_debug;
 #define USBIP_DIR_OUT	0x00
 #define USBIP_DIR_IN	0x01
 
+/*
+ * Arbitrary limit for the maximum number of isochronous packets in an URB,
+ * compare for example the uhci_submit_isochronous function in
+ * drivers/usb/host/uhci-q.c
+ */
+#define USBIP_MAX_ISO_PACKETS 1024
+
 /**
  * struct usbip_header_basic - data pertinent to every request
  * @command: the usbip request type
-- 
2.11.0

