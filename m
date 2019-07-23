Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E31671EC0
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 20:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfGWSKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 14:10:34 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34797 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfGWSKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 14:10:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id i2so20932799plt.1;
        Tue, 23 Jul 2019 11:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tBbo4tD/EfQZIb0OHJzVaSxphzmHc6dwWWautlRMxRs=;
        b=GgFygDlryFvJ1TP2zYD3kKT0Hqb9WnyVfk+PZJTVVWTaZVcWxEQQKe7fuf0l39K3Mc
         vBpvG82NlgxLVJHFSLVqDaVZkKlBPe0dWC2w1PCdGSAyjDGq+qCl7MPWc2iwUxWKkPXv
         22k0YoZXzhYxwvxlRxTEkxFdkzZDP5D9dC10laYH/SF1R+gnctCPJifbMkSjV1ET6JKD
         Gt/ZMMAabUBAIVg/5mky8mjbOhrCPSf1Y8irsoGXzU53vgjc1m7HTALH/7jrUMRkJVa0
         6edNkTDMr6T110G49dJb5t1AKYew7fcTQJS7Pr/3+lsJ5qYtb5+yXAJ5c3dxIxQDkvuS
         QaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tBbo4tD/EfQZIb0OHJzVaSxphzmHc6dwWWautlRMxRs=;
        b=o7sq5lB6omh7nb4LF7ITMVv5ESgCV7qvEqcH/fRHMxz6EWSUyhf/GkldMERZSRSo0G
         MPiGjfkCoA2NQYMPUQ0VTFsgB7Np2xtain37E0XqHbBWcxOMv60lcP50vdg2nQMCY9ec
         DK2PkBinbdZ5oyaD2GSt9gMa8XCLNrwp3gP3s/xfyBytnAaA3TcTNN9DigOnHLjvhg12
         i93VqAA1If9UWJL2MeaoMOrbGl0Oos//XGjisf8op6KgyNGY8iIebPIkoY3vfw3Fekm5
         skB+C996UcqrtFcmNHjiPu0+42ehi1onBjplf+b3B5RJ7X6zkCnjzscySd5JFu53qJAV
         6E/Q==
X-Gm-Message-State: APjAAAUwuDKDw48ADUfoysgLbiWKcVzzcdWgecoRFNba4lLbWLNz//yQ
        HkDBhE/Of2Xyvl2RlyQ+Da2DJ87m
X-Google-Smtp-Source: APXvYqznj4znI1d7CNLJDqyZqfIeF9ODIst1WjbLJUdHa5SdIeJ3NhxyRGEsW1aZ6t2YUm03PWwGWg==
X-Received: by 2002:a17:902:6a85:: with SMTP id n5mr76219283plk.73.1563905433106;
        Tue, 23 Jul 2019 11:10:33 -0700 (PDT)
Received: from west.Home ([97.115.133.135])
        by smtp.googlemail.com with ESMTPSA id o35sm32983585pgm.29.2019.07.23.11.10.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Jul 2019 11:10:32 -0700 (PDT)
From:   Aaron Armstrong Skomra <skomra@gmail.com>
X-Google-Original-From: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
To:     linux-input@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com, pinglinux@gmail.com,
        jason.gerecke@wacom.com
Cc:     Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 5+" <stable@vger.kernel.org>
Subject: [PATCH] HID: wacom: fix bit shift for Cintiq Companion 2
Date:   Tue, 23 Jul 2019 11:09:15 -0700
Message-Id: <1563905355-20921-1-git-send-email-aaron.skomra@wacom.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bit indicating BTN_6 on this device is overshifted
by 2 bits, resulting in the incorrect button being
reported.

Also fix copy-paste mistake in comments.

Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Link: https://github.com/linuxwacom/xf86-input-wacom/issues/71
Fixes: c7f0522a1ad1 ("HID: wacom: Slim down wacom_intuos_pad processing")
Cc: <stable@vger.kernel.org> # v4.5+
---
 drivers/hid/wacom_wac.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 8fc36a28081b..7a8ddc999a8e 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -533,14 +533,14 @@ static int wacom_intuos_pad(struct wacom_wac *wacom)
 		 */
 		buttons = (data[4] << 1) | (data[3] & 0x01);
 	} else if (features->type == CINTIQ_COMPANION_2) {
-		/* d-pad right  -> data[4] & 0x10
-		 * d-pad up     -> data[4] & 0x20
-		 * d-pad left   -> data[4] & 0x40
-		 * d-pad down   -> data[4] & 0x80
-		 * d-pad center -> data[3] & 0x01
+		/* d-pad right  -> data[2] & 0x10
+		 * d-pad up     -> data[2] & 0x20
+		 * d-pad left   -> data[2] & 0x40
+		 * d-pad down   -> data[2] & 0x80
+		 * d-pad center -> data[1] & 0x01
 		 */
 		buttons = ((data[2] >> 4) << 7) |
-		          ((data[1] & 0x04) << 6) |
+		          ((data[1] & 0x04) << 4) |
 		          ((data[2] & 0x0F) << 2) |
 		          (data[1] & 0x03);
 	} else if (features->type >= INTUOS5S && features->type <= INTUOSPL) {
-- 
2.17.1

