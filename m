Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A24E18B6E3
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgCSNYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730420AbgCSNYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:24:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4AA320724;
        Thu, 19 Mar 2020 13:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624244;
        bh=1hBIVFpHKaOoRiF23bBVj2jf5aYyVhOa1BFzrADUCNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nr/M2Gg8cnklsckswGMi06MtUP/Rs+v5icJq0zbf9ZS+O5nJt/LEerFqORSVcCiOI
         fvC80zrpV5tnOW/G9Bo9Zz7CfhJv8V0aQwG/uCs4VQwvun+5bWd6aOrXzG6bKPO1G5
         bQWWUe5iuvw6wnumKU5BhqkMx+S0kfs5IGwQYPjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanno Zulla <kontakt@hanno.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/60] HID: hid-bigbenff: call hid_hw_stop() in case of error
Date:   Thu, 19 Mar 2020 14:03:56 +0100
Message-Id: <20200319123924.935663763@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanno Zulla <kontakt@hanno.de>

[ Upstream commit 976a54d0f4202cb412a3b1fc7f117e1d97db35f3 ]

It's required to call hid_hw_stop() once hid_hw_start() was called
previously, so error cases need to handle this. Also, hid_hw_close() is
not necessary during removal.

Signed-off-by: Hanno Zulla <kontakt@hanno.de>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-bigbenff.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index f7e85bacb6889..f8c552b64a899 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -305,7 +305,6 @@ static void bigben_remove(struct hid_device *hid)
 	struct bigben_device *bigben = hid_get_drvdata(hid);
 
 	cancel_work_sync(&bigben->worker);
-	hid_hw_close(hid);
 	hid_hw_stop(hid);
 }
 
@@ -350,7 +349,7 @@ static int bigben_probe(struct hid_device *hid,
 	error = input_ff_create_memless(hidinput->input, NULL,
 		hid_bigben_play_effect);
 	if (error)
-		return error;
+		goto error_hw_stop;
 
 	name_sz = strlen(dev_name(&hid->dev)) + strlen(":red:bigben#") + 1;
 
@@ -360,8 +359,10 @@ static int bigben_probe(struct hid_device *hid,
 			sizeof(struct led_classdev) + name_sz,
 			GFP_KERNEL
 		);
-		if (!led)
-			return -ENOMEM;
+		if (!led) {
+			error = -ENOMEM;
+			goto error_hw_stop;
+		}
 		name = (void *)(&led[1]);
 		snprintf(name, name_sz,
 			"%s:red:bigben%d",
@@ -375,7 +376,7 @@ static int bigben_probe(struct hid_device *hid,
 		bigben->leds[n] = led;
 		error = devm_led_classdev_register(&hid->dev, led);
 		if (error)
-			return error;
+			goto error_hw_stop;
 	}
 
 	/* initial state: LED1 is on, no rumble effect */
@@ -389,6 +390,10 @@ static int bigben_probe(struct hid_device *hid,
 	hid_info(hid, "LED and force feedback support for BigBen gamepad\n");
 
 	return 0;
+
+error_hw_stop:
+	hid_hw_stop(hid);
+	return error;
 }
 
 static __u8 *bigben_report_fixup(struct hid_device *hid, __u8 *rdesc,
-- 
2.20.1



