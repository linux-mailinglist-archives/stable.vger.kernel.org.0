Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03373328CDF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240734AbhCATAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240318AbhCASyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:54:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 813C665046;
        Mon,  1 Mar 2021 17:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619075;
        bh=y6GPOy0+OEfueUHtFgFIf5ZuR8dDIYNb2yTTvnPD2kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pM44aSbYEgGSHyop7NjCnN6jcyzE/QO001apz2jyUSdNNUgDOyt9cVou1FJYTrOU1
         cyjLx6AzeDDElHWTIO7hoiuchJh4OuYUh2UfCB/bflZA1qwNtMLOOQYxdTPCVDnLUp
         V/MOxCau9k770FjSSQH9hBxRa1xAUf5lLsUIOjXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/663] rtc: s5m: select REGMAP_I2C
Date:   Mon,  1 Mar 2021 17:09:03 +0100
Message-Id: <20210301161156.429884023@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 1f0cbda3b452b520c5f3794f8f0e410e8bc7386a ]

The rtc-s5m uses the I2C regmap but doesn't select it in Kconfig so
depending on the configuration the build may fail. Fix it.

Fixes: 959df7778bbd ("rtc: Enable compile testing for Maxim and Samsung drivers")
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210114102219.23682-2-brgl@bgdev.pl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 65ad9d0b47ab1..e59f78f99e8f1 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -692,6 +692,7 @@ config RTC_DRV_S5M
 	tristate "Samsung S2M/S5M series"
 	depends on MFD_SEC_CORE || COMPILE_TEST
 	select REGMAP_IRQ
+	select REGMAP_I2C
 	help
 	  If you say yes here you will get support for the
 	  RTC of Samsung S2MPS14 and S5M PMIC series.
-- 
2.27.0



