Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE275419BC8
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbhI0RWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237004AbhI0RUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C507D61353;
        Mon, 27 Sep 2021 17:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762793;
        bh=NZAdhYbzktd9+Nks2wFC4dKjzc6MPwQ4GMyA7d7CVyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9TeZPgjKZz8JNNcsSKK9QumYyDjgB0Yt11BSHhDdlnPRclacRsMqLTS+SBR/czln
         CniUkgO2aiJ3Qm/lBHpW0n2++Jzt2ppaIy14wYjN3JLHh26ul7pdqiqDfd/j2KV3V7
         PKOs6ZT47QZpUbtJdHHcg+cRJ7CM1mqagao+7xYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 052/162] platform/x86/intel: punit_ipc: Drop wrong use of ACPI_PTR()
Date:   Mon, 27 Sep 2021 19:01:38 +0200
Message-Id: <20210927170235.301017260@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 349bff48ae0f5f8aa2075d0bdc2091a30bd634f6 ]

ACPI_PTR() is more harmful than helpful. For example, in this case
if CONFIG_ACPI=n, the ID table left unused which is not what we want.

Instead of adding ifdeffery here and there, drop ACPI_PTR()
and unused acpi.h.

Fixes: fdca4f16f57d ("platform:x86: add Intel P-Unit mailbox IPC driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210827145310.76239-1-andriy.shevchenko@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_punit_ipc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_punit_ipc.c b/drivers/platform/x86/intel_punit_ipc.c
index f58b8543f6ac..66bb39fd0ef9 100644
--- a/drivers/platform/x86/intel_punit_ipc.c
+++ b/drivers/platform/x86/intel_punit_ipc.c
@@ -8,7 +8,6 @@
  * which provide mailbox interface for power management usage.
  */
 
-#include <linux/acpi.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -319,7 +318,7 @@ static struct platform_driver intel_punit_ipc_driver = {
 	.remove = intel_punit_ipc_remove,
 	.driver = {
 		.name = "intel_punit_ipc",
-		.acpi_match_table = ACPI_PTR(punit_ipc_acpi_ids),
+		.acpi_match_table = punit_ipc_acpi_ids,
 	},
 };
 
-- 
2.33.0



