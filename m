Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A67812EE88
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbgABWjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:39:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731426AbgABWjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:39:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D23921D7D;
        Thu,  2 Jan 2020 22:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004753;
        bh=TibN/pcS0cJvQMq+vtAWj+LJC3fl3uv6/IGCKXgwJng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqak8oHi0lgedhEuPp/uX9k7/fKK1qMyI38ecJnmscaLxOf+28gMWzIZgPqcl1HMl
         CFeDHj/7DaPG4VQf7T2kHA75rNWKcRVHc3b34/JTymGt7um11nz6bPZf4/U51w4RIJ
         NiGCxhhc1UGkqT81HvmcLcQeReMIY+B8Yq/8IdNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 113/137] clk: pxa: fix one of the pxa RTC clocks
Date:   Thu,  2 Jan 2020 23:08:06 +0100
Message-Id: <20200102220602.363667040@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Jarzmik <robert.jarzmik@free.fr>

[ Upstream commit 46acbcb4849b2ca2e6e975e7c8130c1d61c8fd0c ]

The pxa27x platforms have a single IP with 2 drivers, sa1100-rtc and
rtc-pxa drivers.

A previous patch fixed the sa1100-rtc case, but the pxa-rtc wasn't
fixed. This patch completes the previous one.

Fixes: 8b6d10345e16 ("clk: pxa: add missing pxa27x clocks for Irda and sa1100-rtc")
Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Link: https://lkml.kernel.org/r/20191026194420.11918-1-robert.jarzmik@free.fr
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/pxa/clk-pxa27x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/pxa/clk-pxa27x.c b/drivers/clk/pxa/clk-pxa27x.c
index 5b82d30baf9f..bf47737b6672 100644
--- a/drivers/clk/pxa/clk-pxa27x.c
+++ b/drivers/clk/pxa/clk-pxa27x.c
@@ -362,6 +362,7 @@ struct dummy_clk {
 };
 static struct dummy_clk dummy_clks[] __initdata = {
 	DUMMY_CLK(NULL, "pxa27x-gpio", "osc_32_768khz"),
+	DUMMY_CLK(NULL, "pxa-rtc", "osc_32_768khz"),
 	DUMMY_CLK(NULL, "sa1100-rtc", "osc_32_768khz"),
 	DUMMY_CLK("UARTCLK", "pxa2xx-ir", "STUART"),
 };
-- 
2.20.1



