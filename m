Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0946D540A40
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbiFGSTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352088AbiFGSQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F3513393A;
        Tue,  7 Jun 2022 10:50:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 850F5B82340;
        Tue,  7 Jun 2022 17:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BD8C3411C;
        Tue,  7 Jun 2022 17:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624223;
        bh=jGr8WXM1jdPMD04g4tRJ+Sq3zW2YgJpdz6hJ9tysoig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAcUeu7QSnJjSR2faZQyjEwvrjDalVv2ZSN+cFIG/RTE1nVk3MuacFmVW655vVIJE
         GTho+AFPcq2Qq49Qv51+CBOZyjNndhxFG4N8x8sRREan/y/E4iA2FJgGvZGG0DHuz0
         8DPsKJnH9i0UGqEJtamlpTtv8IVx0WNVBdJwkoSQyaA1d1a+KGgzHgURGeCX6GZSoD
         vQyjKEwkpB27sd286cr2ULOTBYQzO8T3C7rlXNElYZByr6DIZkXC8wfUlAbPnm+Wz1
         m8PZVWfqmS3P3WogXojaQKf63GlYbKg22VZJqgFL2JaJ7tmmANdLAcPFvi7NpCScM5
         SmXDHBTWqq44A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 20/68] usb: dwc3: host: Stop setting the ACPI companion
Date:   Tue,  7 Jun 2022 13:47:46 -0400
Message-Id: <20220607174846.477972-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 7fd069d65da2e20b1caec3b7bcf9dfbe28c04bb2 ]

It is no longer needed. The sysdev pointer is now used when
assigning the ACPI companions to the xHCI ports and USB
devices.

Assigning the ACPI companion here resulted in the
fwnode->secondary pointer to be replaced also for the parent
dwc3 device since the primary fwnode (the ACPI companion)
was shared. That was unintentional and it created potential
side effects like resource leaks.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20220428111056.3558-3-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/host.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index eda871973d6c..f56c30cf151e 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -7,7 +7,6 @@
  * Authors: Felipe Balbi <balbi@ti.com>,
  */
 
-#include <linux/acpi.h>
 #include <linux/irq.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -83,7 +82,6 @@ int dwc3_host_init(struct dwc3 *dwc)
 	}
 
 	xhci->dev.parent	= dwc->dev;
-	ACPI_COMPANION_SET(&xhci->dev, ACPI_COMPANION(dwc->dev));
 
 	dwc->xhci = xhci;
 
-- 
2.35.1

