Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3478DB13
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbfHNRIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730108AbfHNRIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:08:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDD20216F4;
        Wed, 14 Aug 2019 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802498;
        bh=WUqGA5sSF94AVkt1Y/70tI6qVQor9P9h2wrIsLeR4wE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAkErKGQeBFaYbRtAMGcsYp0d/7Eu7ZIivET+kqzSYuWPnsM8lo8WkSiJrPrIDIoD
         wtY1tc4QZmCEpPKM6gHy/XustVnH+qAGQWI1ZOGzZIXlS43kwnopm0HmFC5sP2nOVB
         iGAh3W2Jesc8DXvhmtlfjCupYmiFulFDDS1aGaZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilles Buloz <Gilles.Buloz@kontron.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.2 123/144] hwmon: (nct7802) Fix wrong detection of in4 presence
Date:   Wed, 14 Aug 2019 19:01:19 +0200
Message-Id: <20190814165805.076972552@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
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
@@ -704,7 +704,7 @@ static struct attribute *nct7802_in_attr
 	&sensor_dev_attr_in3_alarm.dev_attr.attr,
 	&sensor_dev_attr_in3_beep.dev_attr.attr,
 
-	&sensor_dev_attr_in4_input.dev_attr.attr,	/* 17 */
+	&sensor_dev_attr_in4_input.dev_attr.attr,	/* 16 */
 	&sensor_dev_attr_in4_min.dev_attr.attr,
 	&sensor_dev_attr_in4_max.dev_attr.attr,
 	&sensor_dev_attr_in4_alarm.dev_attr.attr,
@@ -730,9 +730,9 @@ static umode_t nct7802_in_is_visible(str
 
 	if (index >= 6 && index < 11 && (reg & 0x03) != 0x03)	/* VSEN1 */
 		return 0;
-	if (index >= 11 && index < 17 && (reg & 0x0c) != 0x0c)	/* VSEN2 */
+	if (index >= 11 && index < 16 && (reg & 0x0c) != 0x0c)	/* VSEN2 */
 		return 0;
-	if (index >= 17 && (reg & 0x30) != 0x30)		/* VSEN3 */
+	if (index >= 16 && (reg & 0x30) != 0x30)		/* VSEN3 */
 		return 0;
 
 	return attr->mode;


