Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0032D43FB3
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbfFMP7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731483AbfFMItl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:49:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB43206BA;
        Thu, 13 Jun 2019 08:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415780;
        bh=6qm8dsSAAvZzsQrVpV/U/Q9NvOzvbQ9vwMwJpnapczA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFkjKCOcV5rWdFNQXlqpO5cEFuRW06wktti0gpjT/v3jZAzYuh8TFixA2XizVqDe1
         lsR66u7QQ4wtNwgSE1N99ehnvlp37Js+y6OYBnfombmYm1uCPGXh3XfH9teApnE81X
         j7761w6Ne+hmBjj8Pvu5b7DKe4ujBXXfIptrzGrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 095/155] power: supply: cpcap-battery: Fix signed counter sample register
Date:   Thu, 13 Jun 2019 10:33:27 +0200
Message-Id: <20190613075658.392164493@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c68b901ac4fa969db8917b6a9f9b40524a690d20 ]

The accumulator sample register is signed 32-bits wide register on
droid 4. And only the earlier version of cpcap has a signed 24-bits
wide register. We're currently passing it around as unsigned, so
let's fix that and use sign_extend32() for the earlier revision.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-battery.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/cpcap-battery.c b/drivers/power/supply/cpcap-battery.c
index 6887870ba32c..453baa8f7d73 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -82,7 +82,7 @@ struct cpcap_battery_config {
 };
 
 struct cpcap_coulomb_counter_data {
-	s32 sample;		/* 24-bits */
+	s32 sample;		/* 24 or 32 bits */
 	s32 accumulator;
 	s16 offset;		/* 10-bits */
 };
@@ -213,7 +213,7 @@ static int cpcap_battery_get_current(struct cpcap_battery_ddata *ddata)
  * TI or ST coulomb counter in the PMIC.
  */
 static int cpcap_battery_cc_raw_div(struct cpcap_battery_ddata *ddata,
-				    u32 sample, s32 accumulator,
+				    s32 sample, s32 accumulator,
 				    s16 offset, u32 divider)
 {
 	s64 acc;
@@ -224,7 +224,6 @@ static int cpcap_battery_cc_raw_div(struct cpcap_battery_ddata *ddata,
 	if (!divider)
 		return 0;
 
-	sample &= 0xffffff;		/* 24-bits, unsigned */
 	offset &= 0x7ff;		/* 10-bits, signed */
 
 	switch (ddata->vendor) {
@@ -259,7 +258,7 @@ static int cpcap_battery_cc_raw_div(struct cpcap_battery_ddata *ddata,
 
 /* 3600000μAms = 1μAh */
 static int cpcap_battery_cc_to_uah(struct cpcap_battery_ddata *ddata,
-				   u32 sample, s32 accumulator,
+				   s32 sample, s32 accumulator,
 				   s16 offset)
 {
 	return cpcap_battery_cc_raw_div(ddata, sample,
@@ -268,7 +267,7 @@ static int cpcap_battery_cc_to_uah(struct cpcap_battery_ddata *ddata,
 }
 
 static int cpcap_battery_cc_to_ua(struct cpcap_battery_ddata *ddata,
-				  u32 sample, s32 accumulator,
+				  s32 sample, s32 accumulator,
 				  s16 offset)
 {
 	return cpcap_battery_cc_raw_div(ddata, sample,
@@ -312,6 +311,8 @@ cpcap_battery_read_accumulated(struct cpcap_battery_ddata *ddata,
 	/* Sample value CPCAP_REG_CCS1 & 2 */
 	ccd->sample = (buf[1] & 0x0fff) << 16;
 	ccd->sample |= buf[0];
+	if (ddata->vendor == CPCAP_VENDOR_TI)
+		ccd->sample = sign_extend32(24, ccd->sample);
 
 	/* Accumulator value CPCAP_REG_CCA1 & 2 */
 	ccd->accumulator = ((s16)buf[3]) << 16;
-- 
2.20.1



