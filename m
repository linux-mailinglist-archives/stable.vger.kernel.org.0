Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637DF111F81
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfLCWnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbfLCWnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:43:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87FA920803;
        Tue,  3 Dec 2019 22:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412997;
        bh=+Hz+Ao4dDcXjXczZVteRoqEv8s0WbV8i9BoU8i5d+K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kkj8+zZ1566QykRn13DFei735H91C4EboQ/Jk4n5CznkUEaWyRpYcRZl/CaRls4l+
         q7P60YTshAGsnj1qKw0jvFmIJzAKiv9P3ie8GIi3Mx51OS8M9g/fcuifBdcaokb0BW
         IyqxmDDPcBx+acJ+8VwwxWbwJV4t+YA3QkwFwjUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.3 097/135] clk: at91: fix update bit maps on CFG_MOR write
Date:   Tue,  3 Dec 2019 23:35:37 +0100
Message-Id: <20191203213038.215230846@linuxfoundation.org>
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
@@ -156,7 +156,7 @@ at91_clk_register_main_osc(struct regmap
 	if (bypass)
 		regmap_update_bits(regmap,
 				   AT91_CKGR_MOR, MOR_KEY_MASK |
-				   AT91_PMC_MOSCEN,
+				   AT91_PMC_OSCBYPASS,
 				   AT91_PMC_OSCBYPASS | AT91_PMC_KEY);
 
 	hw = &osc->hw;


