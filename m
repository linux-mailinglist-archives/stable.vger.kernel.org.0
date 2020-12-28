Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7932E40E9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391409AbgL1PAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:00:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440355AbgL1OON (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFB9720791;
        Mon, 28 Dec 2020 14:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164838;
        bh=HkQNGuDLBcLyT4n671Nr1Wh6qWyfViQKJuRN0EBJyz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBUH/AkaX7SJ92JqETIjFibnLdmRNQJcjxn+mks8fPu4H25hZnhB8+1v9Xxxjab0l
         3ByxeBDxmNUNlMRc6LMpXIm77PHV6mIbcC/igR8g0E1Btn6MASyxx47QEUOfnAcT5n
         ovgnzCPkKPJ+xuK2JeESBppabehopqpXmQ7jehQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/717] ASoC: jz4740-i2s: add missed checks for clk_get()
Date:   Mon, 28 Dec 2020 13:45:07 +0100
Message-Id: <20201228125035.832966907@linuxfoundation.org>
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
index c7bd20104b204..0793e284d0e78 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -312,10 +312,14 @@ static int jz4740_i2s_set_sysclk(struct snd_soc_dai *dai, int clk_id,
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



