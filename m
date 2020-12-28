Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D652E3D67
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440590AbgL1OPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440574AbgL1OPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D419C207A9;
        Mon, 28 Dec 2020 14:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164867;
        bh=2KPMGi7Jhkbvj3Pw9G8QplLFAWCtO5UH5lagZUDzUTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4OnntfhKy4At4R+XrrG/k1SrPcsaQ7RMXPXgmOdSSlia4EC7rlvks5R5ovZfyoO6
         bTqdRJHGiHf5derpRyIvS+0B/fSFhrG9sZOUhH+K1TnNDcFc+FDK3euwfVd7PqJCeT
         5Itfee5E7vVXxQOBN67NfmVly+2L74RAjae09El0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/717] ASoC: q6afe-clocks: Add missing parent clock rate
Date:   Mon, 28 Dec 2020 13:45:08 +0100
Message-Id: <20201228125035.880100731@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 7e20ae1208daaf6dad85c2dcb968fc590b6f3b99 ]

setting clock rate on child clocks without a parent clock rate will
result in zero clk rate for child. This also means that when audio
is started dsp will attempt to access registers without enabling
clock resulting in board boot up.

Fix this by adding the missing parent clock rate.

Fixes: 520a1c396d196 ("ASoC: q6afe-clocks: add q6afe clock controller")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20201204164228.1826-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6afe-clocks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/qcom/qdsp6/q6afe-clocks.c b/sound/soc/qcom/qdsp6/q6afe-clocks.c
index 2efc2eaa04243..acfc0c698f6a1 100644
--- a/sound/soc/qcom/qdsp6/q6afe-clocks.c
+++ b/sound/soc/qcom/qdsp6/q6afe-clocks.c
@@ -16,6 +16,7 @@
 		.afe_clk_id	= Q6AFE_##id,		\
 		.name = #id,				\
 		.attributes = LPASS_CLK_ATTRIBUTE_COUPLE_NO, \
+		.rate = 19200000,			\
 		.hw.init = &(struct clk_init_data) {	\
 			.ops = &clk_q6afe_ops,		\
 			.name = #id,			\
-- 
2.27.0



