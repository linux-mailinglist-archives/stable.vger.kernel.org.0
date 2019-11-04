Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37BFEECD6
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388919AbfKDWAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388890AbfKDWAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:00:38 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5E01222C6;
        Mon,  4 Nov 2019 22:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904837;
        bh=UVWN1IQsnHONNGn6shfGmJKv7yWKE5L+vnchf3/8s1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJxlGlEmVjrDSFV8cysDcqMaGwRTyn8b+WX2P0LSG7fvH0bNDcAKggKfrgMw9fsMT
         fsmjiAs4JIpQLH7bmy1NcUXWwiZvVrPRSfliTDb3KdNUczzt/csb044Q287bLJNh0E
         xf+iT2Db17b+NJ1oyBwig03W463/SPZveYWAjzoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Simon Gene Gottlieb <simon@gottliebtfreitag.de>,
        Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/149] HID: steam: fix deadlock with input devices.
Date:   Mon,  4 Nov 2019 22:43:49 +0100
Message-Id: <20191104212138.296974518@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



