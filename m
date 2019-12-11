Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A49311B2EF
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388472AbfLKPim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:38:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388467AbfLKPij (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:38:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DEF32464B;
        Wed, 11 Dec 2019 15:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078719;
        bh=SF7wNV/EfSTReGBg/eIM1pPu5/iujUyildCuZ3lkGnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrReEai7mD9pVnogtTmDBqz398M8FXmp36XwLTlv3zgQ/p0yUIUJbNNMLbUHdCVMP
         EpRkbIHXJALNr5G7IfRoof0TdynaKDmWWSdiZjR9NrR+bVGIlQJGYmGZwZCRQr3Mzj
         k1F9+CdfFUfRn8gzc0+Ruj0Kc156RfQBuMEOBuKo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Jarzmik <robert.jarzmik@free.fr>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 24/37] clk: pxa: fix one of the pxa RTC clocks
Date:   Wed, 11 Dec 2019 10:38:00 -0500
Message-Id: <20191211153813.24126-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153813.24126-1-sashal@kernel.org>
References: <20191211153813.24126-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5b82d30baf9f3..bf47737b66722 100644
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

