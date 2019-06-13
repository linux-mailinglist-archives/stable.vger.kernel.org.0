Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E03441F3
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfFMQR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731126AbfFMIkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:40:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49B3621479;
        Thu, 13 Jun 2019 08:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415236;
        bh=JqdbKrRMKVHfma50c3wbyfNhbelEP8PfbAH0vsI4tzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mShJkDuNxeTqMlj21SCxFkhIqOyJFitZUnRjjUVqRb2FJaMtunwgK97CpEUV5qgCn
         waGW8m1k2dt4vt5p3WY/IStKZTQxnKv2/ee7lQWajYRa8/hvZNuP6PTVazj3i1aur3
         cWPyBz+G6mkvTGAFt830YBJYU93BBaQgV1AjoQfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Georg Hofmann <georg@hofmannsweb.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/118] watchdog: imx2_wdt: Fix set_timeout for big timeout values
Date:   Thu, 13 Jun 2019 10:33:11 +0200
Message-Id: <20190613075646.814259920@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b07e228eee69601addba98b47b1a3850569e5013 ]

The documentated behavior is: if max_hw_heartbeat_ms is implemented, the
minimum of the set_timeout argument and max_hw_heartbeat_ms should be used.
This patch implements this behavior.
Previously only the first 7bits were used and the input argument was
returned.

Signed-off-by: Georg Hofmann <georg@hofmannsweb.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/imx2_wdt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 2b52514eaa86..7e7bdcbbc741 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -178,8 +178,10 @@ static void __imx2_wdt_set_timeout(struct watchdog_device *wdog,
 static int imx2_wdt_set_timeout(struct watchdog_device *wdog,
 				unsigned int new_timeout)
 {
-	__imx2_wdt_set_timeout(wdog, new_timeout);
+	unsigned int actual;
 
+	actual = min(new_timeout, wdog->max_hw_heartbeat_ms * 1000);
+	__imx2_wdt_set_timeout(wdog, actual);
 	wdog->timeout = new_timeout;
 	return 0;
 }
-- 
2.20.1



