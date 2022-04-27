Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3B9510FAB
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 05:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357575AbiD0Dyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 23:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357545AbiD0Dys (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 23:54:48 -0400
Received: from thorn.bewilderbeest.net (thorn.bewilderbeest.net [71.19.156.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AB23C48F
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 20:51:37 -0700 (PDT)
Received: from hatter.bewilderbeest.net (174-21-163-222.tukw.qwest.net [174.21.163.222])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: zev)
        by thorn.bewilderbeest.net (Postfix) with ESMTPSA id 4AD74137;
        Tue, 26 Apr 2022 20:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bewilderbeest.net;
        s=thorn; t=1651031494;
        bh=fiHBh/Fh5zEGAH6yN71KI47zEv55JXWMRQICkzrdU2Q=;
        h=From:To:Cc:Subject:Date:From;
        b=JJlNVM5S2ycrHAuvWGNKCO+mC+eSG/qH5Awg4cMw8+4eeMZT3ECtCKsI/ovXbPBGo
         Vg5TRiNzlq+t0KMUAL7GQWvn4TyqFRkcZ9RBOtNPAlWJU27ol0HfUtw2YQBlyVORYz
         fGUY4P62bEwjyACYYnycdeBHjLGrlIxugI3lD7ig=
From:   Zev Weiss <zev@bewilderbeest.net>
To:     Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
        Zev Weiss <zev@bewilderbeest.net>, stable@vger.kernel.org
Subject: [PATCH] hwmon: (pmbus) delta-ahe50dc-fan: work around hardware quirk
Date:   Tue, 26 Apr 2022 20:51:09 -0700
Message-Id: <20220427035109.3819-1-zev@bewilderbeest.net>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CLEAR_FAULTS commands can apparently sometimes trigger catastrophic
power output glitches on the ahe-50dc, so block them from being sent
at all.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Cc: stable@vger.kernel.org
---
 drivers/hwmon/pmbus/delta-ahe50dc-fan.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/hwmon/pmbus/delta-ahe50dc-fan.c b/drivers/hwmon/pmbus/delta-ahe50dc-fan.c
index 40dffd9c4cbf..f546f0c12497 100644
--- a/drivers/hwmon/pmbus/delta-ahe50dc-fan.c
+++ b/drivers/hwmon/pmbus/delta-ahe50dc-fan.c
@@ -14,6 +14,21 @@
 
 #define AHE50DC_PMBUS_READ_TEMP4 0xd0
 
+static int ahe50dc_fan_write_byte(struct i2c_client *client, int page, u8 value)
+{
+	/*
+	 * The CLEAR_FAULTS operation seems to sometimes (unpredictably, perhaps
+	 * 5% of the time or so) trigger a problematic phenomenon in which the
+	 * fan speeds surge momentarily and at least some (perhaps all?) of the
+	 * system's power outputs experience a glitch.
+	 *
+	 * However, according to Delta it should be OK to simply not send any
+	 * CLEAR_FAULTS commands (the device doesn't seem to be capable of
+	 * reporting any faults anyway), so just blackhole them unconditionally.
+	 */
+	return value == PMBUS_CLEAR_FAULTS ? -EOPNOTSUPP : -ENODATA;
+}
+
 static int ahe50dc_fan_read_word_data(struct i2c_client *client, int page, int phase, int reg)
 {
 	/* temp1 in (virtual) page 1 is remapped to mfr-specific temp4 */
@@ -68,6 +83,7 @@ static struct pmbus_driver_info ahe50dc_fan_info = {
 		PMBUS_HAVE_VIN | PMBUS_HAVE_FAN12 | PMBUS_HAVE_FAN34 |
 		PMBUS_HAVE_STATUS_FAN12 | PMBUS_HAVE_STATUS_FAN34 | PMBUS_PAGE_VIRTUAL,
 	.func[1] = PMBUS_HAVE_TEMP | PMBUS_PAGE_VIRTUAL,
+	.write_byte = ahe50dc_fan_write_byte,
 	.read_word_data = ahe50dc_fan_read_word_data,
 };
 
-- 
2.36.0

