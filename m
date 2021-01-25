Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106C03031D6
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbhAYSmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:42:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbhAYSmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC955224B8;
        Mon, 25 Jan 2021 18:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600061;
        bh=KGpDxYJ+g6L/VPqmi7zokT5Xz6lfTzBbY1R8MRG1KoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pztYr3Vxx1J4CQ4HKBmHQbzFNYkh7nj7w4ug4vIne2d8x1mGH7VmB0p2q5JFNV6ak
         1dj48QjB4R3jfnT07+w7ef1dpi12lU/VhrXqRN58txWJmLG/52wkqP/Tx5vCIY2OP3
         C3G4RSdhW6Q+IjHiGaLho+i4/4BZkPBlnNj6c16E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Miller <miller.seth@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/58] HID: Ignore battery for Elan touchscreen on ASUS UX550
Date:   Mon, 25 Jan 2021 19:39:17 +0100
Message-Id: <20210125183157.393443096@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Miller <miller.seth@gmail.com>

[ Upstream commit 7c38e769d5c508939ce5dc26df72602f3c902342 ]

Battery status is being reported for the Elan touchscreen on ASUS
UX550 laptops despite not having a batter. It always shows either 0 or
1%.

Signed-off-by: Seth Miller <miller.seth@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6d118da1615d4..ab2be7a115d8f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -386,6 +386,7 @@
 #define USB_DEVICE_ID_TOSHIBA_CLICK_L9W	0x0401
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
+#define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 13deb9a676855..4dd151b2924e2 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -334,6 +334,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_DINOVO_EDGE_KBD),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.27.0



