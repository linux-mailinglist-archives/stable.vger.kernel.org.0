Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3113150DCD
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgBCQ1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:27:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbgBCQ1u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:27:50 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6C9220838;
        Mon,  3 Feb 2020 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747270;
        bh=CiQeIRcGx1eIKU7i3VXIcuFBQVvaTX2mx9Zqf/l7cyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5gkyEFsvqyBUVmTLdSShThHn4Lr/fDG8ATAr4Te0eti/K1mlZ0zhVmb7TOgkZqd3
         ajqzhfgU/uAbHxqPPQAvnS6HAABLifgxDrLo29qEuCL/RwqmhpEQgYZhpagWGtygXn
         qQvqbvZ3DWmCpYRm0tfP4FotTE3KIhxkBgWgG4gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 14/89] ath9k: fix storage endpoint lookup
Date:   Mon,  3 Feb 2020 16:18:59 +0000
Message-Id: <20200203161918.759534226@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 0ef332951e856efa89507cdd13ba8f4fb8d4db12 upstream.

Make sure to use the current alternate setting when verifying the
storage interface descriptors to avoid submitting an URB to an invalid
endpoint.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 36bcce430657 ("ath9k_htc: Handle storage devices")
Cc: stable <stable@vger.kernel.org>     # 2.6.39
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1214,7 +1214,7 @@ err_fw:
 static int send_eject_command(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
-	struct usb_host_interface *iface_desc = &interface->altsetting[0];
+	struct usb_host_interface *iface_desc = interface->cur_altsetting;
 	struct usb_endpoint_descriptor *endpoint;
 	unsigned char *cmd;
 	u8 bulk_out_ep;


