Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710DD29DB84
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389401AbgJ2ABu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 20:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730098AbgJ2AA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 20:00:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17994C0613D1
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 17:00:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a12so776272ybc.20
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 17:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=OuJr16cGdSeTRRY2e3lrFCZY64j7gnlLJ3xITCQ65aI=;
        b=Ox/dDFlhTnltHkm0BiioQTdlQVzqvcpEZIbKwhzZb6htbEszgkFVPcTjzdjzhQig1j
         XPPsmlFOV99MW/TttdpxSbrL/Ogv+kkTYQJnJAKW+vxRt3DRVYB6pATixQlN7xp1oXA6
         JEYpFJjExfXKDgjJl3JDErnb82W8dhAsiMUfqCnDFkZsq3nHNjPfi9sIitwxVb10RAir
         XJ307rKW/ZZcRpxnvDBGun3Zd6dKAZQlHnVEYwo9jENFPBPBifRVBwlwLT8o7VVg2+GU
         Hy9Ly6YZ+qm5hVSPX++HnsZtlu0jLDpT16Z3d/5jQHa3JQ0Iwg5pcVi6XuxFTGvpY75a
         fNkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=OuJr16cGdSeTRRY2e3lrFCZY64j7gnlLJ3xITCQ65aI=;
        b=LuGK5QPBSsy7zxPJJiAwyH2j2eyLKHVuaY4AXiuRw2XhYIbVFYPJ6iXMCMR5PG1mUK
         n81dXL6NiKQPqmGaCaEmkHug7wTs+8TwKoWa6MgNDaM1dmJwGfkcVdbpv5Hvt0AmNFsE
         wuhqk9oz7SUnB0CVgfZG8jCAoHVii/I8lLUPnPwhPiUSJhDqoHuOLEBpm80Vb80eC2vN
         M52ay3QbXTHSJ0/zcazo4OHw/y12Es11lpbJ9hBm56FuO85J6PwKcu/OXodb0Vd2MWxu
         X84dVuzzFuGjSy3No6IgHmfm3ugVfOwYW98Kd8L5laX2VSeaF/h9tun9G7vE+COIz9mf
         GvrQ==
X-Gm-Message-State: AOAM530BJqXivy91v8/Ax/VrzYjNmCl+yyvv3cPhJxob1DLlLsDsxknQ
        YrVj4Fgq8THbwUgRTpHEUhzNUHbx
X-Google-Smtp-Source: ABdhPJybm4TBI3oXQKhNOJ3j6Z2Gs5TY7f1A9h6VtC8BA8mOvPp73YripvvkrVa7jwPzdPXuZbJyuP6k
Sender: "lzye via sendgmr" <lzye@chrisye.mtv.corp.google.com>
X-Received: from chrisye.mtv.corp.google.com ([2620:15c:211:2:f693:9fff:fef4:4323])
 (user=lzye job=sendgmr) by 2002:a25:578a:: with SMTP id l132mr2235601ybb.200.1603929625220;
 Wed, 28 Oct 2020 17:00:25 -0700 (PDT)
Date:   Wed, 28 Oct 2020 17:00:22 -0700
Message-Id: <20201029000022.667052-1-lzye@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] ANDROID: Fix the HID usage of DPAD input event generation.
From:   Chris Ye <lzye@google.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Mark Brown <broonie@kernel.org>
Cc:     linzhao.ye@gmail.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org, stable@vger.kernel.org,
        Chris Ye <lzye@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Generic Desktop DPAD usage is mapped by hid-input, that only the first
DPAD usage maps to usage type EV_ABS and code of an axis. If HID
descriptor has DPAD UP/DOWN/LEFT/RIGHT HID usages and each of usage size
is 1 bit, then only the first one will generate input event, the rest of
the HID usages will be assigned to hat direction only.
The hid input event should check the HID report value and generate
HID event for its hat direction.

Test: Connect HID device with Generic Desktop DPAD usage and press the
DPAD to generate input events.

Signed-off-by: Chris Ye <lzye@google.com>
---
 drivers/hid/hid-input.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 9770db624bfa..6c1007de3409 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1269,7 +1269,7 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 	struct input_dev *input;
 	unsigned *quirks = &hid->quirks;
 
-	if (!usage->type)
+	if (!usage->type && !field->dpad)
 		return;
 
 	if (usage->type == EV_PWR) {
@@ -1286,9 +1286,17 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 		int hat_dir = usage->hat_dir;
 		if (!hat_dir)
 			hat_dir = (value - usage->hat_min) * 8 / (usage->hat_max - usage->hat_min + 1) + 1;
-		if (hat_dir < 0 || hat_dir > 8) hat_dir = 0;
-		input_event(input, usage->type, usage->code    , hid_hat_to_axis[hat_dir].x);
-		input_event(input, usage->type, usage->code + 1, hid_hat_to_axis[hat_dir].y);
+		if (hat_dir < 0 || hat_dir > 8 || value == 0)
+			hat_dir = 0;
+		if (field->dpad) {
+			input_event(input, EV_ABS, field->dpad, hid_hat_to_axis[hat_dir].x);
+			input_event(input, EV_ABS, field->dpad + 1, hid_hat_to_axis[hat_dir].y);
+		} else {
+			input_event(input, usage->type, usage->code,
+				hid_hat_to_axis[hat_dir].x);
+			input_event(input, usage->type, usage->code + 1,
+				hid_hat_to_axis[hat_dir].y);
+		}
 		return;
 	}
 
-- 
2.29.1.341.ge80a0c044ae-goog

