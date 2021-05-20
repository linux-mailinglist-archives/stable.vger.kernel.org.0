Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A9138A4DB
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhETKKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235673AbhETKHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B61161949;
        Thu, 20 May 2021 09:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503707;
        bh=ser7SnMHAV7kqSBtaETDC4EaoYB/yPNZWqM/f9roDyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lquSfdVd/DgMCp6gBGTgNoJryuRQVpoXrmndSJcOOn78tKq4NthIDgQKMotuxDMnh
         CSxNAoQX9zH3v7BqgyMYDOOFJ/FOrEnposChhFBYtwXmYA9FgXmF5VQkxKxkBZHRrM
         UDE7FlMg5qc/3xsnDbjhV6R6M9HfKVQspM65mTYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 344/425] rtc: ds1307: Fix wday settings for rx8130
Date:   Thu, 20 May 2021 11:21:53 +0200
Message-Id: <20210520092142.718241759@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index ebd59e86a567..94d31779933f 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -434,7 +434,11 @@ static int ds1307_get_time(struct device *dev, struct rtc_time *t)
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
@@ -481,7 +485,11 @@ static int ds1307_set_time(struct device *dev, struct rtc_time *t)
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



