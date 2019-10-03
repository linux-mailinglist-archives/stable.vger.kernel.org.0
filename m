Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C578ECAB9D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbfJCP4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730794AbfJCP4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:56:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54EDD20700;
        Thu,  3 Oct 2019 15:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118213;
        bh=GAE2HLg/01cvzJ5pm27QrzJnQpSuN3EpD3z2D6FX7jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSL/catwEb/9i06BxL9fM6vqT3VjsSrh5oFVI5Tkz7LSD1333ImTzXyM5s+4fGrfl
         Xu42yudFpCUMbYgm9Ab00WVnJ5qpKDzcJH106TM3yfNbMjVCxrHZZhg6f08UWepTFT
         T9qjB/DkmFseR1uaYVM/FOQv329Ex0egPOKrV3fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.4 03/99] HID: lg: make transfer buffers DMA capable
Date:   Thu,  3 Oct 2019 17:52:26 +0200
Message-Id: <20191003154253.721135607@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 061232f0d47fa10103f3efa3e890f002a930d902 upstream.

Kernel v4.9 strictly enforces DMA capable buffers, so we need to remove
buffers allocated on the stack.

[jkosina@suse.cz: fix up second usage of hid_hw_raw_request(), spotted by
 0day build bot]
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-lg.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -701,11 +701,16 @@ static int lg_probe(struct hid_device *h
 
 	/* Setup wireless link with Logitech Wii wheel */
 	if (hdev->product == USB_DEVICE_ID_LOGITECH_WII_WHEEL) {
-		unsigned char buf[] = { 0x00, 0xAF,  0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
+		const unsigned char cbuf[] = { 0x00, 0xAF,  0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
+		u8 *buf = kmemdup(cbuf, sizeof(cbuf), GFP_KERNEL);
 
-		ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
-					HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto err_free;
+		}
 
+		ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(cbuf),
+					HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 		if (ret >= 0) {
 			/* insert a little delay of 10 jiffies ~ 40ms */
 			wait_queue_head_t wait;
@@ -717,9 +722,10 @@ static int lg_probe(struct hid_device *h
 			buf[1] = 0xB2;
 			get_random_bytes(&buf[2], 2);
 
-			ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
+			ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(cbuf),
 					HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 		}
+		kfree(buf);
 	}
 
 	if (drv_data->quirks & LG_FF)


