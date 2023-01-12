Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD8066764D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbjALOai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbjALO3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:29:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D825D893
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:21:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C1CDB81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486B1C433EF;
        Thu, 12 Jan 2023 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533274;
        bh=kXM2YC74/Uuz4Vd4Y7hKGHZ588c+Ckaz/CyfxUjsPGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkL/nK8Rs0GZe3OdbYM0Q2R8PxTOjHmhg61wSYGLB3Cixa+jYl4lacpeqzhtl4hdW
         6QouKqYV1hMUh+HNk2Y3Ybc1rdLI5Q7gwRGk7lFCMX2zgudT3jznEdR5Urh2lqZgUr
         Cr4jtrl1V3q8RQDP1qrpkycJuyeNDzh/6XB5rEpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/783] rtc: cmos: Disable ACPI RTC event on removal
Date:   Thu, 12 Jan 2023 14:52:21 +0100
Message-Id: <20230112135544.016579342@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 83ebb7b3036d151ee39a4a752018665648fc3bd4 ]

Make cmos_do_remove() drop the ACPI RTC fixed event handler so as to
prevent it from operating on stale data in case the event triggers
after driver removal.

Fixes: 311ee9c151ad ("rtc: cmos: allow using ACPI for RTC alarm instead of HPET")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/2224609.iZASKD2KPV@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index dd05c12dada8..7f560937bf7c 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -804,6 +804,14 @@ static void acpi_rtc_event_setup(struct device *dev)
 	acpi_disable_event(ACPI_EVENT_RTC, 0);
 }
 
+static void acpi_rtc_event_cleanup(void)
+{
+	if (acpi_disabled)
+		return;
+
+	acpi_remove_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler);
+}
+
 static void rtc_wake_on(struct device *dev)
 {
 	acpi_clear_event(ACPI_EVENT_RTC);
@@ -890,6 +898,10 @@ static inline void acpi_rtc_event_setup(struct device *dev)
 {
 }
 
+static inline void acpi_rtc_event_cleanup(void)
+{
+}
+
 static inline void acpi_cmos_wake_setup(struct device *dev)
 {
 }
@@ -1143,6 +1155,9 @@ static void cmos_do_remove(struct device *dev)
 			hpet_unregister_irq_handler(cmos_interrupt);
 	}
 
+	if (!dev_get_platdata(dev))
+		acpi_rtc_event_cleanup();
+
 	cmos->rtc = NULL;
 
 	ports = cmos->iomem;
-- 
2.35.1



