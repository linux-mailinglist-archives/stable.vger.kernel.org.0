Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0658F6C09CF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 05:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjCTExA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 00:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCTEw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 00:52:59 -0400
Received: from hyperium.qtmlabs.xyz (hyperium.qtmlabs.xyz [IPv6:2a02:c206:2066:3319::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2A01CAE1;
        Sun, 19 Mar 2023 21:52:58 -0700 (PDT)
Received: from dong.kernal.eu (unknown [222.254.17.84])
        by hyperium.qtmlabs.xyz (Postfix) with ESMTPSA id 773DD82005A;
        Mon, 20 Mar 2023 05:52:56 +0100 (CET)
Received: from localhost (unknown [194.163.182.183])
        by dong.kernal.eu (Postfix) with ESMTPSA id 692C544496AC;
        Mon, 20 Mar 2023 11:52:52 +0700 (+07)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qtmlabs.xyz; s=syka;
        t=1679287973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R0g5pRepGXvaveW3Y2DO3fYZK+m7A7Bx9lsMZkArEUw=;
        b=bce9sZB/7qAa6uByHiZ1hwqef95Pg5IZxNs2jcihEaZTTHFg0PeTnAw2BvMPvMjK+fQDwu
        LXxp1jBgsMit1fuuzKE/RoFwqhXQJeaKE9wDG6skkwtw6b9+krOa54peXAwdPcZovqCHXG
        3UjgjNeUuKrE8xOKtBlx1a09suUSmMJMmfaQ8PeEjw17nj/a3WYmAhxp3QHUjFbel0HmKs
        MH7RlQ436NXQ0m1FzxH+qNoQS7057FRXJW9AIyFf2PE+iVsu1xJMgAXwS4k5/NxsdW47l4
        YEV/iQPpSrwJumqJlbwGbN/qHt1jOs40WKexRUaiCFFROZlazqz9AfQg5W7jUA==
From:   msizanoen1 <msizanoen@qtmlabs.xyz>
To:     msizanoen@qtmlabs.xyz
Cc:     dmitry.torokhov@gmail.com, hdegoede@redhat.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pali@kernel.org, stable@vger.kernel.org
Subject: [PATCH v3] input: alps: fix compatibility with -funsigned-char
Date:   Mon, 20 Mar 2023 05:52:29 +0100
Message-Id: <20230320045228.182259-1-msizanoen@qtmlabs.xyz>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
References: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: msizanoen <msizanoen@qtmlabs.xyz>

The AlpsPS/2 code previously relied on the assumption that `char` is a
signed type, which was true on x86 platforms (the only place where this
driver is used) before kernel 6.2. However, on 6.2 and later, this
assumption is broken due to the introduction of -funsigned-char as a new
global compiler flag.

Fix this by explicitly specifying the signedness of `char` when sign
extending the values received from the device.

v2:
	Add explicit signedness to more places

v3:
	Use `s8` instead of `signed char`

Fixes: f3f33c677699 ("Input: alps - Rushmore and v7 resolution support")
Cc: stable@vger.kernel.org
Signed-off-by: msizanoen <msizanoen@qtmlabs.xyz>
---
 drivers/input/mouse/alps.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 989228b5a0a4..e2c11d9f3868 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -852,8 +852,8 @@ static void alps_process_packet_v6(struct psmouse *psmouse)
 			x = y = z = 0;
 
 		/* Divide 4 since trackpoint's speed is too fast */
-		input_report_rel(dev2, REL_X, (char)x / 4);
-		input_report_rel(dev2, REL_Y, -((char)y / 4));
+		input_report_rel(dev2, REL_X, (s8)x / 4);
+		input_report_rel(dev2, REL_Y, -((s8)y / 4));
 
 		psmouse_report_standard_buttons(dev2, packet[3]);
 
@@ -1104,8 +1104,8 @@ static void alps_process_trackstick_packet_v7(struct psmouse *psmouse)
 	    ((packet[3] & 0x20) << 1);
 	z = (packet[5] & 0x3f) | ((packet[3] & 0x80) >> 1);
 
-	input_report_rel(dev2, REL_X, (char)x);
-	input_report_rel(dev2, REL_Y, -((char)y));
+	input_report_rel(dev2, REL_X, (s8)x);
+	input_report_rel(dev2, REL_Y, -((s8)y));
 	input_report_abs(dev2, ABS_PRESSURE, z);
 
 	psmouse_report_standard_buttons(dev2, packet[1]);
@@ -2294,20 +2294,20 @@ static int alps_get_v3_v7_resolution(struct psmouse *psmouse, int reg_pitch)
 	if (reg < 0)
 		return reg;
 
-	x_pitch = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_pitch = (s8)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_pitch = 50 + 2 * x_pitch; /* In 0.1 mm units */
 
-	y_pitch = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_pitch = (s8)reg >> 4; /* sign extend upper 4 bits */
 	y_pitch = 36 + 2 * y_pitch; /* In 0.1 mm units */
 
 	reg = alps_command_mode_read_reg(psmouse, reg_pitch + 1);
 	if (reg < 0)
 		return reg;
 
-	x_electrode = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_electrode = (s8)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_electrode = 17 + x_electrode;
 
-	y_electrode = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_electrode = (s8)reg >> 4; /* sign extend upper 4 bits */
 	y_electrode = 13 + y_electrode;
 
 	x_phys = x_pitch * (x_electrode - 1); /* In 0.1 mm units */
-- 
2.39.2

