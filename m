Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14163DD3F7
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbfJRWGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731085AbfJRWGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA7D2205F4;
        Fri, 18 Oct 2019 22:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436374;
        bh=HKTIdQwMrvjWDforNYHTyKrkVYHiKnZQBFV//gOWcXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtQxZuNggzbhcRWNWiONnVFAKKbOz4T9v3g7ZUIM7FT/SAlumhoRhFP1GDe4UWfNG
         am4upmtfcn0pAAOgx0BSjAFZfTPQZWWOeNzom7FKAdwSNyDxX6EdKgClHDlomeA0jb
         H2i4NOMFrM8ZvEGWdhZLIhHB4cEM/6zbD5/FmgzY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 028/100] HID: steam: fix boot loop with bluetooth firmware
Date:   Fri, 18 Oct 2019 18:04:13 -0400
Message-Id: <20191018220525.9042-28-sashal@kernel.org>
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

[ Upstream commit cf28aee292e102740e49f74385b4b89c00050763 ]

There is a new firmware for the Steam Controller with support for BLE
connections. When using such a device with a wired connection, it
reboots itself every 10 seconds unless an application has opened it.

Doing hid_hw_open() unconditionally on probe fixes the issue, and the
code becomes simpler.

Signed-off-by: Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index dc4128bfe2ca9..8141cadfca0e3 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -283,11 +283,6 @@ static void steam_set_lizard_mode(struct steam_device *steam, bool enable)
 static int steam_input_open(struct input_dev *dev)
 {
 	struct steam_device *steam = input_get_drvdata(dev);
-	int ret;
-
-	ret = hid_hw_open(steam->hdev);
-	if (ret)
-		return ret;
 
 	mutex_lock(&steam->mutex);
 	if (!steam->client_opened && lizard_mode)
@@ -304,8 +299,6 @@ static void steam_input_close(struct input_dev *dev)
 	if (!steam->client_opened && lizard_mode)
 		steam_set_lizard_mode(steam, true);
 	mutex_unlock(&steam->mutex);
-
-	hid_hw_close(steam->hdev);
 }
 
 static enum power_supply_property steam_battery_props[] = {
@@ -623,11 +616,6 @@ static void steam_client_ll_stop(struct hid_device *hdev)
 static int steam_client_ll_open(struct hid_device *hdev)
 {
 	struct steam_device *steam = hdev->driver_data;
-	int ret;
-
-	ret = hid_hw_open(steam->hdev);
-	if (ret)
-		return ret;
 
 	mutex_lock(&steam->mutex);
 	steam->client_opened = true;
@@ -635,7 +623,7 @@ static int steam_client_ll_open(struct hid_device *hdev)
 
 	steam_input_unregister(steam);
 
-	return ret;
+	return 0;
 }
 
 static void steam_client_ll_close(struct hid_device *hdev)
@@ -646,7 +634,6 @@ static void steam_client_ll_close(struct hid_device *hdev)
 	steam->client_opened = false;
 	mutex_unlock(&steam->mutex);
 
-	hid_hw_close(steam->hdev);
 	if (steam->connected) {
 		steam_set_lizard_mode(steam, lizard_mode);
 		steam_input_register(steam);
@@ -759,14 +746,15 @@ static int steam_probe(struct hid_device *hdev,
 	if (ret)
 		goto client_hdev_add_fail;
 
+	ret = hid_hw_open(hdev);
+	if (ret) {
+		hid_err(hdev,
+			"%s:hid_hw_open\n",
+			__func__);
+		goto hid_hw_open_fail;
+	}
+
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
-		ret = hid_hw_open(hdev);
-		if (ret) {
-			hid_err(hdev,
-				"%s:hid_hw_open for wireless\n",
-				__func__);
-			goto hid_hw_open_fail;
-		}
 		hid_info(hdev, "Steam wireless receiver connected");
 		steam_request_conn_status(steam);
 	} else {
@@ -781,8 +769,8 @@ static int steam_probe(struct hid_device *hdev,
 
 	return 0;
 
-hid_hw_open_fail:
 input_register_fail:
+hid_hw_open_fail:
 client_hdev_add_fail:
 	hid_hw_stop(hdev);
 hid_hw_start_fail:
@@ -809,8 +797,8 @@ static void steam_remove(struct hid_device *hdev)
 	cancel_work_sync(&steam->work_connect);
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
 		hid_info(hdev, "Steam wireless receiver disconnected");
-		hid_hw_close(hdev);
 	}
+	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
 	steam_unregister(steam);
 }
-- 
2.20.1

