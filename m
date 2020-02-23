Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B464169965
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 19:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBWSUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 13:20:17 -0500
Received: from mail.klausen.dk ([174.138.9.187]:51412 "EHLO mail.klausen.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgBWSUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 13:20:17 -0500
From:   Kristian Klausen <kristian@klausen.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=klausen.dk; s=dkim;
        t=1582482014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4TIBWEpyQVktaSr/apYJY4pVCzgNK2tF16Bdkv2r14w=;
        b=GLrBR04NjnTxdzePvqRKqf3zo2o/DX9eXBZVGmRCGPqTOn3E4tkUKBK9rWPp1IIbpE3x4h
        DRbMovd4sab2ECM+izCGnX8ybYuLyjXOzwQsHkyfPcIp3Yvfd4i6K5W3j6dJOj5pvpZUr/
        L8YjGr2VouLGG6rksY1ohP0AiTvCEwk=
To:     platform-driver-x86@vger.kernel.org
Cc:     Kristian Klausen <kristian@klausen.dk>, stable@vger.kernel.org
Subject: [PATCH v2] platform/x86: asus-wmi: Support laptops where the first battery is named BATT
Date:   Sun, 23 Feb 2020 19:18:32 +0100
Message-Id: <20200223181832.17131-1-kristian@klausen.dk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The WMI method to set the charge threshold does not provide a
way to specific a battery, so we assume it is the first/primary
battery (by checking if the name is BAT0).
On some newer ASUS laptops (Zenbook UM431DA) though, the
primary/first battery isn't named BAT0 but BATT, so we need
to support that case.

Signed-off-by: Kristian Klausen <kristian@klausen.dk>
Cc: stable@vger.kernel.org
---
I'm not sure if this is candidate for -stable, it fix a real bug
(charge threshold doesn't work on newer ASUS laptops) which has been
reported by a user[1], but is that enough?
I had a quick look at[2], can this be considered a "something
critical"? It "bothers people"[1]. My point: I'm not sure..

I'm unsure if there is a bettery way to fix this. Maybe a counter
would be better (+1 for every new battery)? It would probably need
to be atomic to prevent race condition (I'm not sure how this code
is run), but this "fix" is way simpler.

Please do not accept this patch just yet, I'm waiting for the tester
to either confirm or deny credit[3].

[1] https://gist.github.com/klausenbusk/643f15320ae8997427155c38be13e445#gistcomment-3186025
[2] https://www.kernel.org/doc/html/v5.5/process/stable-kernel-rules.html
[3] https://gist.github.com/klausenbusk/643f15320ae8997427155c38be13e445#gistcomment-3186429

v2:
Add base commit
Remove uneeded parenthesis and adjust styling

 drivers/platform/x86/asus-wmi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 612ef5526226..01becbe2a9a8 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -426,8 +426,11 @@ static int asus_wmi_battery_add(struct power_supply *battery)
 {
 	/* The WMI method does not provide a way to specific a battery, so we
 	 * just assume it is the first battery.
+	 * Note: On some newer ASUS laptops (Zenbook UM431DA), the primary/first
+	 * battery is named BATT.
 	 */
-	if (strcmp(battery->desc->name, "BAT0") != 0)
+	if (strcmp(battery->desc->name, "BAT0") != 0 &&
+	    strcmp(battery->desc->name, "BATT") != 0)
 		return -ENODEV;
 
 	if (device_create_file(&battery->dev,

base-commit: 11a48a5a18c63fd7621bb050228cebf13566e4d8
-- 
2.25.1

