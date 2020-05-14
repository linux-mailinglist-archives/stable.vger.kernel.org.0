Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4711D3BBE
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgENSyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbgENSyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:54:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE80420727;
        Thu, 14 May 2020 18:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482460;
        bh=gPckmIztXfjJbXxBAWfzP6ZcwI6+w9im8apwVVJjJn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRvDZQv5CPndKeZaMmsr7AFIImCEH4TfNbNo1HqSvIVTeZNFmdr6/QKKP8wM501hd
         OZS2LjhrsAtIBWz5OKPTwdZTRKYl7x4FXctz6A/g74+zo2mO2Oc2bndkaOxALYMX2v
         L7B+65JJr1l/GSMy4Q3b/3Cnng4nBVmuE0Vkdm70=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Kosina <jkosina@suse.cz>,
        Xiaojian Cao <xiaojian.cao@cn.alps.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/31] HID: alps: ALPS_1657 is too specific; use U1_UNICORN_LEGACY instead
Date:   Thu, 14 May 2020 14:53:47 -0400
Message-Id: <20200514185413.20755-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185413.20755-1-sashal@kernel.org>
References: <20200514185413.20755-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit 185af3e775b693f773d9a4b5a8c3cda69fc8ca0f ]

HID_DEVICE_ID_ALPS_1657 PID is too specific, as there are many other
ALPS hardware IDs using this particular touchpad.

Rename the identifier to HID_DEVICE_ID_ALPS_U1_UNICORN_LEGACY in order
to describe reality better.

Fixes: 640e403b1fd24 ("HID: alps: Add AUI1657 device ID")
Reported-by: Xiaojian Cao <xiaojian.cao@cn.alps.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 2 +-
 drivers/hid/hid-ids.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index 28ca21014bbe4..3489f0af7409c 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -806,7 +806,7 @@ static int alps_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		break;
 	case HID_DEVICE_ID_ALPS_U1_DUAL:
 	case HID_DEVICE_ID_ALPS_U1:
-	case HID_DEVICE_ID_ALPS_1657:
+	case HID_DEVICE_ID_ALPS_U1_UNICORN_LEGACY:
 		data->dev_type = U1;
 		break;
 	default:
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 53ac5e1ab4bc5..2a9cec9764cf9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -81,9 +81,9 @@
 #define HID_DEVICE_ID_ALPS_U1_DUAL_PTP	0x121F
 #define HID_DEVICE_ID_ALPS_U1_DUAL_3BTN_PTP	0x1220
 #define HID_DEVICE_ID_ALPS_U1		0x1215
+#define HID_DEVICE_ID_ALPS_U1_UNICORN_LEGACY         0x121E
 #define HID_DEVICE_ID_ALPS_T4_BTNLESS	0x120C
 #define HID_DEVICE_ID_ALPS_1222		0x1222
-#define HID_DEVICE_ID_ALPS_1657         0x121E
 
 #define USB_VENDOR_ID_AMI		0x046b
 #define USB_DEVICE_ID_AMI_VIRT_KEYBOARD_AND_MOUSE	0xff10
-- 
2.20.1

