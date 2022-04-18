Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A62505011
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbiDRMVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbiDRMUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:20:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000AC1ADB3;
        Mon, 18 Apr 2022 05:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D5E6B80ED6;
        Mon, 18 Apr 2022 12:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90F9C385A1;
        Mon, 18 Apr 2022 12:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284218;
        bh=NIV7eCT03ptnAideh/J4uJ2LZyH2vdTkb2rVq1GvSqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrB0G2P0Vo9uqD1ZjKsLdgWZ6k3PwenRW0ib/G0Rp1pw5jaw8XeBaudGKrxManHXH
         lJ194e4p+4nJwLAU70H7Iz5ni30D6VhesPD35pq17A/l7ZIUBcS1z7wF9oEL2Ciqa5
         6Z7vJcsWeli0urBRcp8a0V8BAktp1p2MA4BBWXik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Chmura <chmooreck@gmail.com>,
        Robert Schlabbach <robert_s@gmx.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.17 011/219] media: si2157: unknown chip version Si2147-A30 ROM 0x50
Date:   Mon, 18 Apr 2022 14:09:40 +0200
Message-Id: <20220418121203.795388883@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Chmura <chmooreck@gmail.com>

commit 3ae87d2f25c0e998da2721ce332e2b80d3d53c39 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/tuners/si2157.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

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
@@ -178,7 +178,7 @@ static int si2157_find_and_load_firmware
 		}
 	}
 
-	if (!fw_name && !fw_alt_name) {
+	if (required && !fw_name && !fw_alt_name) {
 		dev_err(&client->dev,
 			"unknown chip version Si21%d-%c%c%c ROM 0x%02x\n",
 			part_id, cmd.args[1], cmd.args[3], cmd.args[4], rom_id);


