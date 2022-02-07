Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BA84ABAAC
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383995AbiBGLYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237060AbiBGLLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:11:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA56C043181;
        Mon,  7 Feb 2022 03:11:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EF0CB80EE8;
        Mon,  7 Feb 2022 11:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F40C004E1;
        Mon,  7 Feb 2022 11:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232259;
        bh=fUmpoc5Q7kPSh3lk2DSZ6dxRzwy8WuVR6z88Xi+OUNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pz9xh9DBC7/x1Ph/34OFwyOjBxvbss3Wha9390I3bT5yKVUpY5JQ4GjpJWy94eoae
         6lE3cqfn0zP59b/YhuPmVRDbrc1nmnidOkEP714l82UKGwlUzCNQSzSZys5uoFKeZ2
         nQqfup1ll5LckON3KB91/Yb2HQinDLwfWkygcPS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 4.14 12/69] usb: common: ulpi: Fix crash in ulpi_match()
Date:   Mon,  7 Feb 2022 12:05:34 +0100
Message-Id: <20220207103756.018983504@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
@@ -42,8 +42,11 @@ static int ulpi_match(struct device *dev
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


