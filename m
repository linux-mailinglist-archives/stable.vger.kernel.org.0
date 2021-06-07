Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D902E39E250
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhFGQQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232062AbhFGQPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07C6261434;
        Mon,  7 Jun 2021 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082408;
        bh=D6qso4Hso6fAyY+lWCDiHrTnx76DFJk6Q9MX28z18FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNXvcqW4yR2Lgp2nO69ixfGk7+1s6UuyDZeXbNTrIVrtBvXuz9bz6VeZUUplVuexC
         bGDoYSAv3tBs6K9JxF6DtTgGATFMN7SlzLD+qo9FVJgLt/5fMMnj46mUMtZg8Uw9rL
         V0p81K1ISBTPyqL9CcHlei1WIQlENQ/oXsqI8nk3/ryHkKdAhEGkpgWa2+4cHfCeHm
         R64HHgBTkcxK4Mqxjcr1Hz69aR3MSK+6ShylxQJXoR+F+1OE8vBfNxMsSh63/SMtY3
         6J9RYsUO/iddgnoQ/dzFeloyRR5ih8AG4L57Ttd1mWLvG3k1Dhj2H2xdUY5zDr05E2
         qS3DhSbRirIlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= 
        <nabijaczleweli@nabijaczleweli.xyz>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/39] HID: multitouch: set Stylus suffix for Stylus-application devices, too
Date:   Mon,  7 Jun 2021 12:12:46 -0400
Message-Id: <20210607161318.3583636-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
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
index 8429ebe7097e..d298541e64b2 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1576,13 +1576,13 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
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

