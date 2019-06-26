Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E538355FF2
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfFZDnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfFZDnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:45 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-98.mobile.att.net [107.77.172.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37142205ED;
        Wed, 26 Jun 2019 03:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520625;
        bh=Lq68lLSaxopG34QtHV1LpCBzP7UEp0cuXx7y+JYFfKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Io/qCXzrRl1W4XJ9lMOmCgluEQc/zMA5dhFezvd5ksgpxhh25JkQwZcziRwapO6LV
         Kq0yGMvoQ40Anb4pPVt5mLZf2wEDyf9LrDcFEfe19TBrKmiKx80FImoaDES6VVX1L8
         ILl0hM6aIqgrHE03P4vT60MN5iovVoEiycX0qB70=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Viorel Suman <viorel.suman@nxp.com>,
        Shengjiu Wang <shengjiu.wang@nxp.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 04/34] ASoC: ak4458: rstn_control - return a non-zero on error only
Date:   Tue, 25 Jun 2019 23:43:05 -0400
Message-Id: <20190626034335.23767-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034335.23767-1-sashal@kernel.org>
References: <20190626034335.23767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viorel Suman <viorel.suman@nxp.com>

[ Upstream commit 176a11834b65ec35e3b7a953f87fb9cc41309497 ]

snd_soc_component_update_bits() may return 1 if operation
was successful and the value of the register changed.
Return a non-zero in ak4458_rstn_control for an error only.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Signed-off-by: Viorel Suman <viorel.suman@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4458.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ak4458.c b/sound/soc/codecs/ak4458.c
index 58b6ca1de993..3bd57c02e6fd 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -272,7 +272,10 @@ static int ak4458_rstn_control(struct snd_soc_component *component, int bit)
 					  AK4458_00_CONTROL1,
 					  AK4458_RSTN_MASK,
 					  0x0);
-	return ret;
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 static int ak4458_hw_params(struct snd_pcm_substream *substream,
-- 
2.20.1

