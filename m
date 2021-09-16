Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3C940E682
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346921AbhIPRWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351940AbhIPRUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8190D61139;
        Thu, 16 Sep 2021 16:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810513;
        bh=W5i60Y4QgjuME9OVVg9F7XwbHir4B+GwL357gXa7670=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8B1OWRSBX0lsJb+HUx8KwT4AxL1dI9HPW9EQxacvRPI8NCEOtn3uEX1aOL8IMLn/
         tpQEdKdqZ00Kl9U7XqZlAa5nLaLxCfemjirvBX6KfPQq30G3b6W2vycF8pF7UByZvV
         /d3HRUxHhtLOstzg+WkwGvH3FhH5CdutA9TU5+7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Broadus <jbroadus@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 126/432] HID: i2c-hid: Fix Elan touchpad regression
Date:   Thu, 16 Sep 2021 17:57:55 +0200
Message-Id: <20210916155815.026708907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Broadus <jbroadus@gmail.com>

[ Upstream commit 786537063bbfb3a7ebc6fc21b2baf37fb91df401 ]

A quirk was recently added for Elan devices that has same device match
as an entry earlier in the list. The i2c_hid_lookup_quirk function will
always return the last match in the list, so the new entry shadows the
old entry. The quirk in the previous entry, I2C_HID_QUIRK_BOGUS_IRQ,
silenced a flood of messages which have reappeared in the 5.13 kernel.

This change moves the two quirk flags into the same entry.

Fixes: ca66a6770bd9 (HID: i2c-hid: Skip ELAN power-on command after reset)
Signed-off-by: Jim Broadus <jbroadus@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 46474612e73c..517141138b00 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -171,8 +171,6 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ I2C_VENDOR_ID_RAYDIUM, I2C_PRODUCT_ID_RAYDIUM_3118,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
-	{ USB_VENDOR_ID_ELAN, HID_ANY_ID,
-		 I2C_HID_QUIRK_BOGUS_IRQ },
 	{ USB_VENDOR_ID_ALPS_JP, HID_ANY_ID,
 		 I2C_HID_QUIRK_RESET_ON_RESUME },
 	{ I2C_VENDOR_ID_SYNAPTICS, I2C_PRODUCT_ID_SYNAPTICS_SYNA2393,
@@ -183,7 +181,8 @@ static const struct i2c_hid_quirks {
 	 * Sending the wakeup after reset actually break ELAN touchscreen controller
 	 */
 	{ USB_VENDOR_ID_ELAN, HID_ANY_ID,
-		 I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET },
+		 I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET |
+		 I2C_HID_QUIRK_BOGUS_IRQ },
 	{ 0, 0 }
 };
 
-- 
2.30.2



