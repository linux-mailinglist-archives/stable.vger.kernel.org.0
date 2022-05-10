Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E095219EF
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbiEJNwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343560AbiEJNsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB582B1652;
        Tue, 10 May 2022 06:36:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7FC8B81DB0;
        Tue, 10 May 2022 13:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE0EC385A6;
        Tue, 10 May 2022 13:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189765;
        bh=bZJsAhefE7TmQsxHE4HZUSdcOMaxLZwLBWLG/XeVUpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BF1kO9crXbGvl9Nk3ZPRuL+AxAAbWTjLbrQhDqD7mUHDEXRMxZ4LM1lZC9SSIdUY/
         qXIe1RMC32h6g7jQxHyOPuHcLPa4s+HGu6J+cMCwT3AvJCzV6u9nC8GNX5WwnjaY/K
         X8cot39tk23BCEY3+JVUOM1vQaXi8FXr4AwMXjJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.17 021/140] hwmon: (pmbus) delta-ahe50dc-fan: work around hardware quirk
Date:   Tue, 10 May 2022 15:06:51 +0200
Message-Id: <20220510130742.216781277@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

commit 08da09f028043fed9653331ae75bc310411f72e6 upstream.

CLEAR_FAULTS commands can apparently sometimes trigger catastrophic
power output glitches on the ahe-50dc, so block them from being sent
at all.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220427035109.3819-1-zev@bewilderbeest.net
Fixes: d387d88ed045 ("hwmon: (pmbus) Add Delta AHE-50DC fan control module driver")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/delta-ahe50dc-fan.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

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
@@ -68,6 +83,7 @@ static struct pmbus_driver_info ahe50dc_
 		PMBUS_HAVE_VIN | PMBUS_HAVE_FAN12 | PMBUS_HAVE_FAN34 |
 		PMBUS_HAVE_STATUS_FAN12 | PMBUS_HAVE_STATUS_FAN34 | PMBUS_PAGE_VIRTUAL,
 	.func[1] = PMBUS_HAVE_TEMP | PMBUS_PAGE_VIRTUAL,
+	.write_byte = ahe50dc_fan_write_byte,
 	.read_word_data = ahe50dc_fan_read_word_data,
 };
 


