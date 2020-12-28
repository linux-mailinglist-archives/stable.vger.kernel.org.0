Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F552E63BD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393036AbgL1Pkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:40:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405813AbgL1NsN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8769E2072C;
        Mon, 28 Dec 2020 13:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163253;
        bh=1pfwzD+awDdbxxPN+pUx6YGW3q557JBUDuhL3doGH6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUQjO0U6aNMOkgaJAjZUBKPYN5/SE8W7OM5cNSReZ+2mPf4niJlwMuSlSQXkmjvOk
         y1n5BOF7GAXxNogA9JTghBT73G441gqRQs18QQ7EzAURWECy+3SMP5Jkf23Qrb8yPE
         V1g0tVXDu2AD7r2VEi07FqTM3k3JL3tJSJIOuXGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 222/453] ASoC: jz4740-i2s: add missed checks for clk_get()
Date:   Mon, 28 Dec 2020 13:47:38 +0100
Message-Id: <20201228124947.901186437@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 1c1fb2653a0c2e3f310c07eacd8fc3a10e08c97a ]

jz4740_i2s_set_sysclk() does not check the return values of clk_get(),
while the file dereferences the pointers in clk_put().
Add the missed checks to fix it.

Fixes: 11bd3dd1b7c2 ("ASoC: Add JZ4740 ASoC support")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Link: https://lore.kernel.org/r/20201203144227.418194-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/jz4740/jz4740-i2s.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index 0bbd86390be59..9bfd2aabbfe63 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -309,10 +309,14 @@ static int jz4740_i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id,
 	switch (clk_id) {
 	case JZ4740_I2S_CLKSRC_EXT:
 		parent = clk_get(NULL, "ext");
+		if (IS_ERR(parent))
+			return PTR_ERR(parent);
 		clk_set_parent(i2s->clk_i2s, parent);
 		break;
 	case JZ4740_I2S_CLKSRC_PLL:
 		parent = clk_get(NULL, "pll half");
+		if (IS_ERR(parent))
+			return PTR_ERR(parent);
 		clk_set_parent(i2s->clk_i2s, parent);
 		ret = clk_set_rate(i2s->clk_i2s, freq);
 		break;
-- 
2.27.0



