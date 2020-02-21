Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F759167259
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgBUICl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:02:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730143AbgBUICl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:02:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48C5B222C4;
        Fri, 21 Feb 2020 08:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272160;
        bh=3mMW9xAzJDDMfYwE+KOeTghpU9ATN3hhSY+NwNKGAbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUDKNbo4eIYLopGAkbY9gj1z7+g8eTW5zTJ5rMZZPt+18Bx10w5Q6eCJGCagqWnQw
         GNlHbFEBPkbK7OaEhcwDpbUp2yn/Ajr3yrcPdhxmMfSDh3pmfG6UlRYYrZ9HBnS2oD
         nQ4cLXMASkiQpzBvZbySFg4mzxC6S7IQLZeNd3Nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/344] clk: at91: sam9x60: fix programmable clock prescaler
Date:   Fri, 21 Feb 2020 08:37:18 +0100
Message-Id: <20200221072352.670318776@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 66d9f5214c9ba1c151478f99520b6817302d50dc ]

The prescaler works as parent rate divided by (PRES + 1) (is_pres_direct == 1)
It does not work in the way of parent rate shifted to the right by (PRES + 1),
which means division by 2^(PRES + 1) (is_pres_direct == 0)
Thus is_pres_direct must be enabled for this SoC, to make the right computation.
This field was added in
commit 45b06682113b ("clk: at91: fix programmable clock for sama5d2")
SAM9X60 has the same field as SAMA5D2 in the PCK

Fixes: 01e2113de9a5 ("clk: at91: add sam9x60 pmc driver")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Link: https://lkml.kernel.org/r/1575977088-16781-1-git-send-email-eugen.hristev@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sam9x60.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/at91/sam9x60.c b/drivers/clk/at91/sam9x60.c
index 86238d5ecb4da..77398aefeb6db 100644
--- a/drivers/clk/at91/sam9x60.c
+++ b/drivers/clk/at91/sam9x60.c
@@ -47,6 +47,7 @@ static const struct clk_programmable_layout sam9x60_programmable_layout = {
 	.pres_shift = 8,
 	.css_mask = 0x1f,
 	.have_slck_mck = 0,
+	.is_pres_direct = 1,
 };
 
 static const struct clk_pcr_layout sam9x60_pcr_layout = {
-- 
2.20.1



