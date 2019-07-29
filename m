Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434C4794F9
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388680AbfG2ThV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387593AbfG2ThU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:37:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F09A1217D4;
        Mon, 29 Jul 2019 19:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429039;
        bh=gFk9XqxV9n7m123vlEFydW55mude7sjmMtB/SipHeXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbztkj0QndetcqJUPH4f5NUEFd0H4R9PZgHu28T3AKOQUkpxX+MrHpEbf6R8htLIA
         Ir8sBr/+1k1027YA7R6xf8RyNyEYfeQU4Sm5AGt/jiYDVj5FPB5K5AzceEga8EDFtN
         QCo7IO+pQ1/pL9o2EkboreUrTCcKhH99kHiwmEic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 264/293] PCI: dwc: pci-dra7xx: Fix compilation when !CONFIG_GPIOLIB
Date:   Mon, 29 Jul 2019 21:22:35 +0200
Message-Id: <20190729190844.606539908@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 381ed79c8655a40268ee7391f716edd90c5c3a97 ]

If CONFIG_GPIOLIB is not selected the compilation results in the
following build errors:

drivers/pci/controller/dwc/pci-dra7xx.c:
 In function dra7xx_pcie_probe:
drivers/pci/controller/dwc/pci-dra7xx.c:777:10:
 error: implicit declaration of function devm_gpiod_get_optional;
 did you mean devm_regulator_get_optional? [-Werror=implicit-function-declaration]

  reset = devm_gpiod_get_optional(dev, NULL, GPIOD_OUT_HIGH);

drivers/pci/controller/dwc/pci-dra7xx.c:778:45: error: ‘GPIOD_OUT_HIGH’
undeclared (first use in this function); did you mean ‘GPIOF_INIT_HIGH’?
  reset = devm_gpiod_get_optional(dev, NULL, GPIOD_OUT_HIGH);
                                             ^~~~~~~~~~~~~~
                                             GPIOF_INIT_HIGH

Fix them by including the appropriate header file.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
[lorenzo.pieralisi@arm.com: commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/dwc/pci-dra7xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/dwc/pci-dra7xx.c b/drivers/pci/dwc/pci-dra7xx.c
index 06eae132aff7..63052c5e5f82 100644
--- a/drivers/pci/dwc/pci-dra7xx.c
+++ b/drivers/pci/dwc/pci-dra7xx.c
@@ -29,6 +29,7 @@
 #include <linux/types.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/gpio/consumer.h>
 
 #include "pcie-designware.h"
 
-- 
2.20.1



