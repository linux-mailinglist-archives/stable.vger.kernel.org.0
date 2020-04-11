Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE82E1A5B86
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgDKXuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgDKXEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2182D21655;
        Sat, 11 Apr 2020 23:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646250;
        bh=+YDiGepaO4y8+wKyEMkFm3lHtg1QfBUwMTS32hogJK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udIX8vtEOGFsCHkyQhObO/Ox209oisBS3OShTSWzVumoVOR0pcGjtVutajIqsn7NV
         XLd/mh5SE5VZTyByV6oCuPIKod8pyHJlHgpoUWCRWrBYsNpMpKAp9NMAfjFz1ifp8w
         ts2lX9U3VivifN5PqFXWTfEVXSIIUt+3N7JqigYg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 018/149] HID: lg-g15: Do not fail the probe when we fail to disable F# emulation
Date:   Sat, 11 Apr 2020 19:01:35 -0400
Message-Id: <20200411230347.22371-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b8a75eaddae9410767c7d95a1c5f3a547aae7b81 ]

By default the G1-G12 keys on the Logitech gaming keyboards send
F1 - F12 when in "generic HID" mode.

The first thing the hid-lg-g15 driver does is disable this behavior.

We have received a bugreport that this does not work when the keyboard
is connected through an Aten KVM switch. Using a gaming keyboard with
a KVM is a bit weird setup, but still we can try to fail a bit more
gracefully here.

On the G510 keyboards the same USB-interface which is used for the gaming
keys is also used for the media-keys. Before this commit we would call
hid_hw_stop() on failure to disable the F# emulation and then exit the
probe method with an error code.

This not only causes us to not handle the gaming-keys, but this also
breaks the media keys which is a regression compared to the situation
when these keyboards where handled by the generic hidinput driver.

This commit changes the error handling to clear the hiddev drvdata
(to disable our .raw_event handler) and then returning from the probe
method with success.

The net result of this is that, when connected through a KVM, things
work as well as they did before the hid-lg-g15 driver was introduced.

Fixes: ad4203f5a243 ("HID: lg-g15: Add support for the G510 keyboards' gaming keys")
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1806321
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-lg-g15.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-lg-g15.c b/drivers/hid/hid-lg-g15.c
index 8a9268a5c66aa..ad4b5412a9f49 100644
--- a/drivers/hid/hid-lg-g15.c
+++ b/drivers/hid/hid-lg-g15.c
@@ -803,8 +803,10 @@ static int lg_g15_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	if (ret < 0) {
-		hid_err(hdev, "Error disabling keyboard emulation for the G-keys\n");
-		goto error_hw_stop;
+		hid_err(hdev, "Error %d disabling keyboard emulation for the G-keys, falling back to generic hid-input driver\n",
+			ret);
+		hid_set_drvdata(hdev, NULL);
+		return 0;
 	}
 
 	/* Get initial brightness levels */
-- 
2.20.1

