Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99CEDDD3F6
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbfJRWVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731138AbfJRWGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF9232245B;
        Fri, 18 Oct 2019 22:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436375;
        bh=UVWN1IQsnHONNGn6shfGmJKv7yWKE5L+vnchf3/8s1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvokMGt29IIJjp7rIroVqV6zGHeWV3WK0RjTrlYHE4/+hRrPtIAxTvTQxI+SSg+NK
         KK6idg1DPGJ4jhPdYhmvSxL9xlvQsX5GSEvjD5rNvP0aLK8QZUTMee+9DQchasaFdI
         TqWYBBO4hJri51dmiaBbKb9VyC314Z1LfVl/AaWs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>,
        Simon Gene Gottlieb <simon@gottliebtfreitag.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 029/100] HID: steam: fix deadlock with input devices.
Date:   Fri, 18 Oct 2019 18:04:14 -0400
Message-Id: <20191018220525.9042-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>

[ Upstream commit 6b538cc21334b83f09b25dec4aa2d2726bf07ed0 ]

When using this driver with the wireless dongle and some usermode
program that monitors every input device (acpid, for example), while
another usermode client opens and closes the low-level device
repeadedly, the system eventually deadlocks.

The reason is that steam_input_register_device() must not be called with
the mutex held, because the input subsystem has its own synchronization
that clashes with this one: it is possible that steam_input_open() is
called before input_register_device() returns, and since
steam_input_open() needs to lock the mutex, it deadlocks.

However we must hold the mutex when calling any function that sends
commands to the controller. If not, random commands end up falling fail.

Reported-by: Simon Gene Gottlieb <simon@gottliebtfreitag.de>
Signed-off-by: Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>
Tested-by: Simon Gene Gottlieb <simon@gottliebtfreitag.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 8141cadfca0e3..8dae0f9b819e0 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -499,6 +499,7 @@ static void steam_battery_unregister(struct steam_device *steam)
 static int steam_register(struct steam_device *steam)
 {
 	int ret;
+	bool client_opened;
 
 	/*
 	 * This function can be called several times in a row with the
@@ -511,9 +512,11 @@ static int steam_register(struct steam_device *steam)
 		 * Unlikely, but getting the serial could fail, and it is not so
 		 * important, so make up a serial number and go on.
 		 */
+		mutex_lock(&steam->mutex);
 		if (steam_get_serial(steam) < 0)
 			strlcpy(steam->serial_no, "XXXXXXXXXX",
 					sizeof(steam->serial_no));
+		mutex_unlock(&steam->mutex);
 
 		hid_info(steam->hdev, "Steam Controller '%s' connected",
 				steam->serial_no);
@@ -528,13 +531,15 @@ static int steam_register(struct steam_device *steam)
 	}
 
 	mutex_lock(&steam->mutex);
-	if (!steam->client_opened) {
+	client_opened = steam->client_opened;
+	if (!client_opened)
 		steam_set_lizard_mode(steam, lizard_mode);
+	mutex_unlock(&steam->mutex);
+
+	if (!client_opened)
 		ret = steam_input_register(steam);
-	} else {
+	else
 		ret = 0;
-	}
-	mutex_unlock(&steam->mutex);
 
 	return ret;
 }
@@ -630,14 +635,21 @@ static void steam_client_ll_close(struct hid_device *hdev)
 {
 	struct steam_device *steam = hdev->driver_data;
 
+	unsigned long flags;
+	bool connected;
+
+	spin_lock_irqsave(&steam->lock, flags);
+	connected = steam->connected;
+	spin_unlock_irqrestore(&steam->lock, flags);
+
 	mutex_lock(&steam->mutex);
 	steam->client_opened = false;
+	if (connected)
+		steam_set_lizard_mode(steam, lizard_mode);
 	mutex_unlock(&steam->mutex);
 
-	if (steam->connected) {
-		steam_set_lizard_mode(steam, lizard_mode);
+	if (connected)
 		steam_input_register(steam);
-	}
 }
 
 static int steam_client_ll_raw_request(struct hid_device *hdev,
-- 
2.20.1

