Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9566A3A9FBF
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbhFPPlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235119AbhFPPiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:38:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBF24613DC;
        Wed, 16 Jun 2021 15:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857785;
        bh=h0rZ5FQAxT8ND2ifY7DwPtVHKTPACvufXoWIOr2YVnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDXOA7Vmz/Ff84vVZprSn/4yc8je1DgovnTNiUh7ykrcaI36wbTxHa3c2DsDyFveN
         wM7ALVmX1dLFANWoeybpemWNOlmAmM8KcjMOQmFq8SZcBRbEJCmqtgBaM1DkW+fo7A
         daEf3Fga+9movBlA2ZeFaNi9LVYF6Uhf0NkaGdK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= 
        <nabijaczleweli@nabijaczleweli.xyz>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/38] HID: multitouch: set Stylus suffix for Stylus-application devices, too
Date:   Wed, 16 Jun 2021 17:33:16 +0200
Message-Id: <20210616152835.637808448@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8580ace596c2..e5a3704b9fe8 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1580,13 +1580,13 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
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



