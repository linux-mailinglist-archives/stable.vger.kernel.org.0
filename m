Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96926540B4C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243261AbiFGS1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352478AbiFGSVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:21:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59E833EBD;
        Tue,  7 Jun 2022 10:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 233A3617A6;
        Tue,  7 Jun 2022 17:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1264C36AFE;
        Tue,  7 Jun 2022 17:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624431;
        bh=jGr8WXM1jdPMD04g4tRJ+Sq3zW2YgJpdz6hJ9tysoig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6RxyhMgWe3KXu4OCXb9MBy1VkR4+tvHfQ3kJmL2t9noNmH5W9luWtTzUcv/8mven
         ETvjFPhex8jpwkKtIpLDsCytab1huTQmbiwuSgXdnugtYhbp79hHDI70ZJXNH3i3xm
         aicld636PiQrToTuj/tMSug1GqhxsYvbPa5EP0B1KCQPBvFF3/e28bI1vvO+2qduht
         bk2+fdpSB+7L6PKMh/dbkSEHnFbNyhMBniGwgH1twmoav2Yrx6ca+1cpEEg8IKkDMS
         RtGy64EP8QTbdABGbLbezk33m+E6EH+ESRDNQgu4ow0Hdi1ERs3DI6/p3Q6J9ISEFj
         v2ZlpotvuFniQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 19/60] usb: dwc3: host: Stop setting the ACPI companion
Date:   Tue,  7 Jun 2022 13:52:16 -0400
Message-Id: <20220607175259.478835-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
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

