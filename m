Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F83494B4
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 00:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfFQWB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 18:01:27 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45175 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfFQWB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 18:01:27 -0400
Received: by mail-pl1-f194.google.com with SMTP id bi6so4721759plb.12
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 15:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T7/yq0d78zogetd0afkWHfGkUbTrLzheDFpzSQns2K0=;
        b=A3iPWBjWRJDf68EQK4ncGF3+nPQ6OIlcyy6jzyfIItjbSqaWaRZPJ16ZoHB2N+/tHO
         MQ4uNDr4ssjFRcAbVLaSojjTUecRU9WepsIcK7A0QBMPJNxZ+6lMJn5mJ6s8ybYux/Q9
         fxK3DVjSz0eOACNK5gHAnvB2tLAONPMJ0s/meiHGdx5x3EVdqeQaw2SFLwwmO0Ex/tyd
         THILOR1uCnbZNxy7fzrZYDB0wWIfbdWRBd4e3bpagncIqtO1vZCGse0e0P5a1UJ+ouRL
         BSAn0i7tdQkdZ0mEnl3Qv4aNAzLm2LY1YCNI84Iw/jmMgU8jZIam5LnisvGVkGkAgpIX
         x4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T7/yq0d78zogetd0afkWHfGkUbTrLzheDFpzSQns2K0=;
        b=mtayp9Z7kC2F3/rxieT0+Rj6npLkk+Zg6/S5Cj/PKLeQpQXBuZhP8da715mNlqvWuc
         RHWyWbq+vEdIAOO3hQ273nRnJe2KC3ULSukFTMhRVGxnQO10/DXSsg8XwpxYBcX5RAzb
         Qxu+DhsUeTZe004Xwd8OpwqN9oFoucNbOHB41bIJHogxcl2zNsY+Kdyy2Jv+BxIqc1aA
         xwQWx0YPhHMnqtYlZhtCFivGr4G22gfXqyNHe7D1s+m6CMOvnGNZytA3m06h5VwnyPK4
         ObHS9QMFptpds/LG8aJ1ReBkADGBXyg+fxpQNVFeHQJzri2ze8AVhn0v8iUim0bWzN94
         kJwA==
X-Gm-Message-State: APjAAAVNCse2Bc6p9RoEMZCMMm059SwD7iA9NZbHQl6vJUFdNWiLepg0
        7rZ3ZN0a7LDmCtrQw4TPIkQLp2ep
X-Google-Smtp-Source: APXvYqwBX5ych8OP94hNXwgIx2Jjpb78n46pBDfMqo/GsaSM7dhhU3MUBFDCPY/Thx0iVc7nmgYFhQ==
X-Received: by 2002:a17:902:bd94:: with SMTP id q20mr24081056pls.307.1560808885881;
        Mon, 17 Jun 2019 15:01:25 -0700 (PDT)
Received: from US-191-ENG0002.corp.onewacom.com ([50.225.60.4])
        by smtp.gmail.com with ESMTPSA id j16sm250968pjz.31.2019.06.17.15.01.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 15:01:25 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     stable@vger.kernel.org
Cc:     Aaron Armstrong Skomra <skomra@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Skomra <aaron.skomra@wacom.com>
Subject: [PATCH 3/3] HID: wacom: Send BTN_TOUCH in response to INTUOSP2_BT eraser contact
Date:   Mon, 17 Jun 2019 15:01:22 -0700
Message-Id: <20190617220122.13600-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <1560612702110252@kroah.com>
References: <1560612702110252@kroah.com>
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

Fixes: 4922cd26f03c ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Skomra <aaron.skomra@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
Original commit in Linus' tree: fe7f8d73d1af19b678171170e4e5384deb57833d

 drivers/hid/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 274867227d50..b42bb955f22d 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1275,7 +1275,7 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_wac *wacom)
 			input_report_abs(pen_input, ABS_PRESSURE, get_unaligned_le16(&frame[5]));
 			input_report_abs(pen_input, ABS_DISTANCE, range ? frame[13] : wacom->features.distance_max);
 
-			input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
+			input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x09);
 			input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
 			input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
 
-- 
2.22.0

