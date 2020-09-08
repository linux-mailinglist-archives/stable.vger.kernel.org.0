Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DB7261988
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbgIHSTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731458AbgIHQLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0ED5223BD;
        Tue,  8 Sep 2020 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579646;
        bh=jo2hfuKv1CEXipIyUmxbXDOt8hRzTyCWXZBeh4jyNyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlLpjn1UXkF/qHyjubJ6KIFizbpNqhl/lhaKtLkRpouO7l5AmjFC2mDLeqIuCI+jj
         mD+UZwy5mWxkJbydUpBM6agQ+koTw2kho/Y7CZsvWJOdCWwcEcXl1ZeZR6Po1f2HaB
         JMglVM/kZwKUPgkrdr/ZX0sLwC8HtKvNMShVyBKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.8 163/186] drm/amd/pm: avoid false alarm due to confusing softwareshutdowntemp setting
Date:   Tue,  8 Sep 2020 17:25:05 +0200
Message-Id: <20200908152249.565336194@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 971df65cbf32da9bc9af52c1196ca504dd316086 upstream.

Normally softwareshutdowntemp should be greater than Thotspotlimit.
However, on some VEGA10 ASIC, the softwareshutdowntemp is 91C while
Thotspotlimit is 105C. This seems not right and may trigger some
false alarms.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c
@@ -374,8 +374,18 @@ static int vega10_thermal_set_temperatur
 	/* compare them in unit celsius degree */
 	if (low < range->min / PP_TEMPERATURE_UNITS_PER_CENTIGRADES)
 		low = range->min / PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
-	if (high > tdp_table->usSoftwareShutdownTemp)
-		high = tdp_table->usSoftwareShutdownTemp;
+
+	/*
+	 * As a common sense, usSoftwareShutdownTemp should be bigger
+	 * than ThotspotLimit. For any invalid usSoftwareShutdownTemp,
+	 * we will just use the max possible setting VEGA10_THERMAL_MAXIMUM_ALERT_TEMP
+	 * to avoid false alarms.
+	 */
+	if ((tdp_table->usSoftwareShutdownTemp >
+	     range->hotspot_crit_max / PP_TEMPERATURE_UNITS_PER_CENTIGRADES)) {
+		if (high > tdp_table->usSoftwareShutdownTemp)
+			high = tdp_table->usSoftwareShutdownTemp;
+	}
 
 	if (low > high)
 		return -EINVAL;


