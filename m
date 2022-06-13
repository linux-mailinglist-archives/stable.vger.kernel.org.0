Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447FA54863E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380202AbiFMN6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380711AbiFMNy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:54:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E31C81495;
        Mon, 13 Jun 2022 04:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85FB7CE1233;
        Mon, 13 Jun 2022 11:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71820C34114;
        Mon, 13 Jun 2022 11:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120132;
        bh=jGr8WXM1jdPMD04g4tRJ+Sq3zW2YgJpdz6hJ9tysoig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8XjONzZgUkpabJSdOxJX3caSYz57RVtLh0sm8cVfFm5JsD1ZQh+51xkDER6QLWHc
         3sRLwBQIyLNNbzId5F4ohzQZjV/oLt+EQc+IHZZA+G1V7sLqMDEfmz34OVBFW0xKsc
         1EHxVoRNMfmy5XNvR8YLdvdHz9uLmWBcnelh2jDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 242/339] usb: dwc3: host: Stop setting the ACPI companion
Date:   Mon, 13 Jun 2022 12:11:07 +0200
Message-Id: <20220613094933.994206590@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



