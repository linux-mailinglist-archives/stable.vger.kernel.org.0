Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338F939E1DE
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhFGQOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231501AbhFGQOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C68161164;
        Mon,  7 Jun 2021 16:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082348;
        bh=d4znzlFVx6omnBiBjAP1ebkOWS1zIqk3ORDHiWjqT8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JKpRralPSq6o2sxJR4AANd8Vux1rpDc4qrqu99r7wSbbucPD/WgBTB2NM/cvW810/
         aEa1SUTYx+mm6/6VVLyH0aoaWU0eEctlkCU6CmCAzQo3SvCRK3DW9w1/RwtSfWePRU
         hZZspUTqGEgK6AIYhJGy4SAoHOBUSDth7G1UDM3YydEy1NC6kXxf1P/8p/zyxYCslH
         UK5LHDMFRKMumbJt5TLiAdFBPODJVZ5vMP1tMt/wODIPjOIRdhJTfXIfxMU0g4SiDO
         4MMQg+4q6bATfWqNiEq5wkSjA3I9kEl399ksoBZHNQtTX8HKASP+KQKGywo/ppWK3F
         B7vxS28kCdzHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= 
        <nabijaczleweli@nabijaczleweli.xyz>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 10/49] HID: multitouch: set Stylus suffix for Stylus-application devices, too
Date:   Mon,  7 Jun 2021 12:11:36 -0400
Message-Id: <20210607161215.3583176-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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
index 9d9f3e1bd5f4..ae1fee9d7474 100644
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

