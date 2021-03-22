Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFAE344193
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhCVMeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231572AbhCVMdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADD3A619A0;
        Mon, 22 Mar 2021 12:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416403;
        bh=LE2qOZZHqFUlYbx2AAetxo8I594XlB4Y4gDXKoFoDRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDGuefcEWvvN9TwfOIKicebokhHA6HkNy17naA7GzesKChOz+To0pwfVeTOD+C01d
         6Tc10iegqUbZ3zDh79czkBUKpS4QPIz+mgpimMCiRDWRUjKz7VlFMrY7EsJAaJdMlS
         tgRDonwk0vtHP749S7rXLfEgevNMrr6RmWgwqpvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.11 093/120] iio: adc: adi-axi-adc: add proper Kconfig dependencies
Date:   Mon, 22 Mar 2021 13:27:56 +0100
Message-Id: <20210322121932.787548436@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

commit be24c65e9fa2486bb8ec98d9f592bdcf04bedd88 upstream.

The ADI AXI ADC driver requires IO mem access and OF to work. This change
adds these dependencies to the Kconfig symbol of the driver.

This was also found via the lkp bot, as the
devm_platform_ioremap_resource() symbol was not found at link-time on the
S390 architecture.

Fixes: ef04070692a21 ("iio: adc: adi-axi-adc: add support for AXI ADC IP core")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210210105044.48914-1-alexandru.ardelean@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -266,6 +266,8 @@ config ADI_AXI_ADC
 	select IIO_BUFFER
 	select IIO_BUFFER_HW_CONSUMER
 	select IIO_BUFFER_DMAENGINE
+	depends on HAS_IOMEM
+	depends on OF
 	help
 	  Say yes here to build support for Analog Devices Generic
 	  AXI ADC IP core. The IP core is used for interfacing with


