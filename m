Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5894147285B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbhLMKK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242794AbhLMKIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:08:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DD4C08E853;
        Mon, 13 Dec 2021 01:53:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42B43B80E1B;
        Mon, 13 Dec 2021 09:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F7BC341C5;
        Mon, 13 Dec 2021 09:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389187;
        bh=hNtyiT7zjoFiLciiBloCEHbUZjvjymW9uETHtOZJRcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgAp3+GDYX55zhjemMBEIQzY3qFlZUX0ViXTYlqkKG1EEViT2k8eLo/bLAo9HJiUp
         QzqmqiLxWKxsKqmf3Vnk/eOcwvcfeoh3ivi1tzJyOxsxbchWoXoqu8j21LC6xAmUzf
         DXIL9+7SMuvJwePI1B3Nltr+9wtdMpT3JLhl+I50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.15 014/171] HID: sony: fix error path in probe
Date:   Mon, 13 Dec 2021 10:28:49 +0100
Message-Id: <20211213092945.565449285@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 7998193bccc1c6e1537c5f3880fd0d5b949ec9d1 upstream.

When the setup of the GHL fails, we are not calling hid_hw_stop().
This leads to the hidraw node not being released, meaning a crash
whenever somebody attempts to open the file.

Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20211202095334.14399-2-benjamin.tissoires@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sony.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -3037,19 +3037,23 @@ static int sony_probe(struct hid_device
 	 */
 	if (!(hdev->claimed & HID_CLAIMED_INPUT)) {
 		hid_err(hdev, "failed to claim input\n");
-		hid_hw_stop(hdev);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err;
 	}
 
 	if (sc->quirks & (GHL_GUITAR_PS3WIIU | GHL_GUITAR_PS4)) {
-		if (!hid_is_usb(hdev))
-			return -EINVAL;
+		if (!hid_is_usb(hdev)) {
+			ret = -EINVAL;
+			goto err;
+		}
 
 		usbdev = to_usb_device(sc->hdev->dev.parent->parent);
 
 		sc->ghl_urb = usb_alloc_urb(0, GFP_ATOMIC);
-		if (!sc->ghl_urb)
-			return -ENOMEM;
+		if (!sc->ghl_urb) {
+			ret = -ENOMEM;
+			goto err;
+		}
 
 		if (sc->quirks & GHL_GUITAR_PS3WIIU)
 			ret = ghl_init_urb(sc, usbdev, ghl_ps3wiiu_magic_data,
@@ -3059,7 +3063,7 @@ static int sony_probe(struct hid_device
 							   ARRAY_SIZE(ghl_ps4_magic_data));
 		if (ret) {
 			hid_err(hdev, "error preparing URB\n");
-			return ret;
+			goto err;
 		}
 
 		timer_setup(&sc->ghl_poke_timer, ghl_magic_poke, 0);
@@ -3068,6 +3072,10 @@ static int sony_probe(struct hid_device
 	}
 
 	return ret;
+
+err:
+	hid_hw_stop(hdev);
+	return ret;
 }
 
 static void sony_remove(struct hid_device *hdev)


