Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31BE61863E
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 18:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiKCRdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 13:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiKCRdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 13:33:32 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C63BF68;
        Thu,  3 Nov 2022 10:33:30 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id q9so7372777ejd.0;
        Thu, 03 Nov 2022 10:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E1KPnHOoHgunNf2Z2nlvgRnG5EDripdp4eLkNsH8GUM=;
        b=VaLzOp4kKnmHrAshzTXuWR1JAztmWi3xAwAnenqOLjgRseNLpcC2BcBsI9O/sjnwKJ
         KzYNO0TosFBCKqzvkRMyr3ZUsbWF/ErpMFMSlM6Qfa3YRA+WwWJpbEwHRklaXba4xGsm
         SUrDSsHIPZJ9a/gShpELnYm1+bRvxsg7kaqzDv+yxAtwA5+0i0KP9Tyh1R8ZxHVtKj6A
         J6mETPD6Bu5kBp/ZFPBYlZ9b042BQxxtAYwGUePOt26YudWHgy/Ephk9IbPc0dVx/3hu
         bsAqo23HhnY7VqPgkssUJo7cypTRp3s6f4VH0I0KWJsnDxfSy+JFOun8P+l8BuAB+Z0V
         8u4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E1KPnHOoHgunNf2Z2nlvgRnG5EDripdp4eLkNsH8GUM=;
        b=hgldsPzYH5FMVG1HCTu9S11ACwLUQG3bq9CJBKz8H3UzmEYwvlgFGtEvXGAk6mPDBQ
         7PQrsRVmPgmvq3WVpAiZnbjBO3Vi349BgpcA+oHwPfLiLol/dX+/L7D0JpxhZoqxeVpl
         +TDifWWgsjr1zCfUReDQx3YMOHNbc9SDdeLDZRivZ9y2/jOOEBZjEyDZMmb/MfN3miOG
         ljNWEoocWX71ir0LuyUonXgh+UY7jeiwD/ZqFJW69NyjJvSGEwClT+bNp/7soK0af8Wd
         oJKITRwB54HuswGIMdmxydL7BB3cxzjIJ3hjSGjJ3JPo6Ss6HYB5eBoAoMDpAIMNTRNb
         +RTw==
X-Gm-Message-State: ACrzQf0j5+PcIpPM1wsSbmqUD/jq5VXvZL86LW9He7ztoloWRDonxWyl
        FUeliqs7JbQRVlWsyQ23jrGewhlnI7c=
X-Google-Smtp-Source: AMsMyM5kEQmCcVa4zZU4TVWPKSRkPdgKG+8viUGxjh75voccKbl6TwZm1LQFEkomx7YlPkLjod5+yQ==
X-Received: by 2002:a17:907:25c9:b0:77b:a343:bd62 with SMTP id ae9-20020a17090725c900b0077ba343bd62mr31921182ejc.660.1667496808370;
        Thu, 03 Nov 2022 10:33:28 -0700 (PDT)
Received: from localhost.localdomain (71-34-90-11.ptld.qwest.net. [71.34.90.11])
        by smtp.gmail.com with ESMTPSA id y18-20020a056402135200b0045b3853c4b7sm768063edw.51.2022.11.03.10.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 10:33:27 -0700 (PDT)
From:   Jason Gerecke <killertofu@gmail.com>
X-Google-Original-From: Jason Gerecke <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>
Cc:     Jason Gerecke <killertofu@gmail.com>, stable@vger.kernel.org,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Joshua Dickens <joshua.dickens@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>
Subject: [PATCH] HID: wacom: Fix logic used for 3rd barrel switch emulation
Date:   Thu,  3 Nov 2022 10:33:04 -0700
Message-Id: <20221103173304.128651-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

When support was added for devices using an explicit 3rd barrel switch,
the logic used by devices emulating this feature was broken. The 'if'
statement / block that was introduced only handles the case where the
button is pressed (i.e. 'barrelswitch' and 'barrelswitch2' are both set)
but not the case where it is released (i.e. one or both being cleared).
This results in a BTN_STYLUS3 "down" event being sent when the button
is pressed, but no "up" event ever being sent afterwards.

This patch restores the previously-used logic for determining button
states in the emulated case so that switches are reported correctly
again.

Link: https://github.com/linuxwacom/xf86-input-wacom/issues/292
Fixes: 6d09085b38e5 ("HID: wacom: Adding Support for new usages")
CC: stable@vger.kernel.org #v5.19+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Joshua Dickens <joshua.dickens@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
---
 drivers/hid/wacom_wac.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 77486962a773f..0f3d57b426846 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2520,11 +2520,12 @@ static void wacom_wac_pen_report(struct hid_device *hdev,
 
 	if (!delay_pen_events(wacom_wac) && wacom_wac->tool[0]) {
 		int id = wacom_wac->id[0];
-		if (wacom_wac->features.quirks & WACOM_QUIRK_PEN_BUTTON3 &&
-		    wacom_wac->hid_data.barrelswitch & wacom_wac->hid_data.barrelswitch2) {
-			wacom_wac->hid_data.barrelswitch = 0;
-			wacom_wac->hid_data.barrelswitch2 = 0;
-			wacom_wac->hid_data.barrelswitch3 = 1;
+		if (wacom_wac->features.quirks & WACOM_QUIRK_PEN_BUTTON3) {
+			int sw_state = wacom_wac->hid_data.barrelswitch |
+				       (wacom_wac->hid_data.barrelswitch2 << 1);
+			wacom_wac->hid_data.barrelswitch = sw_state == 1;
+			wacom_wac->hid_data.barrelswitch2 = sw_state == 2;
+			wacom_wac->hid_data.barrelswitch3 = sw_state == 3;
 		}
 		input_report_key(input, BTN_STYLUS, wacom_wac->hid_data.barrelswitch);
 		input_report_key(input, BTN_STYLUS2, wacom_wac->hid_data.barrelswitch2);
-- 
2.38.1

