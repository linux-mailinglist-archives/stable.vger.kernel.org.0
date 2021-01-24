Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7744301B8C
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 12:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbhAXLvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 06:51:16 -0500
Received: from mga06.intel.com ([134.134.136.31]:22732 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726904AbhAXLuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 06:50:32 -0500
IronPort-SDR: 04r2c8Z/NMlAnrPFlXlPWtRgL1v1VRJVJbI7mL07xRNkMMImX+XhOXtGbR23dts8etrZWjBFIx
 gyL2okH8mOjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9873"; a="241148559"
X-IronPort-AV: E=Sophos;i="5.79,371,1602572400"; 
   d="scan'208";a="241148559"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2021 03:49:51 -0800
IronPort-SDR: DKtA1IrDy53e5SYhvH9xaepu8Nbr2v6aDb5vdMfpyNVLwV3rGPDmpXtxfBsDIfAxpNEF9eptMa
 vrpsl6pZsUBg==
X-IronPort-AV: E=Sophos;i="5.79,371,1602572400"; 
   d="scan'208";a="368194809"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.138])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2021 03:49:48 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [watchdog v2] watchdog: mei_wdt: request stop on unregister
Date:   Sun, 24 Jan 2021 13:49:38 +0200
Message-Id: <20210124114938.373885-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

The MEI bus has a special behavior on suspend it destroys
all the attached devices, this is due to the fact that also
firmware context is not persistent across power flows.

If watchdog on MEI bus is ticking before suspending the firmware
times out and reports that the OS is missing watchdog tick.
Send the stop command to the firmware on watchdog unregistered
to eliminate the false event on suspend.
This does not make the things worse from the user-space perspective
as a user-space should re-open watchdog device after
suspending before this patch.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: Update the commit message with better explanation

 drivers/watchdog/mei_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/mei_wdt.c b/drivers/watchdog/mei_wdt.c
index 5391bf3e6b11..c5967d8b4256 100644
--- a/drivers/watchdog/mei_wdt.c
+++ b/drivers/watchdog/mei_wdt.c
@@ -382,6 +382,7 @@ static int mei_wdt_register(struct mei_wdt *wdt)
 
 	watchdog_set_drvdata(&wdt->wdd, wdt);
 	watchdog_stop_on_reboot(&wdt->wdd);
+	watchdog_stop_on_unregister(&wdt->wdd);
 
 	ret = watchdog_register_device(&wdt->wdd);
 	if (ret)
-- 
2.26.2

