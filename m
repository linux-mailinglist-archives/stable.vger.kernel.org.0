Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D566111C24
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfLCWk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727731AbfLCWky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBA3420684;
        Tue,  3 Dec 2019 22:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412854;
        bh=DbmV8Tc7S3hQcDoJhHZdPkFhSwiSaATw4JEzfkOUwB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQeU2a+5Y0FYDighp77oQxeJkjrOCZNPu463iPVKwMMqp7R4b/44YhwzzsV8ULfW8
         1n+VH7kyHCxRXacjd6Bc6xXU7z0XP9WSHMOAnSpqP7jMM6PHvk0/3YZeBQCIoCUDox
         ynprr1Ij6AIB/VKxRnrlxaNCBEBh6MonhKlGBftg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 006/135] clk: at91: sam9x60: fix programmable clock
Date:   Tue,  3 Dec 2019 23:34:06 +0100
Message-Id: <20191203213006.960516373@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 2200ab6a7403f4fcd052c55ca328fc942f9392b6 ]

The prescaler mask for sam9x60 must be 0xff (8 bits).
Being set to 0, means that we cannot set any prescaler, thus the
programmable clocks do not work (except the case with prescaler 0)
Set the mask accordingly in layout struct.

Fixes: 01e2113de9a5 ("clk: at91: add sam9x60 pmc driver")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Link: https://lkml.kernel.org/r/1569321191-27606-1-git-send-email-eugen.hristev@microchip.com
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sam9x60.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/at91/sam9x60.c b/drivers/clk/at91/sam9x60.c
index 9790ddfa5b3cb..86238d5ecb4da 100644
--- a/drivers/clk/at91/sam9x60.c
+++ b/drivers/clk/at91/sam9x60.c
@@ -43,6 +43,7 @@ static const struct clk_pll_characteristics upll_characteristics = {
 };
 
 static const struct clk_programmable_layout sam9x60_programmable_layout = {
+	.pres_mask = 0xff,
 	.pres_shift = 8,
 	.css_mask = 0x1f,
 	.have_slck_mck = 0,
-- 
2.20.1



