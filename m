Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E5630C046
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhBBNxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233126AbhBBNvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:51:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A0664FBB;
        Tue,  2 Feb 2021 13:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273418;
        bh=JjyaAa0fvSRvaup4My50xq+W9CTjToQ9nFsyguBRguw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpFtPBtuhbPn+hZgYdaBPkI6Xu+FTQDLgRc2jkZM5ZNeRlGJzWJXQfyPemrwkSmTb
         zu8EBR+mFxeL9kRKywImbWJ2O8C+7NA9qkQ06sWOf48lIzv5nqXrHRKkLg6Wl+Apwt
         DRklxkLMbqrqIAcjafIsfOoP4IuUfY2l+jME3GiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/142] ASoC: qcom: lpass: Fix out-of-bounds DAI ID lookup
Date:   Tue,  2 Feb 2021 14:37:42 +0100
Message-Id: <20210202133001.797749691@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 70041000450d0a071bf9931d634c8e2820340236 ]

The "dai_id" given into LPAIF_INTFDMA_REG(...) is already the real
DAI ID, not an index into v->dai_driver. Looking it up again seems
entirely redundant.

For IPQ806x (and SC7180 since commit 09a4f6f5d21c
("ASoC: dt-bindings: lpass: Fix and common up lpass dai ids") this is
now often an out-of-bounds read because the indexes in the "dai_driver"
array no longer match the actual DAI ID.

Cc: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Fixes: 7cb37b7bd0d3 ("ASoC: qcom: Add support for lpass hdmi driver")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210125104442.135899-1-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-lpaif-reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/qcom/lpass-lpaif-reg.h b/sound/soc/qcom/lpass-lpaif-reg.h
index 405542832e994..baf72f124ea9b 100644
--- a/sound/soc/qcom/lpass-lpaif-reg.h
+++ b/sound/soc/qcom/lpass-lpaif-reg.h
@@ -133,7 +133,7 @@
 #define	LPAIF_WRDMAPERCNT_REG(v, chan)	LPAIF_WRDMA_REG_ADDR(v, 0x14, (chan))
 
 #define LPAIF_INTFDMA_REG(v, chan, reg, dai_id)  \
-		((v->dai_driver[dai_id].id ==  LPASS_DP_RX) ? \
+	((dai_id ==  LPASS_DP_RX) ? \
 		LPAIF_HDMI_RDMA##reg##_REG(v, chan) : \
 		 LPAIF_RDMA##reg##_REG(v, chan))
 
-- 
2.27.0



