Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC7517AC80
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgCEROk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:14:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727738AbgCEROj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8221F21739;
        Thu,  5 Mar 2020 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428479;
        bh=1hBIVFpHKaOoRiF23bBVj2jf5aYyVhOa1BFzrADUCNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXo7Ec8ve10hfeTlGavWaYwyQVtwuNZ7uRga1dILBTAuIYaGY8bKqtdTQsHGHOW4V
         lq6acVWHxJb5V1kz00x9niQYi7LdZgB/iE9TkSuqiLHhn4nffhK9f/lMfQkl7DOdFm
         oCqQjpK5XH5jKFPatoXeYGUxdhj1XmTFoGQbWc2I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hanno Zulla <kontakt@hanno.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/58] HID: hid-bigbenff: call hid_hw_stop() in case of error
Date:   Thu,  5 Mar 2020 12:13:36 -0500
Message-Id: <20200305171420.29595-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

