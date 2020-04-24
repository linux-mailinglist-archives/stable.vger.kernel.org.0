Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3731B817A
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 23:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgDXVEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 17:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgDXVEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 17:04:10 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD83C09B048;
        Fri, 24 Apr 2020 14:04:10 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e6so4383234pjt.4;
        Fri, 24 Apr 2020 14:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=my9WIJzbfGPiw3LcnJ3GOWfoHKAi2Ht/L1aHQMYhTVQ=;
        b=ZpXaYcAnolhAEdYwKx/a52J9rtRV2kT9qlf2WOTgwviD+9ZWAO5A/UMByhZTA49JxR
         OPCWsL4bhMWOJRx9XhR3NE19UrobFVTmv0Y4Roce+0s+BBaTr61HXpiCFJ0ueSdjX2Qw
         ddAvrBVQF1kp0e6/9jMMq0+JEM6LcFOlK33UMR4ZllJV1z0ScCFu8a36BSFKCXHRfxiq
         L6yaefwFx6n+9VPsTTTEZ1O+fLulyD+fDVKG17D/BxZeCkFJ9Dlu76RRYAY68/IbsHmV
         mkahJrKidKG7k0BPywL3oDJ9ysriUUzUEF0IQ8OP4OVsSSjDtlDFdMxyITufzKcyXYDx
         QKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=my9WIJzbfGPiw3LcnJ3GOWfoHKAi2Ht/L1aHQMYhTVQ=;
        b=q34zy7kIK39E/nxpSorfxZeX5hRPBShHQtgPVMyQ+uH844QzrHnM/SAjZ9fqH1SnTl
         WeGsQJPBtFN+Z5JtwNFNbJ1DBlpCsrw22PkC33vkDkSHZ17haTHqLZT9n6LJRga/7SqM
         1g8T5MJR/8pfhsMTmiZWVccU/sNRvSq+R0vS3vXyKrOjbEmeu/kzM+C8LtwLfNfog5E9
         9dYXLIiOleqr8dl5WO/6505BTEpW9jlHEA8yxdLajvaSrUvkcrwofuTa7zdesET/eZZI
         F0c0JXzYWv+bUF5hAGbME2Jx0ptYnyv+rCDRhGYz/FH9QJ/nolg2mu7r0OsZ3h4n94Pf
         Pq7w==
X-Gm-Message-State: AGi0PuaLSzWtiFdNAlarywTirget0jpdIq2o0JkugZe9KyuN8sFuVbyB
        4MJ9N8KEWJswRa/PczBS/1+mwqobBgo=
X-Google-Smtp-Source: APiQypLoWzf1Wq6kuLkuOfcFIYxYdpTEFCKwpyX2xl55kx6r1U0QuHo8rdKCg4F7lpEHOuP4YG4aHQ==
X-Received: by 2002:a17:90a:2709:: with SMTP id o9mr8477830pje.168.1587762249973;
        Fri, 24 Apr 2020 14:04:09 -0700 (PDT)
Received: from horus.lan (75-164-176-226.ptld.qwest.net. [75.164.176.226])
        by smtp.gmail.com with ESMTPSA id m4sm6506870pfm.26.2020.04.24.14.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 14:04:09 -0700 (PDT)
From:   Jason Gerecke <killertofu@gmail.com>
X-Google-Original-From: Jason Gerecke <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: [PATCH] HID: wacom: Report 2nd-gen Intuos Pro S center button status over BT
Date:   Fri, 24 Apr 2020 14:04:00 -0700
Message-Id: <20200424210400.220712-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The state of the center button was not reported to userspace for the
2nd-gen Intuos Pro S when used over Bluetooth due to the pad handling
code not being updated to support its reduced number of buttons. This
patch uses the actual number of buttons present on the tablet to
assemble a button state bitmap.

Link: https://github.com/linuxwacom/xf86-input-wacom/issues/112
Fixes: cd47de45b855 ("HID: wacom: Add 2nd gen Intuos Pro Small support")
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Cc: stable@vger.kernel.org # v5.3+
---
 drivers/hid/wacom_wac.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 96d00eba99c0..1c96809b51c9 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1427,11 +1427,13 @@ static void wacom_intuos_pro2_bt_pad(struct wacom_wac *wacom)
 {
 	struct input_dev *pad_input = wacom->pad_input;
 	unsigned char *data = wacom->data;
+	int nbuttons = wacom->features.numbered_buttons;
 
-	int buttons = data[282] | ((data[281] & 0x40) << 2);
+	int expresskeys = data[282];
+	int center = (data[281] & 0x40) >> 6;
 	int ring = data[285] & 0x7F;
 	bool ringstatus = data[285] & 0x80;
-	bool prox = buttons || ringstatus;
+	bool prox = expresskeys || center || ringstatus;
 
 	/* Fix touchring data: userspace expects 0 at left and increasing clockwise */
 	ring = 71 - ring;
@@ -1439,7 +1441,8 @@ static void wacom_intuos_pro2_bt_pad(struct wacom_wac *wacom)
 	if (ring > 71)
 		ring -= 72;
 
-	wacom_report_numbered_buttons(pad_input, 9, buttons);
+	wacom_report_numbered_buttons(pad_input, nbuttons,
+                                      expresskeys | (center << (nbuttons - 1)));
 
 	input_report_abs(pad_input, ABS_WHEEL, ringstatus ? ring : 0);
 
-- 
2.26.2

