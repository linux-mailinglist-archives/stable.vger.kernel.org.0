Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C544418E4
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhKAJwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234432AbhKAJut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F444600D4;
        Mon,  1 Nov 2021 09:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759131;
        bh=PWajo2IHAgegirPxtq817YiukjGtgjMud+jJOyx8A5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAUAWUwQLBmLJ59+5IgD8IxntjxyvEfsCPyHiy10XqOO4WIFqSRo5/p9ESd7knExd
         HTyp/aWGk09SmXwSgjg4v6m6z3uKDKKXIUyWzRh6JG+e6J5ct0Puz2paNtgBdGVDRQ
         8z4zKnP/tNkxF3DTYAy/oW95mdjaNUftQL6v4tsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamie Iles <quic_jiles@quicinc.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 107/125] watchdog: sbsa: only use 32-bit accessors
Date:   Mon,  1 Nov 2021 10:18:00 +0100
Message-Id: <20211101082553.377944412@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamie Iles <quic_jiles@quicinc.com>

[ Upstream commit f31afb502c3151855df3ed40f5974c7884c10d14 ]

SBSA says of the generic watchdog:

  All registers are 32 bits in size and should be accessed using 32-bit
  reads and writes. If an access size other than 32 bits is used then
  the results are IMPLEMENTATION DEFINED.

and for qemu, the implementation will only allow 32-bit accesses
resulting in a synchronous external abort when configuring the watchdog.
Use lo_hi_* accessors rather than a readq/writeq.

Fixes: abd3ac7902fb ("watchdog: sbsa: Support architecture version 1")
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Link: https://lore.kernel.org/r/20210903112101.493552-1-quic_jiles@quicinc.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sbsa_gwdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/sbsa_gwdt.c b/drivers/watchdog/sbsa_gwdt.c
index ee9ff38929eb..6f4319bdbc50 100644
--- a/drivers/watchdog/sbsa_gwdt.c
+++ b/drivers/watchdog/sbsa_gwdt.c
@@ -130,7 +130,7 @@ static u64 sbsa_gwdt_reg_read(struct sbsa_gwdt *gwdt)
 	if (gwdt->version == 0)
 		return readl(gwdt->control_base + SBSA_GWDT_WOR);
 	else
-		return readq(gwdt->control_base + SBSA_GWDT_WOR);
+		return lo_hi_readq(gwdt->control_base + SBSA_GWDT_WOR);
 }
 
 static void sbsa_gwdt_reg_write(u64 val, struct sbsa_gwdt *gwdt)
@@ -138,7 +138,7 @@ static void sbsa_gwdt_reg_write(u64 val, struct sbsa_gwdt *gwdt)
 	if (gwdt->version == 0)
 		writel((u32)val, gwdt->control_base + SBSA_GWDT_WOR);
 	else
-		writeq(val, gwdt->control_base + SBSA_GWDT_WOR);
+		lo_hi_writeq(val, gwdt->control_base + SBSA_GWDT_WOR);
 }
 
 /*
-- 
2.33.0



