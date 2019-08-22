Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7E099B4C
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391490AbfHVRXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391485AbfHVRXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:30 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EDDF23402;
        Thu, 22 Aug 2019 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494609;
        bh=Z9vCoxmg1F0JBLGhQ5ys9J4j4m/T7XhF6spaclXJU8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CeHdrHBsBH9Gx6FzjYaYGXnO5DuZzzMtj6xrCWgqJynEv614wbL1QTP13g2GohoMT
         WC/WYPbnr2Tc+esSorkPmoYi3EUy3Gw47sQnXzOlyKFe5kOLSk/VhR3eXlNM/MjhaU
         egzoDxmaDiCXlLz268nEX9+2d5arf7tLuyCH3nF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilles Buloz <Gilles.Buloz@kontron.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 033/103] hwmon: (nct7802) Fix wrong detection of in4 presence
Date:   Thu, 22 Aug 2019 10:18:21 -0700
Message-Id: <20190822171730.166122184@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 38ada2f406a9b81fb1249c5c9227fa657e7d5671 upstream.

The code to detect if in4 is present is wrong; if in4 is not present,
the in4_input sysfs attribute is still present.

In detail:

- Ihen RTD3_MD=11 (VSEN3 present), everything is as expected (no bug).
- If we have RTD3_MD!=11 (no VSEN3), we unexpectedly have a in4_input
  file under /sys and the "sensors" command displays in4_input.
  But as expected, we have no in4_min, in4_max, in4_alarm, in4_beep.

Fix is_visible function to detect and report in4_input visibility
as expected.

Reported-by: Gilles Buloz <Gilles.Buloz@kontron.com>
Cc: Gilles Buloz <Gilles.Buloz@kontron.com>
Cc: stable@vger.kernel.org
Fixes: 3434f37835804 ("hwmon: Driver for Nuvoton NCT7802Y")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/nct7802.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/nct7802.c
+++ b/drivers/hwmon/nct7802.c
@@ -768,7 +768,7 @@ static struct attribute *nct7802_in_attr
 	&sensor_dev_attr_in3_alarm.dev_attr.attr,
 	&sensor_dev_attr_in3_beep.dev_attr.attr,
 
-	&sensor_dev_attr_in4_input.dev_attr.attr,	/* 17 */
+	&sensor_dev_attr_in4_input.dev_attr.attr,	/* 16 */
 	&sensor_dev_attr_in4_min.dev_attr.attr,
 	&sensor_dev_attr_in4_max.dev_attr.attr,
 	&sensor_dev_attr_in4_alarm.dev_attr.attr,
@@ -794,9 +794,9 @@ static umode_t nct7802_in_is_visible(str
 
 	if (index >= 6 && index < 11 && (reg & 0x03) != 0x03)	/* VSEN1 */
 		return 0;
-	if (index >= 11 && index < 17 && (reg & 0x0c) != 0x0c)	/* VSEN2 */
+	if (index >= 11 && index < 16 && (reg & 0x0c) != 0x0c)	/* VSEN2 */
 		return 0;
-	if (index >= 17 && (reg & 0x30) != 0x30)		/* VSEN3 */
+	if (index >= 16 && (reg & 0x30) != 0x30)		/* VSEN3 */
 		return 0;
 
 	return attr->mode;


