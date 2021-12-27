Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD6447FF3D
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbhL0Pgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:36:31 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40280 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238627AbhL0PgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:36:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DD14ECE10E9;
        Mon, 27 Dec 2021 15:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACCDC36AE7;
        Mon, 27 Dec 2021 15:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619358;
        bh=6Z1hCqGBYBETvydbz0RrpXobRIUMWe19rZrAm7M0c1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2kFuSVA6sHGTV5Yz/X9kOIE7Mj0pygkOESyRofacOfoYjcloVruQm9CzAS3ESIva
         fJIJEiKPNJc3o/Z/cTA4i9BaRbZr+bwRltKOkxwSdUj+ICnbhqbj/RCoXAOt4Zfaiz
         BmAQlTcsI/d6LA7PXcNUu38uHlKdMEhc6AQ4O31g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 42/47] hwmom: (lm90) Fix citical alarm status for MAX6680/MAX6681
Date:   Mon, 27 Dec 2021 16:31:18 +0100
Message-Id: <20211227151322.259734116@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
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
@@ -1191,6 +1193,7 @@ static const u8 lm90_temp_emerg_index[3]
 static const u8 lm90_min_alarm_bits[3] = { 5, 3, 11 };
 static const u8 lm90_max_alarm_bits[3] = { 6, 4, 12 };
 static const u8 lm90_crit_alarm_bits[3] = { 0, 1, 9 };
+static const u8 lm90_crit_alarm_bits_swapped[3] = { 1, 0, 9 };
 static const u8 lm90_emergency_alarm_bits[3] = { 15, 13, 14 };
 static const u8 lm90_fault_bits[3] = { 0, 2, 10 };
 
@@ -1216,7 +1219,10 @@ static int lm90_temp_read(struct device
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


