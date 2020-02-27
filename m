Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A057172381
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 17:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgB0QfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 11:35:14 -0500
Received: from smtp-out.xnet.cz ([178.217.244.18]:22715 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730295AbgB0QfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 11:35:14 -0500
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2020 11:35:12 EST
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 2E4B43D9E;
        Thu, 27 Feb 2020 17:27:44 +0100 (CET)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 3bf5d2ef;
        Thu, 27 Feb 2020 17:27:30 +0100 (CET)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Tomasz Duszynski <tduszyns@gmail.com>
Cc:     =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iio: chemical: sps30: fix missing triggered buffer dependency
Date:   Thu, 27 Feb 2020 17:27:34 +0100
Message-Id: <20200227162734.604-1-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SPS30 uses triggered buffer, but the dependency is not specified in the
Kconfig file.  Fix this by selecting IIO_BUFFER and IIO_TRIGGERED_BUFFER
config symbols.

Cc: stable@vger.kernel.org
Fixes: 232e0f6ddeae ("iio: chemical: add support for Sensirion SPS30 sensor")
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 drivers/iio/chemical/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/chemical/Kconfig b/drivers/iio/chemical/Kconfig
index 0b91de4df8f4..a7e65a59bf42 100644
--- a/drivers/iio/chemical/Kconfig
+++ b/drivers/iio/chemical/Kconfig
@@ -91,6 +91,8 @@ config SPS30
 	tristate "SPS30 particulate matter sensor"
 	depends on I2C
 	select CRC8
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y here to build support for the Sensirion SPS30 particulate
 	  matter sensor.
