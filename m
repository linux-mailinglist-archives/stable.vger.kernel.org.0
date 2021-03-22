Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8813442A3
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhCVMoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232335AbhCVMmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B49161931;
        Mon, 22 Mar 2021 12:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416796;
        bh=qf3LBUZBVTdXy6XQ0JmUa5Jt7IWsxyLkOzTiJFZ/l0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OH5zxUVfhI2B2aiJnSSpoClnY4nGzEds1AbPJbG4NEHTeyu1yUkDCrwQBW9i0omPY
         elySpATKYWwyecmYYPqdxR9JaD87S6PsrFiRZK2L73FQxa7307qGYaN94XwiMajfUp
         iV18GDBCWFJ5f8R+9H0qZoSI4CWzEX0BMTjn+Yhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 125/157] iio:adc:stm32-adc: Add HAS_IOMEM dependency
Date:   Mon, 22 Mar 2021 13:28:02 +0100
Message-Id: <20210322121937.723486160@linuxfoundation.org>
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
@@ -912,6 +912,7 @@ config STM32_ADC_CORE
 	depends on ARCH_STM32 || COMPILE_TEST
 	depends on OF
 	depends on REGULATOR
+	depends on HAS_IOMEM
 	select IIO_BUFFER
 	select MFD_STM32_TIMERS
 	select IIO_STM32_TIMER_TRIGGER


