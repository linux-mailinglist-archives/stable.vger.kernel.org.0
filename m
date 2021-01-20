Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A502FC981
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbhATC2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729855AbhATB1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:27:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22E332332A;
        Wed, 20 Jan 2021 01:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105985;
        bh=LvVRTh7MSvbssqT4SZy33+D8NrWxVC7FKb7pFdKc0Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBU6j2BY1YcTjnOrAEWoZ9Si7fYxst0gLkeq44PZ1y/DdDMIlX7r2R3cV6Ibj5YPH
         SiJRauTzXmKN9PWdJhavusbiWRv4pmeB7X4LjtrSeoXsWfu6/wrmEJfj8/FzP4/dpY
         MaFIDpL6nlcmJOMIUC55+qnk+S2/z/mT9BOvZEo9BjMlMllxRlN1jjP6ubMmr/sJqr
         0T3n9P+RJTjE3FOnvyIqVMrMQ6q5/CwxU6G955/57C8+kCs9xYBwizTQmjxhRRxv51
         KpHglyhP/63qC832sRopmPCwRkd+SI+M/cwGNhwzftT1f6LIsQv34EeqhDbByGfmYA
         YkNAWCX41wJ/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seth Miller <miller.seth@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/45] HID: Ignore battery for Elan touchscreen on ASUS UX550
Date:   Tue, 19 Jan 2021 20:25:35 -0500
Message-Id: <20210120012602.769683-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f170feaac40ba..94180c63571ed 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -387,6 +387,7 @@
 #define USB_DEVICE_ID_TOSHIBA_CLICK_L9W	0x0401
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
+#define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 4dca113924593..32024905fd70f 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -322,6 +322,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_DINOVO_EDGE_KBD),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.27.0

