Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D63156085
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfFZDlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfFZDlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:41:45 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6362F2168B;
        Wed, 26 Jun 2019 03:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520504;
        bh=rhVLW5hBkjFRb9VPCj9+agroOiXlytsEqAo5ZrqBteM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyHiRFwfQcYeSZJf5ZKGvWQrTk0IzbbfjLgKDxXeGGrGv6h61Uz6gNZPvoXsOni7d
         SDV9s7kDnNfxU1QrtSHm/7GwZdEVnQTU79Lq3VaZv3c3oOCnHvNHdqQaMZeZ5JDjZg
         Lnsl4v8LABC3AY5HTcTb7YpMGyAmggJ4LRJ4XUdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?B=C5=82a=C5=BCej=20Szczygie=C5=82?= <spaz16@wp.pl>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 12/51] HID: a4tech: fix horizontal scrolling
Date:   Tue, 25 Jun 2019 23:40:28 -0400
Message-Id: <20190626034117.23247-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Błażej Szczygieł <spaz16@wp.pl>

[ Upstream commit abf82e8f7e9af40a49e3d905187c662a43c96c8f ]

Since recent high resolution scrolling changes the A4Tech driver must
check for the "REL_WHEEL_HI_RES" usage code.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=203369
Fixes: 2dc702c991e3774af9d7ce410eef410ca9e2357e ("HID: input: use the Resolution Multiplier for high-resolution scrolling")
Signed-off-by: Błażej Szczygieł <spaz16@wp.pl>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-a4tech.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 9428ea7cdf8a..c3a6ce3613fe 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -38,8 +38,10 @@ static int a4_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 {
 	struct a4tech_sc *a4 = hid_get_drvdata(hdev);
 
-	if (usage->type == EV_REL && usage->code == REL_WHEEL)
+	if (usage->type == EV_REL && usage->code == REL_WHEEL_HI_RES) {
 		set_bit(REL_HWHEEL, *bit);
+		set_bit(REL_HWHEEL_HI_RES, *bit);
+	}
 
 	if ((a4->quirks & A4_2WHEEL_MOUSE_HACK_7) && usage->hid == 0x00090007)
 		return -1;
@@ -60,7 +62,7 @@ static int a4_event(struct hid_device *hdev, struct hid_field *field,
 	input = field->hidinput->input;
 
 	if (a4->quirks & A4_2WHEEL_MOUSE_HACK_B8) {
-		if (usage->type == EV_REL && usage->code == REL_WHEEL) {
+		if (usage->type == EV_REL && usage->code == REL_WHEEL_HI_RES) {
 			a4->delayed_value = value;
 			return 1;
 		}
@@ -68,6 +70,8 @@ static int a4_event(struct hid_device *hdev, struct hid_field *field,
 		if (usage->hid == 0x000100b8) {
 			input_event(input, EV_REL, value ? REL_HWHEEL :
 					REL_WHEEL, a4->delayed_value);
+			input_event(input, EV_REL, value ? REL_HWHEEL_HI_RES :
+					REL_WHEEL_HI_RES, a4->delayed_value * 120);
 			return 1;
 		}
 	}
@@ -77,8 +81,9 @@ static int a4_event(struct hid_device *hdev, struct hid_field *field,
 		return 1;
 	}
 
-	if (usage->code == REL_WHEEL && a4->hw_wheel) {
+	if (usage->code == REL_WHEEL_HI_RES && a4->hw_wheel) {
 		input_event(input, usage->type, REL_HWHEEL, value);
+		input_event(input, usage->type, REL_HWHEEL_HI_RES, value * 120);
 		return 1;
 	}
 
-- 
2.20.1

