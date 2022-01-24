Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BD649903D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353077AbiAXT7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50796 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357960AbiAXTxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:53:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E15760B4E;
        Mon, 24 Jan 2022 19:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84346C340E5;
        Mon, 24 Jan 2022 19:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054013;
        bh=8aVxZ5d5NrDI04qkthgBcQyo7elCVhjuzYezjAPXQhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaxsCXgW171F81HsvzjrHnjvw08riLDToP+0usNo6/egZVZXBIq/ACZY5uPXfSx3q
         /PiuLz5Sj7ZFf1/re9tKYOZk8G4i98XN4l/+/utUojdTffhnbNxy0QiQ963ifFo3d9
         KFfWiEqnyXeVSavXYSAPqRfdjCUk2VDwG8gd05HM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/563] HID: hid-uclogic-params: Invalid parameter check in uclogic_params_huion_init
Date:   Mon, 24 Jan 2022 19:39:42 +0100
Message-Id: <20220124184031.956289046@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index a751c9a49360f..df12178a80da5 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -707,9 +707,9 @@ static int uclogic_params_huion_init(struct uclogic_params *params,
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
@@ -723,6 +723,10 @@ static int uclogic_params_huion_init(struct uclogic_params *params,
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



