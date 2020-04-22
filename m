Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12A41B3EC5
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbgDVKbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730627AbgDVKZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:25:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADFAD20784;
        Wed, 22 Apr 2020 10:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551153;
        bh=uJOLIfl4FKvP8Jesaa0wKyt+zFZumfqh+bE3cWD19U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8eZmFoJS2H+Yr1cgNHKnzbwPPepY7/i4fMZ7q0F7otYG5QuA6iGl1U/Ee1A2rPAT
         RXjwbmPIORddSTvSg7V30bJbaWAN7fVc488jSvrwlzpV0ytstGUu2E/D0t+hiIp3hi
         4RyNS9oMIBDd6f+Y4hSV4GbtUhOPjDqd3DNDwSGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashant Malani <pmalani@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 123/166] mfd: cros_ec: Check DT node for usbpd-notify add
Date:   Wed, 22 Apr 2020 11:57:30 +0200
Message-Id: <20200422095101.757435001@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit f8db89d14efb770dd59aa0ca74386e5de68310d5 ]

Add a check to ensure there is indeed an EC device tree entry before
adding the cros-usbpd-notify device. This covers configs where both
CONFIG_ACPI and CONFIG_OF are defined, but the EC device is defined
using device tree and not in ACPI.

Fixes: 4602dce0361e ("mfd: cros_ec: Add cros-usbpd-notify subdevice")
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/cros_ec_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
index 39e6116950536..32c2b912b58b2 100644
--- a/drivers/mfd/cros_ec_dev.c
+++ b/drivers/mfd/cros_ec_dev.c
@@ -211,7 +211,7 @@ static int ec_device_probe(struct platform_device *pdev)
 	 * explicitly added on platforms that don't have the PD notifier ACPI
 	 * device entry defined.
 	 */
-	if (IS_ENABLED(CONFIG_OF)) {
+	if (IS_ENABLED(CONFIG_OF) && ec->ec_dev->dev->of_node) {
 		if (cros_ec_check_features(ec, EC_FEATURE_USB_PD)) {
 			retval = mfd_add_hotplug_devices(ec->dev,
 					cros_usbpd_notify_cells,
-- 
2.20.1



