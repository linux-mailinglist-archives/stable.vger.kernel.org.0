Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D521CAF06
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgEHNNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbgEHMre (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BD63221F7;
        Fri,  8 May 2020 12:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942053;
        bh=bRR7+Wt0KW3XZsS+U5E1tbRXNPnI9ewZ/XNpGEAXPzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOQLJV76OU7bJD9agikphQUWhxJvqheoPd8klOuOJMWvbNF13zDHoUrBn94ucwEpK
         BOdA4hWBcf1HuVytOBPLcEegr09hpaK91r3Z2K6SqPsLUyNfSIgl4nLFAeMAzmc+yo
         8LQvN+BXV27cqiHH7sEOYrM58fh/WfdAit8/dO2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        "Andrew F. Davis" <afd@ti.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 4.4 228/312] power: bq27xxx: fix reading for bq27000 and bq27010
Date:   Fri,  8 May 2020 14:33:39 +0200
Message-Id: <20200508123140.483956333@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 549d7b317c761dbf4ed0c2945aec3acc9ca7ae14 upstream.

bug: the driver reports funny capacity values:

root@letux:/sys/class/power_supply/bq27000-battery# cat uevent
POWER_SUPPLY_NAME=bq27000-battery
POWER_SUPPLY_STATUS=Charging
POWER_SUPPLY_PRESENT=1
POWER_SUPPLY_VOLTAGE_NOW=3702000
POWER_SUPPLY_CURRENT_NOW=-464635
POWER_SUPPLY_CAPACITY=1536			<- over 100% is magic
POWER_SUPPLY_CAPACITY_LEVEL=Normal
POWER_SUPPLY_TEMP=311
POWER_SUPPLY_TIME_TO_FULL_NOW=10440
POWER_SUPPLY_TECHNOLOGY=Li-ion
POWER_SUPPLY_CHARGE_FULL=805450
POWER_SUPPLY_CHARGE_NOW=1068
POWER_SUPPLY_CHARGE_FULL_DESIGN=8844998	<- battery has just 1200 mAh
POWER_SUPPLY_CYCLE_COUNT=21
POWER_SUPPLY_ENERGY_NOW=0
POWER_SUPPLY_POWER_AVG=0
POWER_SUPPLY_HEALTH=Good
POWER_SUPPLY_MANUFACTURER=Texas Instruments

reason: the state of charge and the design capacity register are single
byte only. The design capacity returns the higer order byte.

tested: GTA04 with Openmoko/FIC HF08x battery (using hdq)

Fixes: d74534c27775 ("power: bq27xxx_battery: Add support for additional bq27xxx family devices")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Andrew F. Davis <afd@ti.com>
Reviewed-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/bq27xxx_battery.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/power/bq27xxx_battery.c
+++ b/drivers/power/bq27xxx_battery.c
@@ -471,7 +471,10 @@ static int bq27xxx_battery_read_soc(stru
 {
 	int soc;
 
-	soc = bq27xxx_read(di, BQ27XXX_REG_SOC, false);
+	if (di->chip == BQ27000 || di->chip == BQ27010)
+		soc = bq27xxx_read(di, BQ27XXX_REG_SOC, true);
+	else
+		soc = bq27xxx_read(di, BQ27XXX_REG_SOC, false);
 
 	if (soc < 0)
 		dev_dbg(di->dev, "error reading State-of-Charge\n");
@@ -536,7 +539,10 @@ static int bq27xxx_battery_read_dcap(str
 {
 	int dcap;
 
-	dcap = bq27xxx_read(di, BQ27XXX_REG_DCAP, false);
+	if (di->chip == BQ27000 || di->chip == BQ27010)
+		dcap = bq27xxx_read(di, BQ27XXX_REG_DCAP, true);
+	else
+		dcap = bq27xxx_read(di, BQ27XXX_REG_DCAP, false);
 
 	if (dcap < 0) {
 		dev_dbg(di->dev, "error reading initial last measured discharge\n");
@@ -544,7 +550,7 @@ static int bq27xxx_battery_read_dcap(str
 	}
 
 	if (di->chip == BQ27000 || di->chip == BQ27010)
-		dcap *= BQ27XXX_CURRENT_CONSTANT / BQ27XXX_RS;
+		dcap = (dcap << 8) * BQ27XXX_CURRENT_CONSTANT / BQ27XXX_RS;
 	else
 		dcap *= 1000;
 


