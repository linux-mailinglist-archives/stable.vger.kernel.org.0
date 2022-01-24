Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09ED499427
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388571AbiAXUji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:39:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38894 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385738AbiAXUeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:34:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 337C8B8121A;
        Mon, 24 Jan 2022 20:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0CBC340E5;
        Mon, 24 Jan 2022 20:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056453;
        bh=nWfx+5I8ePLDtAMpHsHpCuInFeM3n1fhygFY6A3KG1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkbvTp8PJEGzkv/ksLKXB7dzBEckWkPIoBnoe3hvz6i/oZowVQnKDS29QmpSKFMAm
         OEMbeZodYkaikKg990SMLt+CDRKABPEBjIoYrMYBAoOiwHL01cETRJNJbzo1xWnocZ
         kSb6sG2MP6v8TaExtdFFuQqEV+tyxACliFyM9pGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 489/846] ethernet: renesas: Use div64_ul instead of do_div
Date:   Mon, 24 Jan 2022 19:40:06 +0100
Message-Id: <20220124184117.878667952@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit d9f31aeaa1e5aefa68130878af3c3513d41c1e2d ]

do_div() does a 64-by-32 division. Here the divisor is an
unsigned long which on some platforms is 64 bit wide. So use
div64_ul instead of do_div to avoid a possible truncation.

Eliminate the following coccicheck warning:
./drivers/net/ethernet/renesas/ravb_main.c:2492:1-7: WARNING:
do_div() does a 64-by-32 division, please consider using div64_ul
instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/1637228883-100100-1-git-send-email-yang.lee@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0f85f2d97b18d..4e08b7219403c 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -30,8 +30,7 @@
 #include <linux/spinlock.h>
 #include <linux/sys_soc.h>
 #include <linux/reset.h>
-
-#include <asm/div64.h>
+#include <linux/math64.h>
 
 #include "ravb.h"
 
@@ -2061,8 +2060,7 @@ static int ravb_set_gti(struct net_device *ndev)
 	if (!rate)
 		return -EINVAL;
 
-	inc = 1000000000ULL << 20;
-	do_div(inc, rate);
+	inc = div64_ul(1000000000ULL << 20, rate);
 
 	if (inc < GTI_TIV_MIN || inc > GTI_TIV_MAX) {
 		dev_err(dev, "gti.tiv increment 0x%llx is outside the range 0x%x - 0x%x\n",
-- 
2.34.1



