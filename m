Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717286321A1
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiKUMK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKUMKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:10:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A2F73412
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2A30B80ED5
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23101C433C1;
        Mon, 21 Nov 2022 12:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669032650;
        bh=wImyoB+2TmoVjO/ipgY0TvoxZsfxozqcD7iEJHkE/W8=;
        h=Subject:To:Cc:From:Date:From;
        b=1YgKAzh6xyjLSsIstJApaHSI2iRq0wjll7XQhykiZTbrKMKuoEfucvywo1O5VASW5
         6XXJZg8//9/dwfMWmAzlXhHdr4HZWqnXQVIMWGYQCxpVPSbn50ujWvgUIfE0fqkyC4
         8bf3jaX2AS4245EYnAfpSGpgwtdGlN2bdBOzomPU=
Subject: FAILED: patch "[PATCH] mmc: sdhci-pci: Fix possible memory leak caused by missing" failed to apply to 4.9-stable tree
To:     wangxiongfeng2@huawei.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 13:10:47 +0100
Message-ID: <166903264711327@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

222cfa0118aa ("mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()")
c31165d7400b ("mmc: sdhci-pci: Add support for HS200 tuning mode on AMD, eMMC-4.5.1")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 222cfa0118aa68687ace74aab8fdf77ce8fbd7e6 Mon Sep 17 00:00:00 2001
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Date: Mon, 14 Nov 2022 16:31:00 +0800
Subject: [PATCH] mmc: sdhci-pci: Fix possible memory leak caused by missing
 pci_dev_put()

pci_get_device() will increase the reference count for the returned
pci_dev. We need to use pci_dev_put() to decrease the reference count
before amd_probe() returns. There is no problem for the 'smbus_dev ==
NULL' branch because pci_dev_put() can also handle the NULL input
parameter case.

Fixes: 659c9bc114a8 ("mmc: sdhci-pci: Build o2micro support in the same module")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221114083100.149200-1-wangxiongfeng2@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index 34ea1acbb3cc..28dc65023fa9 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1749,6 +1749,8 @@ static int amd_probe(struct sdhci_pci_chip *chip)
 		}
 	}
 
+	pci_dev_put(smbus_dev);
+
 	if (gen == AMD_CHIPSET_BEFORE_ML || gen == AMD_CHIPSET_CZ)
 		chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
 

