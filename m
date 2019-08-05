Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5181D37
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfHENU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbfHENU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:20:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA34D20657;
        Mon,  5 Aug 2019 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011225;
        bh=Suut7lwdLdJ61gbHawlyeba1bXqBVef4rcqN5FBxiIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3uG/d4eJ2VLGYr2kL9tSmV8xxuy/YBf4T7Mhuj2umxq3CT84kDkcR6hQOsQGfWaB
         8XwCi2WPlv5uMIzJC2baR+N2rqXpSO9JX9lUtn6MlnmiQPgpIZCEM/t/5gTMgJ+p70
         69eiNVRuTosKcJN2aFURDqEH9Cuf8iOywWctN6w0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 004/131] clk: meson: mpll: properly handle spread spectrum
Date:   Mon,  5 Aug 2019 15:01:31 +0200
Message-Id: <20190805124951.724105609@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f9b3eeebef6aabaa37a351715374de53b6da860c ]

The bit 'SSEN' available on some MPLL DSS outputs is not related to the
fractional part of the divider but to the function called
'Spread Spectrum'.

This function might be used to solve EM issues by adding a jitter on
clock signal. This widens the signal spectrum and weakens the peaks in it.

While spread spectrum might be useful for some application, it is
problematic for others, such as audio.

This patch introduce a new flag to the MPLL driver to enable (or not) the
spread spectrum function.

Fixes: 1f737ffa13ef ("clk: meson: mpll: fix mpll0 fractional part ignored")
Tested-by: Martin Blumenstingl<martin.blumenstingl@googlemail.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/clk-mpll.c | 9 ++++++---
 drivers/clk/meson/clk-mpll.h | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/meson/clk-mpll.c b/drivers/clk/meson/clk-mpll.c
index f76850d99e591..d3f42e0864313 100644
--- a/drivers/clk/meson/clk-mpll.c
+++ b/drivers/clk/meson/clk-mpll.c
@@ -119,9 +119,12 @@ static int mpll_set_rate(struct clk_hw *hw,
 	meson_parm_write(clk->map, &mpll->sdm, sdm);
 	meson_parm_write(clk->map, &mpll->sdm_en, 1);
 
-	/* Set additional fractional part enable if required */
-	if (MESON_PARM_APPLICABLE(&mpll->ssen))
-		meson_parm_write(clk->map, &mpll->ssen, 1);
+	/* Set spread spectrum if possible */
+	if (MESON_PARM_APPLICABLE(&mpll->ssen)) {
+		unsigned int ss =
+			mpll->flags & CLK_MESON_MPLL_SPREAD_SPECTRUM ? 1 : 0;
+		meson_parm_write(clk->map, &mpll->ssen, ss);
+	}
 
 	/* Set the integer divider part */
 	meson_parm_write(clk->map, &mpll->n2, n2);
diff --git a/drivers/clk/meson/clk-mpll.h b/drivers/clk/meson/clk-mpll.h
index cf79340006dd7..0f948430fed48 100644
--- a/drivers/clk/meson/clk-mpll.h
+++ b/drivers/clk/meson/clk-mpll.h
@@ -23,6 +23,7 @@ struct meson_clk_mpll_data {
 };
 
 #define CLK_MESON_MPLL_ROUND_CLOSEST	BIT(0)
+#define CLK_MESON_MPLL_SPREAD_SPECTRUM	BIT(1)
 
 extern const struct clk_ops meson_clk_mpll_ro_ops;
 extern const struct clk_ops meson_clk_mpll_ops;
-- 
2.20.1



