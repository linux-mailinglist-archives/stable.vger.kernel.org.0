Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E831017815E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388100AbgCCSCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:02:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388122AbgCCSCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F5FD2072D;
        Tue,  3 Mar 2020 18:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258522;
        bh=mxbDHS6ejt+bC1CxSzwV5KFxMk1n1iUNt5JgMeuMNik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njdq+3XLoqo2kM+bVKxMI+lWW8LS7bPkMwf8csx9i2QvFCD+DlRQoIfqE1MwD4TGm
         s6eBVvF3MwC/McSqpq4Y4SoHPiucOTYoQkrUOvq6Ys8vK5ruXZNen06jUaUm3WLTKd
         3WDuDEwEq4PFxsdjNDVgfBfUtjty/rq2q1K4y87A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 4.19 82/87] thermal: brcmstb_thermal: Do not use DT coefficients
Date:   Tue,  3 Mar 2020 18:44:13 +0100
Message-Id: <20200303174357.652862314@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit e1ff6fc22f19e2af8adbad618526b80067911d40 upstream.

At the time the brcmstb_thermal driver and its binding were merged, the
DT binding did not make the coefficients properties a mandatory one,
therefore all users of the brcmstb_thermal driver out there have a non
functional implementation with zero coefficients. Even if these
properties were provided, the formula used for computation is incorrect.

The coefficients are entirely process specific (right now, only 28nm is
supported) and not board or SoC specific, it is therefore appropriate to
hard code them in the driver given the compatibility string we are
probed with which has to be updated whenever a new process is
introduced.

We remove the existing coefficients definition since subsequent patches
are going to add support for a new process and will introduce new
coefficients as well.

Fixes: 9e03cf1b2dd5 ("thermal: add brcmstb AVS TMON driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200114190607.29339-2-f.fainelli@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thermal/broadcom/brcmstb_thermal.c |   31 ++++++++---------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

--- a/drivers/thermal/broadcom/brcmstb_thermal.c
+++ b/drivers/thermal/broadcom/brcmstb_thermal.c
@@ -58,7 +58,7 @@
 #define AVS_TMON_TP_TEST_ENABLE		0x20
 
 /* Default coefficients */
-#define AVS_TMON_TEMP_SLOPE		-487
+#define AVS_TMON_TEMP_SLOPE		487
 #define AVS_TMON_TEMP_OFFSET		410040
 
 /* HW related temperature constants */
@@ -117,23 +117,12 @@ struct brcmstb_thermal_priv {
 	struct thermal_zone_device *thermal;
 };
 
-static void avs_tmon_get_coeffs(struct thermal_zone_device *tz, int *slope,
-				int *offset)
-{
-	*slope = thermal_zone_get_slope(tz);
-	*offset = thermal_zone_get_offset(tz);
-}
-
 /* Convert a HW code to a temperature reading (millidegree celsius) */
 static inline int avs_tmon_code_to_temp(struct thermal_zone_device *tz,
 					u32 code)
 {
-	const int val = code & AVS_TMON_TEMP_MASK;
-	int slope, offset;
-
-	avs_tmon_get_coeffs(tz, &slope, &offset);
-
-	return slope * val + offset;
+	return (AVS_TMON_TEMP_OFFSET -
+		(int)((code & AVS_TMON_TEMP_MAX) * AVS_TMON_TEMP_SLOPE));
 }
 
 /*
@@ -145,20 +134,18 @@ static inline int avs_tmon_code_to_temp(
 static inline u32 avs_tmon_temp_to_code(struct thermal_zone_device *tz,
 					int temp, bool low)
 {
-	int slope, offset;
-
 	if (temp < AVS_TMON_TEMP_MIN)
-		return AVS_TMON_TEMP_MAX; /* Maximum code value */
-
-	avs_tmon_get_coeffs(tz, &slope, &offset);
+		return AVS_TMON_TEMP_MAX;	/* Maximum code value */
 
-	if (temp >= offset)
+	if (temp >= AVS_TMON_TEMP_OFFSET)
 		return 0;	/* Minimum code value */
 
 	if (low)
-		return (u32)(DIV_ROUND_UP(offset - temp, abs(slope)));
+		return (u32)(DIV_ROUND_UP(AVS_TMON_TEMP_OFFSET - temp,
+					  AVS_TMON_TEMP_SLOPE));
 	else
-		return (u32)((offset - temp) / abs(slope));
+		return (u32)((AVS_TMON_TEMP_OFFSET - temp) /
+			      AVS_TMON_TEMP_SLOPE);
 }
 
 static int brcmstb_get_temp(void *data, int *temp)


