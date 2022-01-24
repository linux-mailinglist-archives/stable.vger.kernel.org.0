Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20E94989DF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344701AbiAXS65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344454AbiAXS4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:56:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543D5C0612A8;
        Mon, 24 Jan 2022 10:54:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C9B1B81235;
        Mon, 24 Jan 2022 18:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48701C340E7;
        Mon, 24 Jan 2022 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050465;
        bh=qcG9Tun+JuSkYfdP86U9ugYq/gIq4GAX/x3IPX3Gbxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIxHNwcdFFfZEHxHO9sOhb4NHwSd8rCRPqJDX3INiA52N6U76BH2JQfRWqFcRY5OU
         tdB7f0gQhwlwwvkX1Ipjb3LIql8Df8hQwBboA12+EB/3efUmYoFJLZMk1o0MDxYoda
         dr/Wd1svBy6lQzMmmXOU7GNhdk6MW90+bbglNHlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aditya Garg <gargaditya08@live.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 004/157] mfd: intel-lpss: Fix too early PM enablement in the ACPI ->probe()
Date:   Mon, 24 Jan 2022 19:41:34 +0100
Message-Id: <20220124183932.926947993@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit c9e143084d1a602f829115612e1ec79df3727c8b upstream.

The runtime PM callback may be called as soon as the runtime PM facility
is enabled and activated. It means that ->suspend() may be called before
we finish probing the device in the ACPI case. Hence, NULL pointer
dereference:

  intel-lpss INT34BA:00: IRQ index 0 not found
  BUG: kernel NULL pointer dereference, address: 0000000000000030
  ...
  Workqueue: pm pm_runtime_work
  RIP: 0010:intel_lpss_suspend+0xb/0x40 [intel_lpss]

To fix this, first try to register the device and only after that enable
runtime PM facility.

Fixes: 4b45efe85263 ("mfd: Add support for Intel Sunrisepoint LPSS devices")
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Reported-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211101190008.86473-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/intel-lpss-acpi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/mfd/intel-lpss-acpi.c
+++ b/drivers/mfd/intel-lpss-acpi.c
@@ -84,6 +84,7 @@ static int intel_lpss_acpi_probe(struct
 {
 	struct intel_lpss_platform_info *info;
 	const struct acpi_device_id *id;
+	int ret;
 
 	id = acpi_match_device(intel_lpss_acpi_ids, &pdev->dev);
 	if (!id)
@@ -97,10 +98,14 @@ static int intel_lpss_acpi_probe(struct
 	info->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	info->irq = platform_get_irq(pdev, 0);
 
+	ret = intel_lpss_probe(&pdev->dev, info);
+	if (ret)
+		return ret;
+
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	return intel_lpss_probe(&pdev->dev, info);
+	return 0;
 }
 
 static int intel_lpss_acpi_remove(struct platform_device *pdev)


