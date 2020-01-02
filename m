Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB8D12F159
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgABWNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727763AbgABWNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F00221D7D;
        Thu,  2 Jan 2020 22:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003227;
        bh=K+k3IYqfi8N7ewXk4LEx7Oz7grn9DwS3QRY13yBxM5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCVxNT7yKHdg5F+D/6v+TegbfVEfu2rif6EmxN4v1VoY+oGLDtPYY7I7MUevrPloC
         owcnM8O/7N8lJtSogcL0rBOQ+hsDyyc72pWng44qio7zt6QbWvRmQZXgYSnUNItWlV
         jtC9V5Al3ir2zMu459H0nsIefZdeLBbK5VgxHQhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/191] clk: pxa: fix one of the pxa RTC clocks
Date:   Thu,  2 Jan 2020 23:05:55 +0100
Message-Id: <20200102215837.751303668@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
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
index 287fdeae7c7c..7b123105b5de 100644
--- a/drivers/clk/pxa/clk-pxa27x.c
+++ b/drivers/clk/pxa/clk-pxa27x.c
@@ -459,6 +459,7 @@ struct dummy_clk {
 };
 static struct dummy_clk dummy_clks[] __initdata = {
 	DUMMY_CLK(NULL, "pxa27x-gpio", "osc_32_768khz"),
+	DUMMY_CLK(NULL, "pxa-rtc", "osc_32_768khz"),
 	DUMMY_CLK(NULL, "sa1100-rtc", "osc_32_768khz"),
 	DUMMY_CLK("UARTCLK", "pxa2xx-ir", "STUART"),
 };
-- 
2.20.1



