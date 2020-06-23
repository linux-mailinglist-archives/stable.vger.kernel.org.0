Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61542205E5F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390087AbgFWUVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389502AbgFWUVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:21:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADCB3206C3;
        Tue, 23 Jun 2020 20:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943709;
        bh=Ty64d1vuBGkU61eNxazHWsARkzaUJEpcTE9bxj8RU1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbIUkF1DbBCDFNutLnk6yLfgujG0Q0BOdA228usIWyNbIQCwsWTrhmymxfCqpHw7Z
         hL/7hnIP28TDwDi3RtDnG9eM2opsKDGSYuTJNo+7oUFHCNU990TcNIE/bAxTnmHxCK
         BSws3ENYg9jB1n8TPzip8xg64Lnyu91T2aNyRIco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/314] clk: sunxi: Fix incorrect usage of round_down()
Date:   Tue, 23 Jun 2020 21:53:17 +0200
Message-Id: <20200623195338.889052929@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>

[ Upstream commit ee25d9742dabed3fd18158b518f846abeb70f319 ]

round_down() can only round to powers of 2. If round_down() is asked
to round to something that is not a power of 2, incorrect results are
produced. The incorrect results can be both too large and too small.

Instead, use rounddown() which can round to any number.

Fixes: 6a721db180a2 ("clk: sunxi: Add A31 clocks support")
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi/clk-sunxi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 27201fd26e442..e1aa1fbac48a0 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -90,7 +90,7 @@ static void sun6i_a31_get_pll1_factors(struct factors_request *req)
 	 * Round down the frequency to the closest multiple of either
 	 * 6 or 16
 	 */
-	u32 round_freq_6 = round_down(freq_mhz, 6);
+	u32 round_freq_6 = rounddown(freq_mhz, 6);
 	u32 round_freq_16 = round_down(freq_mhz, 16);
 
 	if (round_freq_6 > round_freq_16)
-- 
2.25.1



