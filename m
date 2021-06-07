Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC2F39E2CE
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbhFGQTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232611AbhFGQRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:17:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B33061492;
        Mon,  7 Jun 2021 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082458;
        bh=x/MSIPhBoYYVKm2W5UIZr81FjpT8zeIcRXVxdWprkts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiHNL12k72puPSMdOTRDtm6993Nre2B6DD5oSNTwZF3xC19v1Jg84zJpJE8mynpjJ
         TxZ54sw9/6l29jhl0ZRZexkLBH4IfohL/VtV6xKsyRI9IUFYaD9XNl6NeScnx78WZD
         vfxWvc17jh4J0LAXTb5zfMSfFngE5UxZFjtKTEYIPulPkT/vccNHPnV9TkRP0K6Vk+
         16kg/QNgTaG1qBAVLq+v24mNOLSsfxZgYBm3bCyEEFEQQQO7VjqgXxgENr+N9wiKps
         1SnnRbCNoW1zLCrNYuEsIUUqdpvdK00AFRtaVsrnxn5xfpe53UR3xKSohAE0vht03V
         p32i8R+oZ5SDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= 
        <nabijaczleweli@nabijaczleweli.xyz>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/29] HID: multitouch: set Stylus suffix for Stylus-application devices, too
Date:   Mon,  7 Jun 2021 12:13:47 -0400
Message-Id: <20210607161410.3584036-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

[ Upstream commit bc8b796f618c3ccb0a2a8ed1e96c00a1a7849415 ]

This re-adds the suffix to Win8 stylus-on-touchscreen devices,
now that they aren't erroneously marked as MT

Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d91e6679afb1..9d43d2d16509 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1583,13 +1583,13 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 		/* we do not set suffix = "Touchscreen" */
 		hi->input->name = hdev->name;
 		break;
-	case HID_DG_STYLUS:
-		/* force BTN_STYLUS to allow tablet matching in udev */
-		__set_bit(BTN_STYLUS, hi->input->keybit);
-		break;
 	case HID_VD_ASUS_CUSTOM_MEDIA_KEYS:
 		suffix = "Custom Media Keys";
 		break;
+	case HID_DG_STYLUS:
+		/* force BTN_STYLUS to allow tablet matching in udev */
+		__set_bit(BTN_STYLUS, hi->input->keybit);
+		fallthrough;
 	case HID_DG_PEN:
 		suffix = "Stylus";
 		break;
-- 
2.30.2

