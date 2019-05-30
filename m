Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E5E2F35C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbfE3E2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729748AbfE3DOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:10 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5306624561;
        Thu, 30 May 2019 03:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186050;
        bh=ZG+gGJa5XSfWrsj1TIcoEimwk3uKazq99BvcQZRP5wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gblkR/+ncUk55rj5IcL7aGXrkYNipe1t+2GRY3tedaixP0Asdp6rLsF03p4ubbqqV
         iebeFrBtXOX3fQecTymIQgK+b/yx5/gWSRedCqqThImyuIORzRZNsYQETRMTZsCyRg
         E6i52TZQeia3AJ6X4pTAX8q1TBM3fBlBTvAtwrU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 146/346] iio: adc: stm32-dfsdm: fix unmet direct dependencies detected
Date:   Wed, 29 May 2019 20:03:39 -0700
Message-Id: <20190530030548.565604367@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ba7ecfe43d6bf12e2aa76705c45f7d187ae3d7c0 ]

This fixes unmet direct dependencies seen when CONFIG_STM32_DFSDM_ADC
is selected:

WARNING: unmet direct dependencies detected for IIO_BUFFER_HW_CONSUMER
  Depends on [n]: IIO [=y] && IIO_BUFFER [=n]
  Selected by [y]:
  - STM32_DFSDM_ADC [=y] && IIO [=y] && (ARCH_STM32 [=y] && OF [=y] ||
    COMPILE_TEST [=n])

Fixes: e2e6771c6462 ("IIO: ADC: add STM32 DFSDM sigma delta ADC support")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 7a3ca4ec0cb78..0a11f6cbc91af 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -747,6 +747,7 @@ config STM32_DFSDM_ADC
 	depends on (ARCH_STM32 && OF) || COMPILE_TEST
 	select STM32_DFSDM_CORE
 	select REGMAP_MMIO
+	select IIO_BUFFER
 	select IIO_BUFFER_HW_CONSUMER
 	help
 	  Select this option to support ADCSigma delta modulator for
-- 
2.20.1



