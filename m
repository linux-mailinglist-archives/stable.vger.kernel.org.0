Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693F33442AD
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCVMoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232413AbhCVMmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31B9D619BC;
        Mon, 22 Mar 2021 12:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416812;
        bh=LE2qOZZHqFUlYbx2AAetxo8I594XlB4Y4gDXKoFoDRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rImZHp+EAMAHH6qsroeeWXkST5iewSKjGbhp93wSRnt++FZ9QyF8c4ZrxxY/kjDme
         5qzvbhnvi38uqzd6EF1ErQ2fqGBHptizgcjvJFj6lOYAOpTS6w9sAJMQqhs7Z00a+x
         LUzGl+z1rqCVlpUrdLGXbC+AlutdFk5dMvZg7hkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 131/157] iio: adc: adi-axi-adc: add proper Kconfig dependencies
Date:   Mon, 22 Mar 2021 13:28:08 +0100
Message-Id: <20210322121937.905867616@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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


