Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913734A40A5
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348412AbiAaK6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:58:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348403AbiAaK6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:58:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3DF3B82A5E;
        Mon, 31 Jan 2022 10:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C68C340E8;
        Mon, 31 Jan 2022 10:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626719;
        bh=41Bn7dpcwKdRVGJAeUT3KkBCidaikRKvL17gJkZ77QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIxjDb3c21FkzYEuVqiM45ESjB23w6UEuXWmEXPkk4TwEosjUzIDD/AhFEsH/8wV9
         JKXNpGwYLTdcgnbbTeNF7GP/2H1jJFXspbUQVVR9/8bvXUpbDWT326t4vKG6KUKwFh
         Dydl67cqncuc6+F52bVuQXOCDEduFWXhAbos8zyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 5.4 18/64] usb: common: ulpi: Fix crash in ulpi_match()
Date:   Mon, 31 Jan 2022 11:56:03 +0100
Message-Id: <20220131105216.275584125@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit 2e3dd4a6246945bf84ea6f478365d116e661554c upstream.

Commit 7495af930835 ("ARM: multi_v7_defconfig: Enable drivers for
DragonBoard 410c") enables the CONFIG_PHY_QCOM_USB_HS for the ARM
multi_v7_defconfig. Enabling this Kconfig is causing the kernel to crash
on the Tegra20 Ventana platform in the ulpi_match() function.

The Qualcomm USB HS PHY driver that is enabled by CONFIG_PHY_QCOM_USB_HS,
registers a ulpi_driver but this driver does not provide an 'id_table',
so when ulpi_match() is called on the Tegra20 Ventana platform, it
crashes when attempting to deference the id_table pointer which is not
valid. The Qualcomm USB HS PHY driver uses device-tree for matching the
ULPI driver with the device and so fix this crash by using device-tree
for matching if the id_table is not valid.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20220117150039.44058-1-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -39,8 +39,11 @@ static int ulpi_match(struct device *dev
 	struct ulpi *ulpi = to_ulpi_dev(dev);
 	const struct ulpi_device_id *id;
 
-	/* Some ULPI devices don't have a vendor id so rely on OF match */
-	if (ulpi->id.vendor == 0)
+	/*
+	 * Some ULPI devices don't have a vendor id
+	 * or provide an id_table so rely on OF match.
+	 */
+	if (ulpi->id.vendor == 0 || !drv->id_table)
 		return of_driver_match_device(dev, driver);
 
 	for (id = drv->id_table; id->vendor; id++)


