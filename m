Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA9838A791
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhETKkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237421AbhETKiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:38:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8113613B0;
        Thu, 20 May 2021 09:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504486;
        bh=Z+zOrTYRiag6oGcrAqPw3MpvSumXZNlYQGt3EfTHQTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrfDMdUqRvvjXF85nfUtADKlzj+fL4c5k9c84TByUs4jv68eCcWv65/rugZYtza+R
         YjjeSOzNJQtaIsblAIWfJ3LsMt4naZPx3c99pXS9H44qOerp942d5yoPj+C4xqrgWU
         cyaClhsJw7jSMJSN13JOEsSSzjd041yXgra9gv44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 267/323] rtc: ds1307: Fix wday settings for rx8130
Date:   Thu, 20 May 2021 11:22:39 +0200
Message-Id: <20210520092129.368352627@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

[ Upstream commit 204756f016726a380bafe619438ed979088bd04a ]

rx8130 wday specifies the bit position, not BCD.

Fixes: ee0981be7704 ("rtc: ds1307: Add support for Epson RX8130CE")
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210420023917.1949066-1-nobuhiro1.iwamatsu@toshiba.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 8d45d93b1db6..19749ec87b24 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -417,7 +417,11 @@ static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 	t->tm_min = bcd2bin(regs[DS1307_REG_MIN] & 0x7f);
 	tmp = regs[DS1307_REG_HOUR] & 0x3f;
 	t->tm_hour = bcd2bin(tmp);
-	t->tm_wday = bcd2bin(regs[DS1307_REG_WDAY] & 0x07) - 1;
+	/* rx8130 is bit position, not BCD */
+	if (ds1307->type == rx_8130)
+		t->tm_wday = fls(regs[DS1307_REG_WDAY] & 0x7f);
+	else
+		t->tm_wday = bcd2bin(regs[DS1307_REG_WDAY] & 0x07) - 1;
 	t->tm_mday = bcd2bin(regs[DS1307_REG_MDAY] & 0x3f);
 	tmp = regs[DS1307_REG_MONTH] & 0x1f;
 	t->tm_mon = bcd2bin(tmp) - 1;
@@ -465,7 +469,11 @@ static int ds1307_set_time(struct device *dev, struct rtc_time *t)
 	regs[DS1307_REG_SECS] = bin2bcd(t->tm_sec);
 	regs[DS1307_REG_MIN] = bin2bcd(t->tm_min);
 	regs[DS1307_REG_HOUR] = bin2bcd(t->tm_hour);
-	regs[DS1307_REG_WDAY] = bin2bcd(t->tm_wday + 1);
+	/* rx8130 is bit position, not BCD */
+	if (ds1307->type == rx_8130)
+		regs[DS1307_REG_WDAY] = 1 << t->tm_wday;
+	else
+		regs[DS1307_REG_WDAY] = bin2bcd(t->tm_wday + 1);
 	regs[DS1307_REG_MDAY] = bin2bcd(t->tm_mday);
 	regs[DS1307_REG_MONTH] = bin2bcd(t->tm_mon + 1);
 
-- 
2.30.2



