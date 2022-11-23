Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EB663563B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237708AbiKWJ2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237866AbiKWJ11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:27:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367901121DD
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:26:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13B7E61B40
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4D5C433D6;
        Wed, 23 Nov 2022 09:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195575;
        bh=voZyQ/WNhiiu4Tog3XyfvbVXbVLspACgm7ujhTthIKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcpMjWqYRTOQN0bOW0aPemmtkPPyx+U80F/sR0B0LpJFw/xhbQ3qjyZP+sN23sJAA
         MSAHrgL8KUpwFwfiRrKY6jVp9dIUaR1O5whQiYUhmo++cZVlgrNJnx75vlRwlr6HPV
         LNBPtwMcuiLWOMO3Hoh0W9Zfm4PD+UaANq+dxbKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 122/149] mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()
Date:   Wed, 23 Nov 2022 09:51:45 +0100
Message-Id: <20221123084602.329077357@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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
@@ -1799,6 +1799,8 @@ static int amd_probe(struct sdhci_pci_ch
 		}
 	}
 
+	pci_dev_put(smbus_dev);
+
 	if (gen == AMD_CHIPSET_BEFORE_ML || gen == AMD_CHIPSET_CZ)
 		chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
 


