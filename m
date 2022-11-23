Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435A16354D1
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237117AbiKWJI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237149AbiKWJId (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:08:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B8E2A721
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:08:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E650FB81EF7
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E2FC433C1;
        Wed, 23 Nov 2022 09:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194505;
        bh=TDWJo+/Q0HmTyJ5NlMkhdnd/YOSlhX4ihMxZwGXkQv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDCoIvNBcH/gzO75/dH64+Whs05schwthwHLQXuIL0+yVmWb472+f2p5Z8oVYB2Ym
         MMo9QhNzAdi8k0mDDE+Ei/x3m6WS2WBSAQoWZcS+hfJFoqCoHBuy9azh/OEs9ms5i2
         eyOAjcgy7bL7fcEckDeNj56vZe94nUPp0prYwQbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 096/114] mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()
Date:   Wed, 23 Nov 2022 09:51:23 +0100
Message-Id: <20221123084555.619688271@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

commit 222cfa0118aa68687ace74aab8fdf77ce8fbd7e6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1532,6 +1532,8 @@ static int amd_probe(struct sdhci_pci_ch
 		}
 	}
 
+	pci_dev_put(smbus_dev);
+
 	if (gen == AMD_CHIPSET_BEFORE_ML || gen == AMD_CHIPSET_CZ)
 		chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
 


