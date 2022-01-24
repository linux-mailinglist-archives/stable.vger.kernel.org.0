Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983DC4997DA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378348AbiAXVRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35772 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377730AbiAXVMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:12:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ED32611C8;
        Mon, 24 Jan 2022 21:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8F0C340E5;
        Mon, 24 Jan 2022 21:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058769;
        bh=7n7G5SKrA1dBR0fD9xutzkUVLmfgbdkxbUUx2QGunBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTuvbW9aY2GG7ms8oLJg8na2L5YSTXdKmjnWYoRiMo3rtQf0HKBXJJuyUHv6RzzhS
         OILEv9kEGIhfZv2nge3KbdH7JIlvIf3F+/GT6mLcA097teTz3x1lltEyVUPkCtO9ow
         yLzvihesLzJ1gs/mnoaf+AmhAFhlQDsJBrEX8fqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0396/1039] HID: hid-uclogic-params: Invalid parameter check in uclogic_params_huion_init
Date:   Mon, 24 Jan 2022 19:36:25 +0100
Message-Id: <20220124184138.631040334@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit ff6b548afe4d9d1ff3a0f6ef79e8cbca25d8f905 ]

The function performs a check on its input parameters, however, the
hdev parameter is used before the check.

Initialize the stack variables after checking the input parameters to
avoid a possible NULL pointer dereference.

Fixes: 9614219e9310e ("HID: uclogic: Extract tablet parameter discovery into a module")
Addresses-Coverity-ID: 1443804 ("Null pointer dereference")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-params.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index 3a83e2c39b4fb..4136837e4d158 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -709,9 +709,9 @@ static int uclogic_params_huion_init(struct uclogic_params *params,
 				     struct hid_device *hdev)
 {
 	int rc;
-	struct usb_device *udev = hid_to_usb_dev(hdev);
-	struct usb_interface *iface = to_usb_interface(hdev->dev.parent);
-	__u8 bInterfaceNumber = iface->cur_altsetting->desc.bInterfaceNumber;
+	struct usb_device *udev;
+	struct usb_interface *iface;
+	__u8 bInterfaceNumber;
 	bool found;
 	/* The resulting parameters (noop) */
 	struct uclogic_params p = {0, };
@@ -725,6 +725,10 @@ static int uclogic_params_huion_init(struct uclogic_params *params,
 		goto cleanup;
 	}
 
+	udev = hid_to_usb_dev(hdev);
+	iface = to_usb_interface(hdev->dev.parent);
+	bInterfaceNumber = iface->cur_altsetting->desc.bInterfaceNumber;
+
 	/* If it's not a pen interface */
 	if (bInterfaceNumber != 0) {
 		/* TODO: Consider marking the interface invalid */
-- 
2.34.1



