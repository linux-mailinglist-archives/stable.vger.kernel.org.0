Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751F52EE671
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 20:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbhAGT6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 14:58:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:35272 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAGT63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 14:58:29 -0500
IronPort-SDR: OkeivqDMtQbnB2kDJSlHcxfDRmfPQbM/AIfPhJMZbQ/dlb4i6hXZIikgH/kA7H525IyYcBjzKH
 GyoolpDHAFHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="173979227"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="173979227"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 11:57:48 -0800
IronPort-SDR: meS7Rg6Hs3z5SPe5OJ/IuiC7PU0y9zG6WV4dczcf+KtWVJi0/Fg7p8z9AUmsBG/Siu8kaYKzDa
 vmPS94hjILSg==
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="379837366"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.138])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 11:57:46 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [watchdog] watchdog: mei_wdt: request stop on unregister
Date:   Thu,  7 Jan 2021 21:57:30 +0200
Message-Id: <20210107195730.1660449-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Send the stop command to the firmware on watchdog unregister
to eleminate false event on suspend.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
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

