Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B3F421012
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbhJDNk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238558AbhJDNio (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 930DF6323D;
        Mon,  4 Oct 2021 13:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353469;
        bh=HAXHvd38nLZh1//qgjGynSrYXsQ4pGRzDCFaDW+elBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uyn5Qn/pSaAt6jH0SlhOCk5wK+hu4X6gEdJGSEOlZ8KoRDFvPIskokWHLB56o6dYy
         4EoVO5LQT53mUfL87phqfMhnDUDzyNkTTd/nPpadG3prD9WHW+dmuij/e9T5KIt5Pa
         D4nFEI49/5GQSKi+W0t8Rg8ZYCtDJI5sKG3sOWq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 141/172] hwmon: (occ) Fix P10 VRM temp sensors
Date:   Mon,  4 Oct 2021 14:53:11 +0200
Message-Id: <20211004125049.523260646@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit ffa2600044979aff4bd6238edb9af815a47d7c32 ]

The P10 (temp sensor version 0x10) doesn't do the same VRM status
reporting that was used on P9. It just reports the temperature, so
drop the check for VRM fru type in the sysfs show function, and don't
set the name to "alarm".

Fixes: db4919ec86 ("hwmon: (occ) Add new temperature sensor type")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20210929153604.14968-1-eajames@linux.ibm.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index 0d68a78be980..ae664613289c 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -340,18 +340,11 @@ static ssize_t occ_show_temp_10(struct device *dev,
 		if (val == OCC_TEMP_SENSOR_FAULT)
 			return -EREMOTEIO;
 
-		/*
-		 * VRM doesn't return temperature, only alarm bit. This
-		 * attribute maps to tempX_alarm instead of tempX_input for
-		 * VRM
-		 */
-		if (temp->fru_type != OCC_FRU_TYPE_VRM) {
-			/* sensor not ready */
-			if (val == 0)
-				return -EAGAIN;
+		/* sensor not ready */
+		if (val == 0)
+			return -EAGAIN;
 
-			val *= 1000;
-		}
+		val *= 1000;
 		break;
 	case 2:
 		val = temp->fru_type;
@@ -886,7 +879,7 @@ static int occ_setup_sensor_attrs(struct occ *occ)
 					     0, i);
 		attr++;
 
-		if (sensors->temp.version > 1 &&
+		if (sensors->temp.version == 2 &&
 		    temp->fru_type == OCC_FRU_TYPE_VRM) {
 			snprintf(attr->name, sizeof(attr->name),
 				 "temp%d_alarm", s);
-- 
2.33.0



