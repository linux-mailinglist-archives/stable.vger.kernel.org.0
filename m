Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1434499AF1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345771AbiAXVsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457337AbiAXVlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F85C0419D2;
        Mon, 24 Jan 2022 12:28:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C841961506;
        Mon, 24 Jan 2022 20:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C1DC340E5;
        Mon, 24 Jan 2022 20:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056079;
        bh=7n7G5SKrA1dBR0fD9xutzkUVLmfgbdkxbUUx2QGunBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiAHZNBMqMDHLhxM6KBbceHJL+74leDr10svYpN0vgbU4q9qMsyTcYYKc3fSGEinE
         pHRsE/AEHNDE80KrxwbWq+dg7fe3VCgp8KeJijsnaIel1uPYqJ3D0m6zmpavm46oxK
         b0fvzh6AxsdV17AobHzx8nQmFWhgTZFUTO3gwH/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 330/846] HID: hid-uclogic-params: Invalid parameter check in uclogic_params_huion_init
Date:   Mon, 24 Jan 2022 19:37:27 +0100
Message-Id: <20220124184112.289601276@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



