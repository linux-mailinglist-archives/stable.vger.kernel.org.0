Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D9819105D
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgCXN1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729874AbgCXN1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:27:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C4FE208C3;
        Tue, 24 Mar 2020 13:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056451;
        bh=SVXDnBLS8OYTxh6JQOjPG3wvbuVCb+UUdp5FOyJQEX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDgBhmXD5Fd7QVKHpDunlw9HAw3QLRfmrhgVv48D8V98PgcDfQ9ogFrfRmyrJytOj
         BPBLnTDh+MdxCvVU0Xgvx633bbDkaAzJXibCIF1nERRgoIdOD6i3cVO2nZCo/qdHKj
         pOjELyRIgb2ACUdCf4IQLRigI+YtCAd0j+G0+vUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 085/119] rtc: max8907: add missing select REGMAP_IRQ
Date:   Tue, 24 Mar 2020 14:11:10 +0100
Message-Id: <20200324130816.753234910@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
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
@@ -327,6 +327,7 @@ config RTC_DRV_MAX6900
 config RTC_DRV_MAX8907
 	tristate "Maxim MAX8907"
 	depends on MFD_MAX8907 || COMPILE_TEST
+	select REGMAP_IRQ
 	help
 	  If you say yes here you will get support for the
 	  RTC of Maxim MAX8907 PMIC.


