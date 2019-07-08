Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863AF623D4
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389632AbfGHPbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732189AbfGHPbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:31:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B76D9217D8;
        Mon,  8 Jul 2019 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599867;
        bh=NYGGn8dknusu/JQ9RSlFcIFe7sjPRuZd6lPiMeQH28M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xr17glqpHR5J1cgd2g1MzqaYcEJZllooH6Uo4UdkRrDvdxvc7QKU5pvjnEL5NQmvs
         c8uwHclXZyHKbvVdav1It2UueCoD2EEDuvaV0K0MoFCRGmOBjB+M7ywzOrRrk4dks2
         nrUZbApkvhkRvn3kDQGyoQ0o31/L+VNANDaURSY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?B=C5=82a=C5=BCej=20Szczygie=C5=82?= <spaz16@wp.pl>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 16/96] HID: a4tech: fix horizontal scrolling
Date:   Mon,  8 Jul 2019 17:12:48 +0200
Message-Id: <20190708150527.286207032@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



