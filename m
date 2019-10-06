Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41FEBCD58D
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfJFRhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbfJFRhY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:37:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D5672080F;
        Sun,  6 Oct 2019 17:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383443;
        bh=YDlb7eJfsCJYSe+W+bAGfQM6oR+1wKO4K2sY+007I9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTedgxhNjAYfCVyAZc7SlpfSXEyp507E5pz7ACzR0VlP60rEvOWMC8KEZT506w9WN
         vuvsZ9qRCw6FSZUPYvgOc2Z1AgG4nJtwILE0JZb0IMfeBwoXoM/EKcRauFOtFnLiEk
         sxHnE3vL4CYJqtYrWquYMLFeANALX22CaFKNTyjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biwen Li <biwen.li@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 106/137] rtc: pcf85363/pcf85263: fix regmap error in set_time
Date:   Sun,  6 Oct 2019 19:21:30 +0200
Message-Id: <20191006171217.782857765@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biwen Li <biwen.li@nxp.com>

[ Upstream commit 7ef66122bdb3b839e9f51b76d7e600b6e21ef648 ]

Issue:
    - # hwclock -w
      hwclock: RTC_SET_TIME: Invalid argument

Why:
    - Relative commit: 8b9f9d4dc511 ("regmap: verify if register is
      writeable before writing operations"), this patch
      will always check for unwritable registers, it will compare reg
      with max_register in regmap_writeable.

    - The pcf85363/pcf85263 has the capability of address wrapping
      which means if you access an address outside the allowed range
      (0x00-0x2f) hardware actually wraps the access to a lower address.
      The rtc-pcf85363 driver will use this feature to configure the time
      and execute 2 actions in the same i2c write operation (stopping the
      clock and configure the time). However the driver has also
      configured the `regmap maxregister` protection mechanism that will
      block accessing addresses outside valid range (0x00-0x2f).

How:
    - Split of writing regs to two parts, first part writes control
      registers about stop_enable and resets, second part writes
      RTC time and date registers.

Signed-off-by: Biwen Li <biwen.li@nxp.com>
Link: https://lore.kernel.org/r/20190829021418.4607-1-biwen.li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85363.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf85363.c b/drivers/rtc/rtc-pcf85363.c
index a075e77617dcb..3450d615974d5 100644
--- a/drivers/rtc/rtc-pcf85363.c
+++ b/drivers/rtc/rtc-pcf85363.c
@@ -166,7 +166,12 @@ static int pcf85363_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	buf[DT_YEARS] = bin2bcd(tm->tm_year % 100);
 
 	ret = regmap_bulk_write(pcf85363->regmap, CTRL_STOP_EN,
-				tmp, sizeof(tmp));
+				tmp, 2);
+	if (ret)
+		return ret;
+
+	ret = regmap_bulk_write(pcf85363->regmap, DT_100THS,
+				buf, sizeof(tmp) - 2);
 	if (ret)
 		return ret;
 
-- 
2.20.1



