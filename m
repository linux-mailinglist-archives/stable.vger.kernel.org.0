Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215DD49A064
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383473AbiAXXGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383742AbiAXW6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:58:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B9FC08E877;
        Mon, 24 Jan 2022 13:12:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B3CAB81243;
        Mon, 24 Jan 2022 21:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878E7C340E5;
        Mon, 24 Jan 2022 21:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058763;
        bh=anTBheG/cQTrGNr9zNDhDMuwJYqOQuxzSHzVVM1jvHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0LnkABhV7JA/vE59syLzc7bFfbUBSj1bBG58XdJaGZCRgOaar6748BsLYec1rkwq
         +B7QJJsqgTLrbwFUMALuful7dk+zqdKYCM1SGJtQRQwx0h1vOxnEmMFphdAquFnJEE
         IvoBQzMyx+SPNiWk246pWvTZuFQwknnx7LsCrieI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0394/1039] HID: hid-uclogic-params: Invalid parameter check in uclogic_params_init
Date:   Mon, 24 Jan 2022 19:36:23 +0100
Message-Id: <20220124184138.566261375@linuxfoundation.org>
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

[ Upstream commit f364c571a5c77e96de2d32062ff019d6b8d2e2bc ]

The function performs a check on its input parameters, however, the
hdev parameter is used before the check.

Initialize the stack variables after checking the input parameters to
avoid a possible NULL pointer dereference.

Fixes: 9614219e9310e ("HID: uclogic: Extract tablet parameter discovery into a module")
Addresses-Coverity-ID: 1443831 ("Null pointer dereference")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-params.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index adff1bd68d9f8..3c10b858cf74c 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -834,10 +834,10 @@ int uclogic_params_init(struct uclogic_params *params,
 			struct hid_device *hdev)
 {
 	int rc;
-	struct usb_device *udev = hid_to_usb_dev(hdev);
-	__u8  bNumInterfaces = udev->config->desc.bNumInterfaces;
-	struct usb_interface *iface = to_usb_interface(hdev->dev.parent);
-	__u8 bInterfaceNumber = iface->cur_altsetting->desc.bInterfaceNumber;
+	struct usb_device *udev;
+	__u8  bNumInterfaces;
+	struct usb_interface *iface;
+	__u8 bInterfaceNumber;
 	bool found;
 	/* The resulting parameters (noop) */
 	struct uclogic_params p = {0, };
@@ -848,6 +848,11 @@ int uclogic_params_init(struct uclogic_params *params,
 		goto cleanup;
 	}
 
+	udev = hid_to_usb_dev(hdev);
+	bNumInterfaces = udev->config->desc.bNumInterfaces;
+	iface = to_usb_interface(hdev->dev.parent);
+	bInterfaceNumber = iface->cur_altsetting->desc.bInterfaceNumber;
+
 	/*
 	 * Set replacement report descriptor if the original matches the
 	 * specified size. Otherwise keep interface unchanged.
-- 
2.34.1



