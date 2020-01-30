Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DA514E262
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730747AbgA3SoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbgA3SoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09B19205F4;
        Thu, 30 Jan 2020 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409851;
        bh=JJ8+gzjBcqD4VvCA71mKfdhHv1H5sxdLCa5olQTQlag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiRc7zuFT/0ooWABjRO6CYf96KMWiC7G6VwA/0MXBGNGt/aiv2Ets2mKql2ktlHNS
         pS8I3uuaDQULxiMtxIv7YYcORRLILlm/Ma5qNKCIuoUifhgaBjXLuywKmZ/FmoiF8X
         ZF/aLM7LUtBLiAKlsKAqrTiW7bKk8sboJIY0iuz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/110] HID: wacom: Recognize new MobileStudio Pro PID
Date:   Thu, 30 Jan 2020 19:38:27 +0100
Message-Id: <20200130183621.169874874@linuxfoundation.org>
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

From: Jason Gerecke <killertofu@gmail.com>

[ Upstream commit fe4e940f0f91b4a506f048b42e00386f5ad322b6 ]

A new PID is in use for repaired MobileStudio Pro devices. Add it to the
list of devices that need special-casing in wacom_wac_pad_event.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index ccb74529bc782..d99a9d407671c 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2096,14 +2096,16 @@ static void wacom_wac_pad_event(struct hid_device *hdev, struct hid_field *field
 		    (hdev->product == 0x34d || hdev->product == 0x34e ||  /* MobileStudio Pro */
 		     hdev->product == 0x357 || hdev->product == 0x358 ||  /* Intuos Pro 2 */
 		     hdev->product == 0x392 ||				  /* Intuos Pro 2 */
-		     hdev->product == 0x398 || hdev->product == 0x399)) { /* MobileStudio Pro */
+		     hdev->product == 0x398 || hdev->product == 0x399 ||  /* MobileStudio Pro */
+		     hdev->product == 0x3AA)) {				  /* MobileStudio Pro */
 			value = (field->logical_maximum - value);
 
 			if (hdev->product == 0x357 || hdev->product == 0x358 ||
 			    hdev->product == 0x392)
 				value = wacom_offset_rotation(input, usage, value, 3, 16);
 			else if (hdev->product == 0x34d || hdev->product == 0x34e ||
-				 hdev->product == 0x398 || hdev->product == 0x399)
+				 hdev->product == 0x398 || hdev->product == 0x399 ||
+				 hdev->product == 0x3AA)
 				value = wacom_offset_rotation(input, usage, value, 1, 2);
 		}
 		else {
-- 
2.20.1



