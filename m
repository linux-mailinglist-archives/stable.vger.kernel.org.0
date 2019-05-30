Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA932EEE8
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbfE3Du6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732050AbfE3DTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:51 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C631248E3;
        Thu, 30 May 2019 03:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186390;
        bh=m8QEM/pFxCfxTcHSKNahObBFJDwpB5U9Z7VT3abzRP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvqr2LqEfjg072xKSPqQ3ns8k48hr3QTxybWikBFlX8vQeG1fubZkSR/k7kmEyXAp
         aA+PltccC0IRHoONHTV6ocoydnioayBY+gzx5VDRsmAUoGl2+h7kuVkqHfvbgX88LX
         tNToXhJzQzQF03t3i6INX2ZzeNmaiObYnMpaFdWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 161/193] HID: logitech-hidpp: change low battery level threshold from 31 to 30 percent
Date:   Wed, 29 May 2019 20:06:55 -0700
Message-Id: <20190530030510.483197958@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1f87b0cd32b3456d7efdfb017fcf74d0bfe3ec29 ]

According to hidpp20_batterylevel_get_battery_info my Logitech K270
keyboard reports only 2 battery levels. This matches with what I've seen
after testing with batteries at varying level of fullness, it always
reports either 5% or 30%.

Windows reports "battery good" for the 30% level. I've captured an USB
trace of Windows reading the battery and it is getting the same info
as the Linux hidpp code gets.

Now that Linux handles these devices as hidpp devices, it reports the
battery as being low as it treats anything under 31% as low, this leads
to the user constantly getting a "Keyboard battery is low" warning from
GNOME3, which is very annoying.

This commit fixes this by changing the low threshold to anything under
30%, which I assume is what Windows does.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index d209b12057d59..b705cbb58ca6b 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -910,7 +910,11 @@ static int hidpp_map_battery_level(int capacity)
 {
 	if (capacity < 11)
 		return POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL;
-	else if (capacity < 31)
+	/*
+	 * The spec says this should be < 31 but some devices report 30
+	 * with brand new batteries and Windows reports 30 as "Good".
+	 */
+	else if (capacity < 30)
 		return POWER_SUPPLY_CAPACITY_LEVEL_LOW;
 	else if (capacity < 81)
 		return POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
-- 
2.20.1



