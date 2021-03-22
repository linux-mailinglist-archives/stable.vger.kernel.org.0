Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1D234445E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhCVM7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233170AbhCVM5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7599761998;
        Mon, 22 Mar 2021 12:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417375;
        bh=OfW6c6vNI2p2MQX16o4DdW8ImUvR9M+6qQ6AzG/dsNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzsCbLNRED+xNSGl8lEXygT/khf8nbA54d3z5mnNwcWNTcN55I5/D5eumAcOVc7C3
         pGyg6cIY/4BAayfTb0qtFzecnt+NstrI+cNKWmjxPTsbcBD7A7/nsQf4v9og9ubl2I
         un7dEB7gNOVr9k7UTSkN2PxMZw7bTrb9KxU9sNLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 27/43] iio:adc:stm32-adc: Add HAS_IOMEM dependency
Date:   Mon, 22 Mar 2021 13:29:08 +0100
Message-Id: <20210322121920.906983941@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 121875b28e3bd7519a675bf8ea2c2e793452c2bd upstream.

Seems that there are config combinations in which this driver gets enabled
and hence selects the MFD, but with out HAS_IOMEM getting pulled in
via some other route.  MFD is entirely contained in an
if HAS_IOMEM block, leading to the build issue in this bugzilla.

https://bugzilla.kernel.org/show_bug.cgi?id=209889

Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20210124195034.22576-1-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -635,6 +635,7 @@ config STM32_ADC_CORE
 	depends on HAS_DMA
 	depends on OF
 	depends on REGULATOR
+	depends on HAS_IOMEM
 	select IIO_BUFFER
 	select MFD_STM32_TIMERS
 	select IIO_STM32_TIMER_TRIGGER


