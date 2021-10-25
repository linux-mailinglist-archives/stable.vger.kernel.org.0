Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C268C4394F8
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhJYLnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230058AbhJYLnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:43:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0710460F22;
        Mon, 25 Oct 2021 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635162039;
        bh=7iq1S2INfykGSss8PFEiH9xQxiYNWl/G6VXjyPTK3Xg=;
        h=From:To:Cc:Subject:Date:From;
        b=HsQctk6ETFurBfXm7FcghgFHqA89rr7OZaTamB8o4ejBAUOxn9i7gi/YlNMTmopq3
         vauB/QYAFDzWsvNaW31VTq1eeWdWJ6c0F1AdtGYtsS6DIUEc99vhpZc66Dz9oeD9NY
         RzbpyOvfjO4NiRhY7rY8I46cxUj4wIV5hia8e8ZcDn8mlgUW1FsTX4uvoIOnb/fTho
         P1Z1hEQ1ZhkD38XJ9zxM0bkwux8BPpAkCwaGwGva2z/Z6i2DlXtsYAUIv37YkabUgV
         ZTRheyYpe/AbfyX4/Xd6D022vquQQBoKDc7D7DfhnI+CLs+xw4TaoC50gSqJvmmM12
         fOmsLGi7d4+JA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyKz-000196-Es; Mon, 25 Oct 2021 13:40:21 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] Bluetooth: fix division by zero in send path
Date:   Mon, 25 Oct 2021 13:39:44 +0200
Message-Id: <20211025113944.4350-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add the missing bulk-out endpoint sanity check to probe() to avoid
division by zero in bfusb_send_frame() in case a malicious device has
broken descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/bluetooth/bfusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index 5a321b4076aa..df80fb324356 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -627,6 +627,8 @@ static int bfusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	data->bulk_in_ep    = bulk_in_ep->desc.bEndpointAddress;
 	data->bulk_out_ep   = bulk_out_ep->desc.bEndpointAddress;
 	data->bulk_pkt_size = le16_to_cpu(bulk_out_ep->desc.wMaxPacketSize);
+	if (!data->bulk_pkt_size)
+		goto done;
 
 	rwlock_init(&data->lock);
 
-- 
2.32.0

