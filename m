Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D14150E07
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgBCQZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:25:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbgBCQZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:25:10 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4581821582;
        Mon,  3 Feb 2020 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747109;
        bh=12c1Cba7k9vHIdxb59e3M30I8y9BZKq3PODOf2RGwDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fX788b/kPduGmEJF6ECai68kcLZy9scUT73QCg3o0Gdfe9Q/H7p2ep2HizMD6AIHb
         NVYT37f7TGL0fcfC2XA+F1fPVIWda/ZdLWvdkENl7EmR00p94S3vb9q1gnJeIJNxng
         Fr5aOBn2ne45VNd7gTD5KXeHU1joFv7yDewSaPSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 16/68] zd1211rw: fix storage endpoint lookup
Date:   Mon,  3 Feb 2020 16:19:12 +0000
Message-Id: <20200203161907.738309609@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 2d68bb2687abb747558b933e80845ff31570a49c upstream.

Make sure to use the current alternate setting when verifying the
storage interface descriptors to avoid submitting an URB to an invalid
endpoint.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: a1030e92c150 ("[PATCH] zd1211rw: Convert installer CDROM device into WLAN device")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1272,7 +1272,7 @@ static void print_id(struct usb_device *
 static int eject_installer(struct usb_interface *intf)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-	struct usb_host_interface *iface_desc = &intf->altsetting[0];
+	struct usb_host_interface *iface_desc = intf->cur_altsetting;
 	struct usb_endpoint_descriptor *endpoint;
 	unsigned char *cmd;
 	u8 bulk_out_ep;


