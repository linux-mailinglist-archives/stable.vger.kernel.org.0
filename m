Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655D2301E90
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 20:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbhAXTx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 14:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbhAXTxZ (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 24 Jan 2021 14:53:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71F90229C5;
        Sun, 24 Jan 2021 19:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611517964;
        bh=52KkmDBN4KUf4ijGJKSxhN/aTL3++2JXmmjs9akkqiE=;
        h=From:To:Cc:Subject:Date:From;
        b=b6/RHA8fNb7Er7DZZ6+OSIY2GhXbDAvWILGUvoER0ZvnxYOpPY6lNl0vpLzlSiDEN
         PfzA6L+u4wnSCU4ureXyMplV38HJrZ9H9ZGuPuCxfjHdm4sCDXFuADuvvmjjZz+77u
         CGG7Li+u2VuVq3fh6BmbReYVimsjnmB5fAYDQthovOz82UuwKbiaG3S/kNx6s5Q+4B
         Z6kRhmgBSsWqCxq4yQTqxWW32ZDuM15nIdrCIeQ9zG4wbC0ScXxXX+kdtRLyS1s+Bi
         7Zauww2vAyr3j0piTWp58BrrfYvlsAMmVPsPf6oi0U6M/z2yW/ZbbQyi4Z8S2k/VJY
         0oCy/1H0K2pbw==
From:   Jonathan Cameron <jic23@kernel.org>
To:     linux-iio@vger.kernel.org
Cc:     Fabrice Gasnier <fabrice.gasnier@st.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org
Subject: [PATCH] iio:adc:stm32-adc: Add HAS_IOMEM dependency
Date:   Sun, 24 Jan 2021 19:50:34 +0000
Message-Id: <20210124195034.22576-1-jic23@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Seems that there are config combinations in which this driver gets enabled
and hence selects the MFD, but with out HAS_IOMEM getting pulled in
via some other route.  MFD is entirely contained in an
if HAS_IOMEM block, leading to the build issue in this bugzilla.

https://bugzilla.kernel.org/show_bug.cgi?id=209889

Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index bf7d22fa4be2..6605c263949c 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -923,6 +923,7 @@ config STM32_ADC_CORE
 	depends on ARCH_STM32 || COMPILE_TEST
 	depends on OF
 	depends on REGULATOR
+	depends on HAS_IOMEM
 	select IIO_BUFFER
 	select MFD_STM32_TIMERS
 	select IIO_STM32_TIMER_TRIGGER
-- 
2.30.0

