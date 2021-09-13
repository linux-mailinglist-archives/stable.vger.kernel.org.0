Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A686409403
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345756AbhIMO1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346606AbhIMOY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 344D661B47;
        Mon, 13 Sep 2021 13:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540921;
        bh=w4Z677ScHh4bIZBzZ1s8apaD3PQbZ8qSdbVWbCS4S+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdJmzONb+3OfCl2ukc/vlOS+ZdWJvQOfAnVGCItPONMiViuNguuWIY/kIywt4TMaG
         njeLcD3iKfdX0EdMUdoRhc9hIb4w5U7ihEQs4rwhG9CLb2sRpUBG+PftocgHDw475T
         oCAUqa0rnl2+XhskkkKrS+W3skMqdSUtLO4b8GJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        David Rivshin <drivshin@allworx.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 089/334] leds: is31fl32xx: Fix missing error code in is31fl32xx_parse_dt()
Date:   Mon, 13 Sep 2021 15:12:23 +0200
Message-Id: <20210913131116.396333669@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 3b55af9a8c58..22c092a4394a 100644
--- a/drivers/leds/leds-is31fl32xx.c
+++ b/drivers/leds/leds-is31fl32xx.c
@@ -386,6 +386,7 @@ static int is31fl32xx_parse_dt(struct device *dev,
 			dev_err(dev,
 				"Node %pOF 'reg' conflicts with another LED\n",
 				child);
+			ret = -EINVAL;
 			goto err;
 		}
 
-- 
2.30.2



