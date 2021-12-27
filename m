Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755E148010C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbhL0Pww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241319AbhL0Pui (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:50:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85A1C08E841;
        Mon, 27 Dec 2021 07:46:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 885E5B810A2;
        Mon, 27 Dec 2021 15:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CCCC36AEA;
        Mon, 27 Dec 2021 15:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619959;
        bh=vC0/tTZBSyqqzO9xukwMKIxRfiHHXu1pSsNZoBvyKKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rj0BIoodqFu5vSN08gQlR2WzSqFj9ZE4sCZB/mdiv8yi3FTD6Kl25XsBl3d0iriEt
         j8zcbuh0Lf5kpBsfV+kTy9OZW4wSXLI7kGlrUKYa9TlLqM90sCH4HQxJ3KxFy6XK1h
         N1rakIlHFrh2Mfbfb1ntVBoeyAH0Mqy7j8aeRojg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 121/128] hwmom: (lm90) Fix citical alarm status for MAX6680/MAX6681
Date:   Mon, 27 Dec 2021 16:31:36 +0100
Message-Id: <20211227151335.565220214@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit da7dc0568491104c7acb632e9d41ddce9aaabbb1 upstream.

Tests with a real chip and a closer look into the datasheet reveals
that the local and remote critical alarm status bits are swapped for
MAX6680/MAX6681.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/lm90.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -190,6 +190,7 @@ enum chips { lm90, adm1032, lm99, lm86,
 #define LM90_HAVE_EXTENDED_TEMP	(1 << 8) /* extended temperature support*/
 #define LM90_PAUSE_FOR_CONFIG	(1 << 9) /* Pause conversion for config	*/
 #define LM90_HAVE_CRIT		(1 << 10)/* Chip supports CRIT/OVERT register	*/
+#define LM90_HAVE_CRIT_ALRM_SWP	(1 << 11)/* critical alarm bits swapped	*/
 
 /* LM90 status */
 #define LM90_STATUS_LTHRM	(1 << 0) /* local THERM limit tripped */
@@ -415,7 +416,8 @@ static const struct lm90_params lm90_par
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[max6680] = {
-		.flags = LM90_HAVE_OFFSET | LM90_HAVE_CRIT,
+		.flags = LM90_HAVE_OFFSET | LM90_HAVE_CRIT
+		  | LM90_HAVE_CRIT_ALRM_SWP,
 		.alert_alarms = 0x7c,
 		.max_convrate = 7,
 	},
@@ -1201,6 +1203,7 @@ static const u8 lm90_temp_emerg_index[3]
 static const u8 lm90_min_alarm_bits[3] = { 5, 3, 11 };
 static const u8 lm90_max_alarm_bits[3] = { 6, 4, 12 };
 static const u8 lm90_crit_alarm_bits[3] = { 0, 1, 9 };
+static const u8 lm90_crit_alarm_bits_swapped[3] = { 1, 0, 9 };
 static const u8 lm90_emergency_alarm_bits[3] = { 15, 13, 14 };
 static const u8 lm90_fault_bits[3] = { 0, 2, 10 };
 
@@ -1226,7 +1229,10 @@ static int lm90_temp_read(struct device
 		*val = (data->alarms >> lm90_max_alarm_bits[channel]) & 1;
 		break;
 	case hwmon_temp_crit_alarm:
-		*val = (data->alarms >> lm90_crit_alarm_bits[channel]) & 1;
+		if (data->flags & LM90_HAVE_CRIT_ALRM_SWP)
+			*val = (data->alarms >> lm90_crit_alarm_bits_swapped[channel]) & 1;
+		else
+			*val = (data->alarms >> lm90_crit_alarm_bits[channel]) & 1;
 		break;
 	case hwmon_temp_emergency_alarm:
 		*val = (data->alarms >> lm90_emergency_alarm_bits[channel]) & 1;


