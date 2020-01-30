Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1644914E14B
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbgA3SnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730524AbgA3SnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2D60205F4;
        Thu, 30 Jan 2020 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409784;
        bh=JR1RwpBMjLTWErhKmNkJO3sfcrMLDq74tnVgsfQQTM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7iiql+I2MR6HhmE2hVXfBp3sDIJPiyW+vgkV1piUZKuxNRZdkOA6Xp7i+vRXagJU
         57aXosqqVJMfu8UNuzmunTeG6xBK239ebskNUVraTRDM4zkAcCPzyWPl4EkgYnCXjB
         ya+YTCQT00FwhvEmPYHRSTq5fdNxWi/3JnyQMkGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 031/110] ath9k: fix storage endpoint lookup
Date:   Thu, 30 Jan 2020 19:38:07 +0100
Message-Id: <20200130183619.070047346@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
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
@@ -1216,7 +1216,7 @@ err_fw:
 static int send_eject_command(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
-	struct usb_host_interface *iface_desc = &interface->altsetting[0];
+	struct usb_host_interface *iface_desc = interface->cur_altsetting;
 	struct usb_endpoint_descriptor *endpoint;
 	unsigned char *cmd;
 	u8 bulk_out_ep;


