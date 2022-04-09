Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557444FA95A
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 17:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbiDIPsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 11:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiDIPsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 11:48:21 -0400
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE80B7
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 08:46:14 -0700 (PDT)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1ndDHw-00AZfQ-Dr; Sat, 09 Apr 2022 15:46:12 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Sat, 09 Apr 2022 15:45:49 +0000
Subject: [git:media_tree/fixes] media: si2157: unknown chip version Si2147-A30 ROM 0x50
To:     linuxtv-commits@linuxtv.org
Cc:     Robert Schlabbach <robert_s@gmx.net>, stable@vger.kernel.org,
        Piotr Chmura <chmooreck@gmail.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1ndDHw-00AZfQ-Dr@www.linuxtv.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: si2157: unknown chip version Si2147-A30 ROM 0x50
Author:  Piotr Chmura <chmooreck@gmail.com>
Date:    Thu Mar 31 17:55:50 2022 +0200

Fix firmware file names assignment in si2157 tuner, allow for running
devices without firmware files needed.

modprobe gives error: unknown chip version Si2147-A30 ROM 0x50
Device initialization is interrupted.

Caused by:
1. table si2157_tuners has swapped fields rom_id and required vs struct
   si2157_tuner_info.
2. both firmware file names can be null for devices with
   required == false - device uses build-in firmware in this case

Tested on this device:
	m07ca:1871 AVerMedia Technologies, Inc. TD310 DVB-T/T2/C dongle

[mchehab: fix mangled patch]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215726
Link: https://lore.kernel.org/lkml/5f660108-8812-383c-83e4-29ee0558d623@leemhuis.info/
Link: https://lore.kernel.org/linux-media/c4bcaff8-fbad-969e-ad47-e2c487ac02a1@gmail.com
Fixes: 1c35ba3bf972 ("media: si2157: use a different namespace for firmware")
Cc: stable@vger.kernel.org # 5.17.x
Signed-off-by: Piotr Chmura <chmooreck@gmail.com>
Tested-by: Robert Schlabbach <robert_s@gmx.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/tuners/si2157.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

---

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 47029746b89e..0de587b412d4 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -77,16 +77,16 @@ err_mutex_unlock:
 }
 
 static const struct si2157_tuner_info si2157_tuners[] = {
-	{ SI2141, false, 0x60, SI2141_60_FIRMWARE, SI2141_A10_FIRMWARE },
-	{ SI2141, false, 0x61, SI2141_61_FIRMWARE, SI2141_A10_FIRMWARE },
-	{ SI2146, false, 0x11, SI2146_11_FIRMWARE, NULL },
-	{ SI2147, false, 0x50, SI2147_50_FIRMWARE, NULL },
-	{ SI2148, true,  0x32, SI2148_32_FIRMWARE, SI2158_A20_FIRMWARE },
-	{ SI2148, true,  0x33, SI2148_33_FIRMWARE, SI2158_A20_FIRMWARE },
-	{ SI2157, false, 0x50, SI2157_50_FIRMWARE, SI2157_A30_FIRMWARE },
-	{ SI2158, false, 0x50, SI2158_50_FIRMWARE, SI2158_A20_FIRMWARE },
-	{ SI2158, false, 0x51, SI2158_51_FIRMWARE, SI2158_A20_FIRMWARE },
-	{ SI2177, false, 0x50, SI2177_50_FIRMWARE, SI2157_A30_FIRMWARE },
+	{ SI2141, 0x60, false, SI2141_60_FIRMWARE, SI2141_A10_FIRMWARE },
+	{ SI2141, 0x61, false, SI2141_61_FIRMWARE, SI2141_A10_FIRMWARE },
+	{ SI2146, 0x11, false, SI2146_11_FIRMWARE, NULL },
+	{ SI2147, 0x50, false, SI2147_50_FIRMWARE, NULL },
+	{ SI2148, 0x32, true,  SI2148_32_FIRMWARE, SI2158_A20_FIRMWARE },
+	{ SI2148, 0x33, true,  SI2148_33_FIRMWARE, SI2158_A20_FIRMWARE },
+	{ SI2157, 0x50, false, SI2157_50_FIRMWARE, SI2157_A30_FIRMWARE },
+	{ SI2158, 0x50, false, SI2158_50_FIRMWARE, SI2158_A20_FIRMWARE },
+	{ SI2158, 0x51, false, SI2158_51_FIRMWARE, SI2158_A20_FIRMWARE },
+	{ SI2177, 0x50, false, SI2177_50_FIRMWARE, SI2157_A30_FIRMWARE },
 };
 
 static int si2157_load_firmware(struct dvb_frontend *fe,
@@ -178,7 +178,7 @@ static int si2157_find_and_load_firmware(struct dvb_frontend *fe)
 		}
 	}
 
-	if (!fw_name && !fw_alt_name) {
+	if (required && !fw_name && !fw_alt_name) {
 		dev_err(&client->dev,
 			"unknown chip version Si21%d-%c%c%c ROM 0x%02x\n",
 			part_id, cmd.args[1], cmd.args[3], cmd.args[4], rom_id);
