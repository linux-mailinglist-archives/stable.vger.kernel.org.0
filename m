Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856822761C3
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 22:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgIWUPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 16:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgIWUPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 16:15:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBD0C0613CE;
        Wed, 23 Sep 2020 13:15:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q4so296604pjh.5;
        Wed, 23 Sep 2020 13:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QHdstSLUKH76sMyWa2m87Ct/MdzoYpURghBvlywnnVg=;
        b=N+F4MP+I0W4WxjiL5rypYRKDpCQYmRD/8d9bLUMiHNTNPww38of1WBzVlebI0Qhlo7
         QTFhtHR1zTaKfOBy6BTMCD7wUfGOaaR4RIW6oB0TOfcIyWIN+vrEEYHEpjnu0jwRcDmr
         ji79gqf1QyyMG0KBL/6h5AyGzKhbORoxxFRxXafQkxoTtWzq5ibFl/afj/JywQX5Lo9q
         aF6IoZ9N5GLK7rAPRkPZhpyX2PClY5BYyb3Pcj1mzDPfswcmwIlwo5Q9ExnZCc3xosmh
         7QgrpwDWprA5nN9FpzrTbF+rRZa5ZoRdhuOl+SpX2ZeKMT3kGiUF6sksyN11ImN5TLCC
         t2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QHdstSLUKH76sMyWa2m87Ct/MdzoYpURghBvlywnnVg=;
        b=MqJltvGSysJTLn0mm2C1sC5ezeyjOFFnlzscNrz3tDPBZ+TvQ8XdopCfrxlYBslLm3
         MsiZtpj230S8HqdJBoVZOVLo2h8m7XRHK8T36S7QjhGxpciaMzXi/q+1G9TVyg8OSQYf
         CeNeU3Gm48X0LqA0ANCeL0icBokAezgDGRInZuCWZFZq2x8hkPD9k2GhlZzRSPvJIDLI
         aFNeyhYZc5XbY/dhI6558lQksQW0G1tvcw5yCPfpkz3Z+6FAhm/aVjiJiSZXzIZXNNxj
         sMQRmibuypPZ1Q9u60zlrrl0br9KEoUjGaQ4/J+jPxYvWEU5FPETN2hvfgFwR79lj0gs
         8+wA==
X-Gm-Message-State: AOAM531NrZH1hQ/GxPCbbg+K01Lxp54VzuY+8ak/xp7KfBFXV5irtUVY
        08d6jlrpn8YzWfd/AQyy0lVIBUjQbuYI3Q==
X-Google-Smtp-Source: ABdhPJxe1o9o2n6dVUNxirggczcCjDD/zanF8NDm91QKtZWx3AZZdReIdgdxfNso6kbadMsotcbMaA==
X-Received: by 2002:a17:902:b109:b029:d1:e5e7:be53 with SMTP id q9-20020a170902b109b02900d1e5e7be53mr1406994plr.45.1600892109095;
        Wed, 23 Sep 2020 13:15:09 -0700 (PDT)
Received: from US-191-ENG0002.lan (75-164-212-231.ptld.qwest.net. [75.164.212.231])
        by smtp.gmail.com with ESMTPSA id g192sm472621pfb.168.2020.09.23.13.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 13:15:08 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>
Subject: [PATCH] HID: wacom: Avoid entering wacom_wac_pen_report for pad / battery
Date:   Wed, 23 Sep 2020 13:14:56 -0700
Message-Id: <20200923201456.25912-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

It has recently been reported that the "heartbeat" report from devices
like the 2nd-gen Intuos Pro (PTH-460, PTH-660, PTH-860) or the 2nd-gen
Bluetooth-enabled Intuos tablets (CTL-4100WL, CTL-6100WL) can cause the
driver to send a spurious BTN_TOUCH=0 once per second in the middle of
drawing. This can result in broken lines while drawing on Chrome OS.

The source of the issue has been traced back to a change which modified
the driver to only call `wacom_wac_pad_report()` once per report instead
of once per collection. As part of this change, pad-handling code was
removed from `wacom_wac_collection()` under the assumption that the
`WACOM_PEN_FIELD` and `WACOM_TOUCH_FIELD` checks would not be satisfied
when a pad or battery collection was being processed.

To be clear, the macros `WACOM_PAD_FIELD` and `WACOM_PEN_FIELD` do not
currently check exclusive conditions. In fact, most "pad" fields will
also appear to be "pen" fields simply due to their presence inside of
a Digitizer application collection. Because of this, the removal of
the check from `wacom_wac_collection()` just causes pad / battery
collections to instead trigger a call to `wacom_wac_pen_report()`
instead. The pen report function in turn resets the tip switch state
just prior to exiting, resulting in the observed BTN_TOUCH=0 symptom.

To correct this, we restore a version of the `WACOM_PAD_FIELD` check
in `wacom_wac_collection()` and return early. This effectively prevents
pad / battery collections from being reported until the very end of the
report as originally intended.

Fixes: d4b8efeb46d9 ("HID: wacom: generic: Correct pad syncing")
Cc: stable@vger.kernel.org # v4.17+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Tested-by: Ping Cheng <ping.cheng@wacom.com>
---
 drivers/hid/wacom_wac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 1c96809b51c9..b74acbd5997b 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2773,7 +2773,9 @@ static int wacom_wac_collection(struct hid_device *hdev, struct hid_report *repo
 	if (report->type != HID_INPUT_REPORT)
 		return -1;
 
-	if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
+	if (WACOM_PAD_FIELD(field))
+		return 0;
+	else if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
 		wacom_wac_pen_report(hdev, report);
 	else if (WACOM_FINGER_FIELD(field) && wacom->wacom_wac.touch_input)
 		wacom_wac_finger_report(hdev, report);
-- 
2.28.0

