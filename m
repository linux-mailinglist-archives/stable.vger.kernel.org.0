Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F0166CAF9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjAPRJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234368AbjAPRI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:08:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2A8265A7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:49:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFE5B60F63
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78E7C433D2;
        Mon, 16 Jan 2023 16:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887763;
        bh=TBbyprcp1iJeN3eqoH5p2XjwuTH/gejq73IdvlNpDA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vYjygsI2t8l0hp6qKNZYKFbGvC2LHYTN81o6dXVCBNa1J6+/dFSo5LaY8h8wA9Uvh
         nlJQT7xO/Ddb4uIpJZ8eck2Sg4Eboa1sLCb2KXHti26fvAcI0Ye61nPBNCgwXP51Yw
         uj36Doj5M57Aa2jlA4rOFmt2AnH/3bslv3KnhrRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 273/521] rtc: cmos: Rename ACPI-related functions
Date:   Mon, 16 Jan 2023 16:48:55 +0100
Message-Id: <20230116154859.363293632@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit d13e9ad9f5146f066a5c5a1cc993d09e4fb21ead ]

The names of rtc_wake_setup() and cmos_wake_setup() don't indicate
that these functions are ACPI-related, which is the case, and the
former doesn't really reflect the role of the function.

Rename them to acpi_rtc_event_setup() and acpi_cmos_wake_setup(),
respectively, to address this shortcoming.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/3225614.44csPzL39Z@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 909cb1d4a4d5..0c035c5a5ae6 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -742,7 +742,7 @@ static u32 rtc_handler(void *context)
 	return ACPI_INTERRUPT_HANDLED;
 }
 
-static void rtc_wake_setup(struct device *dev)
+static void acpi_rtc_event_setup(struct device *dev)
 {
 	if (acpi_disabled)
 		return;
@@ -786,7 +786,7 @@ static void use_acpi_alarm_quirks(void)
 static inline void use_acpi_alarm_quirks(void) { }
 #endif
 
-static void cmos_wake_setup(struct device *dev)
+static void acpi_cmos_wake_setup(struct device *dev)
 {
 	if (acpi_disabled)
 		return;
@@ -838,11 +838,11 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 
 #else /* !CONFIG_ACPI */
 
-static inline void rtc_wake_setup(struct device *dev)
+static inline void acpi_rtc_event_setup(struct device *dev)
 {
 }
 
-static inline void cmos_wake_setup(struct device *dev)
+static inline void acpi_cmos_wake_setup(struct device *dev)
 {
 }
 
@@ -944,7 +944,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 			cmos_rtc.wake_off = info->wake_off;
 		}
 	} else {
-		cmos_wake_setup(dev);
+		acpi_cmos_wake_setup(dev);
 	}
 
 	if (cmos_rtc.day_alrm >= 128)
@@ -1042,7 +1042,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	 * the ACPI RTC fixed event.
 	 */
 	if (!info)
-		rtc_wake_setup(dev);
+		acpi_rtc_event_setup(dev);
 
 	dev_info(dev, "%s%s, %d bytes nvram%s\n",
 		 !is_valid_irq(rtc_irq) ? "no alarms" :
-- 
2.35.1



