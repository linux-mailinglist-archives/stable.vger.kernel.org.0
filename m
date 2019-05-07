Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3194916ABB
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 20:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfEGSx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 14:53:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43809 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfEGSx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 14:53:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id t22so8742693pgi.10;
        Tue, 07 May 2019 11:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jUaBkZMmmgzmMzkoqnX0MUxDUlbVz2UyMtd0YFW6+18=;
        b=UuhxinJeldM2AmFH7ttf7DKC6TMUIiS2KSfnaOJeydjXmrxgYRRqU6AIP94CM0sJkx
         3qcyrzQbDLhDn8J75ZMNr2n8OHehBAX/EtzXA7/XmIh4AYm/7zdSe+yHNG4RnBJt3XXI
         /9wz67WCLkPlepJ6O4Q7RNDfe4v5hK/is2gz8r+VFkmT+6WHkhxZxH8rxtzEPjk9qsqZ
         JsDLIe6QwqVfCeYXOGgaaxwBxMRGULnU6M1DS/3yK792BwgkZ1jGZ5abmPVDaBY1ZUjx
         u8Zw67R0T1f9WiSSwpwyKvLEQkKeoHVeKtLr8CBwYw2Ykf7/I2mCxVFwmh0PcixuZO0T
         iiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jUaBkZMmmgzmMzkoqnX0MUxDUlbVz2UyMtd0YFW6+18=;
        b=rwuIf0a1Q2SnGPaXTrwvGCG+VHUd01d3aQ9rBm2i1RVxcKPuEDxnHXYilp1MXgm2tD
         oV6UhzvE3GTOvxZIb8X4i/2x0ucZlGKNnXSyX8N1yNjUX3GPSKhwdPJ/yIrnodVxvpUE
         TaO0YRv+jCE7Gq2ONJlOaGj4U3cFmvLN6fpbWiBxFPKD3eDSCAkSGmTAkMILJMwoumyC
         5P7X6Yk2Q8CtWfd1gWpCqRTDrdNG3miPLULfRhde9S1nD267TrR/2eOD2dg+axjvpp+V
         uU+vWTMYO4pz98Wt5z/0130sMpPCCBnx4f6LaA5l0NROj79+92KX8nTp2isVM6UsIXDY
         hgOw==
X-Gm-Message-State: APjAAAWNohuCTGG02b7gm6HDy0yyhyeJCE2ZUhckMGBi00aoZh5DZX/D
        qQiucVbsPCThI8zMTgZQlFCsrpFz
X-Google-Smtp-Source: APXvYqwVJ3LKvrvvPRf6CLCjA5OphFg28CtI0o+nKR65H+uuWq7w8G3y34eNGkDZxDPPrNnt/fOv5A==
X-Received: by 2002:aa7:8a53:: with SMTP id n19mr42287003pfa.11.1557255206197;
        Tue, 07 May 2019 11:53:26 -0700 (PDT)
Received: from US-191-ENG0002.corp.onewacom.com ([50.225.60.4])
        by smtp.gmail.com with ESMTPSA id w189sm20085506pfw.147.2019.05.07.11.53.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 11:53:25 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Aaron Skomra <aaron.skomra@wacom.com>
Subject: [PATCH 1/3] HID: wacom: Send BTN_TOUCH in response to INTUOSP2_BT eraser contact
Date:   Tue,  7 May 2019 11:53:20 -0700
Message-Id: <20190507185322.7168-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

The Bluetooth reports from the 2nd-gen Intuos Pro have separate bits for
indicating if the tip or eraser is in contact with the tablet. At the
moment, only the tip contact bit controls the state of the BTN_TOUCH
event. This prevents the eraser from working as expected. This commit
changes the driver to send BTN_TOUCH whenever either the tip or eraser
contact bit is set.

Fixes: 4922cd26f0 ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Skomra <aaron.skomra@wacom.com>
---
 drivers/hid/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 613342bb9d6b..af62a630fee9 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1301,7 +1301,7 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_wac *wacom)
 						 range ? frame[7] : wacom->features.distance_max);
 			}
 
-			input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
+			input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x09);
 			input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
 			input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
 
-- 
2.21.0

