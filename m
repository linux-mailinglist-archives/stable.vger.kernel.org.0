Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B83113302
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbfLDSNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729497AbfLDSNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:13:52 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D4E820674;
        Wed,  4 Dec 2019 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483231;
        bh=Nf0DVFVuptbAyQMUFY7AZ2jp/QtCcsFowue809GM62E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpScb04dAu9gjAUbmRltamSV679CqOlSsDFmWxJHUS2WXG4pF0J5bJlpLE/u/z9Da
         LPNGmyXPKmjQfm6CS8snct+enLrJWcMuNvw0wZ8cInrJFzW2pz/0aKhz3M4g+TBDC1
         32kTEBsZH9ZJkSxXTDD16BBYfnm1+gDFIazX0t0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 106/125] clk: at91: fix update bit maps on CFG_MOR write
Date:   Wed,  4 Dec 2019 18:56:51 +0100
Message-Id: <20191204175325.558671905@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

commit 263eaf8f172d9f44e15d6aca85fe40ec18d2c477 upstream.

The regmap update bits call was not selecting the proper mask, considering
the bits which was updating.
Update the mask from call to also include OSCBYPASS.
Removed MOSCEN which was not updated.

Fixes: 1bdf02326b71 ("clk: at91: make use of syscon/regmap internally")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Link: https://lkml.kernel.org/r/1568042692-11784-1-git-send-email-eugen.hristev@microchip.com
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/at91/clk-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -162,7 +162,7 @@ at91_clk_register_main_osc(struct regmap
 	if (bypass)
 		regmap_update_bits(regmap,
 				   AT91_CKGR_MOR, MOR_KEY_MASK |
-				   AT91_PMC_MOSCEN,
+				   AT91_PMC_OSCBYPASS,
 				   AT91_PMC_OSCBYPASS | AT91_PMC_KEY);
 
 	hw = &osc->hw;


