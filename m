Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0375E12F01F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgABWZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729385AbgABWZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:25:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98F3E21835;
        Thu,  2 Jan 2020 22:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003930;
        bh=42svHtPePhZ3NPfCRd1BuRx+WDO2c67EMHgqhIkSdes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQ3jQ3wUJPonTepyQlCzrxnNG/uTfRQ2rpCj3PM2yen29CxageVGrHKqtmjHAMRhq
         tZSA+l9VSSzzrEXk3OWD/VmQ3Mgzh2yIxQ42ZehQBgprbQlrqvGBnf1DMwBuR4fcsD
         rtJSqtaET6xsavn8qWDrFNysdBWrw6JTLrFKwZjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/91] HID: logitech-hidpp: Silence intermittent get_battery_capacity errors
Date:   Thu,  2 Jan 2020 23:07:15 +0100
Message-Id: <20200102220431.637952568@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 61005d65b6c7dcf61c19516e6ebe5acc02d2cdda ]

My Logitech M185 (PID:4038) 2.4 GHz wireless HID++ mouse is causing
intermittent errors like these in the log:

[11091.034857] logitech-hidpp-device 0003:046D:4038.0006: hidpp20_batterylevel_get_battery_capacity: received protocol error 0x09
[12388.031260] logitech-hidpp-device 0003:046D:4038.0006: hidpp20_batterylevel_get_battery_capacity: received protocol error 0x09
[16613.718543] logitech-hidpp-device 0003:046D:4038.0006: hidpp20_batterylevel_get_battery_capacity: received protocol error 0x09
[23529.938728] logitech-hidpp-device 0003:046D:4038.0006: hidpp20_batterylevel_get_battery_capacity: received protocol error 0x09

We are already silencing error-code 0x09 (HIDPP_ERROR_RESOURCE_ERROR)
errors in other places, lets do the same in
hidpp20_batterylevel_get_battery_capacity to remove these harmless,
but scary looking errors from the dmesg output.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 4706fb852eaf..6ad776b4711b 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -978,6 +978,9 @@ static int hidpp20_batterylevel_get_battery_capacity(struct hidpp_device *hidpp,
 	ret = hidpp_send_fap_command_sync(hidpp, feature_index,
 					  CMD_BATTERY_LEVEL_STATUS_GET_BATTERY_LEVEL_STATUS,
 					  NULL, 0, &response);
+	/* Ignore these intermittent errors */
+	if (ret == HIDPP_ERROR_RESOURCE_ERROR)
+		return -EIO;
 	if (ret > 0) {
 		hid_err(hidpp->hid_dev, "%s: received protocol error 0x%02x\n",
 			__func__, ret);
-- 
2.20.1



