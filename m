Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DE337C59F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhELPmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236236AbhELPhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC49861C4B;
        Wed, 12 May 2021 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832732;
        bh=nlX+jdxuZUhjCl11Av14x6M7WtnJTWnqSGD9+Js8oYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYe6xclQOKqoGBJj8TgNRDWnMjgdphR3uXPugJ+H8wR1X9n0HPSmbCMn0PI9Rp0H2
         pXn7IByLfe1iaOx1kSztO0BCUtSA74zlaiXvj194ElexejI+yFfM69vRbzBjYp/alU
         cGasSSymZ7+HRFuVMRk1UPCU0B2VebpZstjWkY64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 399/530] HID: lenovo: Map mic-mute button to KEY_F20 instead of KEY_MICMUTE
Date:   Wed, 12 May 2021 16:48:29 +0200
Message-Id: <20210512144832.881471983@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 617103246cfd19af837e4cb614ba9f877c4f7779 ]

Mapping the mic-mute button to KEY_MICMUTE is technically correct but
KEY_MICMUTE translates to a scancode of 256 (248 + 8) under X,
which does not fit in 8 bits, so it does not work.

Because of this userspace is expecting KEY_F20 instead,
theoretically KEY_MICMUTE should work under Wayland but even
there it does not work, because the desktop-environment is
listening only for KEY_F20 and not for KEY_MICMUTE.

Fixes: bc04b37ea0ec ("HID: lenovo: Add ThinkPad 10 Ultrabook Keyboard support")
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-lenovo.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index b2596ed37880..0ff03fed9770 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -33,6 +33,9 @@
 
 #include "hid-ids.h"
 
+/* Userspace expects F20 for mic-mute KEY_MICMUTE does not work */
+#define LENOVO_KEY_MICMUTE KEY_F20
+
 struct lenovo_drvdata {
 	u8 led_report[3]; /* Must be first for proper alignment */
 	int led_state;
@@ -134,7 +137,7 @@ static int lenovo_input_mapping_tpkbd(struct hid_device *hdev,
 	if (usage->hid == (HID_UP_BUTTON | 0x0010)) {
 		/* This sub-device contains trackpoint, mark it */
 		hid_set_drvdata(hdev, (void *)1);
-		map_key_clear(KEY_MICMUTE);
+		map_key_clear(LENOVO_KEY_MICMUTE);
 		return 1;
 	}
 	return 0;
@@ -149,7 +152,7 @@ static int lenovo_input_mapping_cptkbd(struct hid_device *hdev,
 	    (usage->hid & HID_USAGE_PAGE) == HID_UP_LNVENDOR) {
 		switch (usage->hid & HID_USAGE) {
 		case 0x00f1: /* Fn-F4: Mic mute */
-			map_key_clear(KEY_MICMUTE);
+			map_key_clear(LENOVO_KEY_MICMUTE);
 			return 1;
 		case 0x00f2: /* Fn-F5: Brightness down */
 			map_key_clear(KEY_BRIGHTNESSDOWN);
@@ -239,7 +242,7 @@ static int lenovo_input_mapping_tp10_ultrabook_kbd(struct hid_device *hdev,
 			map_key_clear(KEY_FN_ESC);
 			return 1;
 		case 9: /* Fn-F4: Mic mute */
-			map_key_clear(KEY_MICMUTE);
+			map_key_clear(LENOVO_KEY_MICMUTE);
 			return 1;
 		case 10: /* Fn-F7: Control panel */
 			map_key_clear(KEY_CONFIG);
-- 
2.30.2



