Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CB64522BF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240506AbhKPBP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:15:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244474AbhKOTPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EBFB634C9;
        Mon, 15 Nov 2021 18:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000489;
        bh=AELfT1njZFbc3agdN02nWIJajP09uI4oXMaPdeeTl0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1w0HfeU7Y4VcAF7OpL7VgPsgARyF5LnM51Xsc9hphFwuuGOYEC3szKIuCWxkCulM
         dk96OB9OlCF3nUmo98mH5aK0xTM5AeUiXsDLD66d0YzN6NE+7u2FgjuV896V/3YUz/
         sxhhRjePYOaMUZEBS6LSyNOiyZqeGPC0KmFrpCCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 645/849] clk: at91: clk-master: check if div or pres is zero
Date:   Mon, 15 Nov 2021 18:02:08 +0100
Message-Id: <20211115165442.093407569@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit c2910c00fee4cbb7b222d6e02846adef9ae4135a ]

Check if div or pres is zero before using it as argument for ffs().
In case div is zero ffs() will return 0 and thus substracting from
zero will lead to invalid values to be setup in registers.

Fixes: 7a110b9107ed8 ("clk: at91: clk-master: re-factor master clock")
Fixes: 75c88143f3b87 ("clk: at91: clk-master: add master clock support for SAMA7G5")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20211011112719.3951784-9-claudiu.beznea@microchip.com
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-master.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
index a80427980bf73..2e410815a3405 100644
--- a/drivers/clk/at91/clk-master.c
+++ b/drivers/clk/at91/clk-master.c
@@ -280,7 +280,7 @@ static int clk_master_pres_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	else if (pres == 3)
 		pres = MASTER_PRES_MAX;
-	else
+	else if (pres)
 		pres = ffs(pres) - 1;
 
 	spin_lock_irqsave(master->lock, flags);
@@ -610,7 +610,7 @@ static int clk_sama7g5_master_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	if (div == 3)
 		div = MASTER_PRES_MAX;
-	else
+	else if (div)
 		div = ffs(div) - 1;
 
 	spin_lock_irqsave(master->lock, flags);
-- 
2.33.0



