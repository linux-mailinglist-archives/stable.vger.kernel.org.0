Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF5D19B332
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733195AbgDAQtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389447AbgDAQlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:41:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45CC520658;
        Wed,  1 Apr 2020 16:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759308;
        bh=ZCfgKqcp5k9H0mwLFlSfobUCxNr6mraV7kp7uz4Nar4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCVeg2s0BO7kxrpmlNtJMpsdtWcXU/nwFmHm2fx5gFP0YHJaAv/YKaLkhsBeSiJgV
         fDWBLV3tTZbpZDPerFcSWSsm8L/SZ4/UKjLIb0Gvy0QNxuMMAV+LMRdQTRDCi3IJU6
         3OFvjKQ1MaIJmiuf7m9lYZiOBoIJEZQCTrFpbwKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 033/148] rtc: max8907: add missing select REGMAP_IRQ
Date:   Wed,  1 Apr 2020 18:17:05 +0200
Message-Id: <20200401161555.808094271@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

commit 5d892919fdd0cefd361697472d4e1b174a594991 upstream.

I have hit the following build error:

  armv7a-hardfloat-linux-gnueabi-ld: drivers/rtc/rtc-max8907.o: in function `max8907_rtc_probe':
  rtc-max8907.c:(.text+0x400): undefined reference to `regmap_irq_get_virq'

max8907 should select REGMAP_IRQ

Fixes: 94c01ab6d7544 ("rtc: add MAX8907 RTC driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -323,6 +323,7 @@ config RTC_DRV_MAX6900
 config RTC_DRV_MAX8907
 	tristate "Maxim MAX8907"
 	depends on MFD_MAX8907 || COMPILE_TEST
+	select REGMAP_IRQ
 	help
 	  If you say yes here you will get support for the
 	  RTC of Maxim MAX8907 PMIC.


