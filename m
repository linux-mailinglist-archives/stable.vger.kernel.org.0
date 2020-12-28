Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9A52E3F43
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504594AbgL1OiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:38:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389082AbgL1OcA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E02229C5;
        Mon, 28 Dec 2020 14:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165880;
        bh=6KMEH1bve/4MgV21p22avlgY6vY+npyznjrhFxmLHPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c92njSTqDoqQVpa7CT4h2nMEip29G44t2kJc9h5xmJaIHW6pzlH7HiDIYLW5G0MKm
         Ss5QJDGb6TgpW0T6k/JkdjfcDoZaCzdcFKVq3YH1BpmcyTCTEnZngLE/XlXyhC4duc
         yNy7Wf9ZOCBEPcMy/4iSoSQkNsi4FavyohsbkLkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 688/717] clk: ingenic: Fix divider calculation with div tables
Date:   Mon, 28 Dec 2020 13:51:26 +0100
Message-Id: <20201228125053.932528023@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 11a163f2c7d6a9f27ce144cd7e367a81c851621a upstream.

The previous code assumed that a higher hardware value always resulted
in a bigger divider, which is correct for the regular clocks, but is
an invalid assumption when a divider table is provided for the clock.

Perfect example of this is the PLL0_HALF clock, which applies a /2
divider with the hardware value 0, and a /1 divider otherwise.

Fixes: a9fa2893fcc6 ("clk: ingenic: Add support for divider tables")
Cc: <stable@vger.kernel.org> # 5.2
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20201212135733.38050-1-paul@crapouillou.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/ingenic/cgu.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/clk/ingenic/cgu.c
+++ b/drivers/clk/ingenic/cgu.c
@@ -392,15 +392,21 @@ static unsigned int
 ingenic_clk_calc_hw_div(const struct ingenic_cgu_clk_info *clk_info,
 			unsigned int div)
 {
-	unsigned int i;
+	unsigned int i, best_i = 0, best = (unsigned int)-1;
 
 	for (i = 0; i < (1 << clk_info->div.bits)
 				&& clk_info->div.div_table[i]; i++) {
-		if (clk_info->div.div_table[i] >= div)
-			return i;
+		if (clk_info->div.div_table[i] >= div &&
+		    clk_info->div.div_table[i] < best) {
+			best = clk_info->div.div_table[i];
+			best_i = i;
+
+			if (div == best)
+				break;
+		}
 	}
 
-	return i - 1;
+	return best_i;
 }
 
 static unsigned


