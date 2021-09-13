Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4B7408E8F
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242289AbhIMNfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240872AbhIMNcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:32:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCB056137F;
        Mon, 13 Sep 2021 13:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539563;
        bh=LhIFj7V7nIgk1FlbSSAAwYm0Zja+2WrGGJvCfXGJjuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFiyt3y0nv6oHKbp9JwRNQhcwP0/8dFYXHXqksvNdO12lv8MfzwC+ZS4UvbY/6r1n
         c3EXq/7UlMH4vxwqg350QHpK5ORRpfnW2JMfv1ygex1Iio4VeXSSWD5mkrX+bV4j1I
         uzlaLoHAhqExtVVsSb0FxbID1MT2+CJ9VZkk5fIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        David Rivshin <drivshin@allworx.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/236] leds: is31fl32xx: Fix missing error code in is31fl32xx_parse_dt()
Date:   Mon, 13 Sep 2021 15:12:58 +0200
Message-Id: <20210913131102.839470265@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit e642197562cd9781453f835e1406cfe0feeb917e ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'ret'.

Eliminate the follow smatch warning:

drivers/leds/leds-is31fl32xx.c:388 is31fl32xx_parse_dt() warn: missing
error code 'ret'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Fixes: 9d7cffaf99f5 ("leds: Add driver for the ISSI IS31FL32xx family of LED controllers")
Acked-by: David Rivshin <drivshin@allworx.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-is31fl32xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-is31fl32xx.c b/drivers/leds/leds-is31fl32xx.c
index 2180255ad339..899ed94b6687 100644
--- a/drivers/leds/leds-is31fl32xx.c
+++ b/drivers/leds/leds-is31fl32xx.c
@@ -385,6 +385,7 @@ static int is31fl32xx_parse_dt(struct device *dev,
 			dev_err(dev,
 				"Node %pOF 'reg' conflicts with another LED\n",
 				child);
+			ret = -EINVAL;
 			goto err;
 		}
 
-- 
2.30.2



