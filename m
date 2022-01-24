Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1580B49989C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453131AbiAXV2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:28:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39474 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378272AbiAXVQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD078614A7;
        Mon, 24 Jan 2022 21:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCEDC340E5;
        Mon, 24 Jan 2022 21:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058997;
        bh=jYIRWSiUZSWF2+JFSFBxoVE0otIiJf+SdqOpEdwYg0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vospIbfL5jk6eh3JRrdndDCN7esFnZ6gX6/yQMsXK0WOn+fTd4/De/Cdlim6VNo6F
         hD+hzmZjWGgeLGFgU+PkEdqOOzE2JirlapKlbg+vFtEbslz2sCuVlXm5zJt1KNj82e
         YuAfQ4AdwisPR5weeY/A5YCoBB1FVBoqliLKBk60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0469/1039] misc: at25: Make driver OF independent again
Date:   Mon, 24 Jan 2022 19:37:38 +0100
Message-Id: <20220124184141.044529893@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5b557298d7d09cce04e0565a535fbca63661724a ]

The commit f60e7074902a ("misc: at25: Make use of device property API")
made a good job by enabling the driver for non-OF platforms, but the
recent commit 604288bc6196 ("nvmem: eeprom: at25: fix type compiler warnings")
brought that back.

Restore greatness of the driver once again.

Fixes: eab61fb1cc2e ("nvmem: eeprom: at25: fram discovery simplification")
Fixes: fd307a4ad332 ("nvmem: prepare basics for FRAM support")
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20211125212729.86585-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/at25.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index b38978a3b3ffa..9193b812bc07e 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -17,8 +17,6 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
 #include <linux/property.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
 #include <linux/math.h>
 
 /*
@@ -380,13 +378,14 @@ static int at25_probe(struct spi_device *spi)
 	int			sr;
 	u8 id[FM25_ID_LEN];
 	u8 sernum[FM25_SN_LEN];
+	bool is_fram;
 	int i;
-	const struct of_device_id *match;
-	bool is_fram = 0;
 
-	match = of_match_device(of_match_ptr(at25_of_match), &spi->dev);
-	if (match && !strcmp(match->compatible, "cypress,fm25"))
-		is_fram = 1;
+	err = device_property_match_string(&spi->dev, "compatible", "cypress,fm25");
+	if (err >= 0)
+		is_fram = true;
+	else
+		is_fram = false;
 
 	at25 = devm_kzalloc(&spi->dev, sizeof(struct at25_data), GFP_KERNEL);
 	if (!at25)
-- 
2.34.1



