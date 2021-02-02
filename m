Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58C030CC67
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbhBBTzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:55:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233101AbhBBNvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:51:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2A2864FAD;
        Tue,  2 Feb 2021 13:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273397;
        bh=EwSJI7guOYK9sFz6egHIaX64JJWlFE5JLKQozCq4avo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSR9DyaSN7StFJIPedd36ePDslG6DFVSZmnIDx2h0tWdkzUlNGQYsXzNLoLPQCnGI
         u07aYj1KfvB6JmcHNkCYDQt9jSM1LMA9UE31rNpNPM9wmr2S9LR8kvusyZRwKCW5MJ
         viCcZ2Jc1YakdJ/UpnUd6BCR3kEi51r5rqshl+As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/142] ASoC: qcom: lpass-ipq806x: fix bitwidth regmap field
Date:   Tue,  2 Feb 2021 14:37:35 +0100
Message-Id: <20210202133001.507959801@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 1e066a23e76f90c9c39c189fe0dbf7c6e3dd5044 ]

BIT_WIDTH field in I2S_CTL register is two bits wide, however
recent regmap field conversion patch trimmed it down to one bit.
Fix this by correcting the bit range!

Fixes: b5022a36d28f ("ASoC: qcom: lpass: Use regmap_field for i2sctl and dmactl registers")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210119174700.32639-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-ipq806x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/qcom/lpass-ipq806x.c b/sound/soc/qcom/lpass-ipq806x.c
index 832a9161484e7..3a45e6a26f04b 100644
--- a/sound/soc/qcom/lpass-ipq806x.c
+++ b/sound/soc/qcom/lpass-ipq806x.c
@@ -131,7 +131,7 @@ static struct lpass_variant ipq806x_data = {
 	.micmode		= REG_FIELD_ID(0x0010, 4, 7, 5, 0x4),
 	.micmono		= REG_FIELD_ID(0x0010, 3, 3, 5, 0x4),
 	.wssrc			= REG_FIELD_ID(0x0010, 2, 2, 5, 0x4),
-	.bitwidth		= REG_FIELD_ID(0x0010, 0, 0, 5, 0x4),
+	.bitwidth		= REG_FIELD_ID(0x0010, 0, 1, 5, 0x4),
 
 	.rdma_dyncclk		= REG_FIELD_ID(0x6000, 12, 12, 4, 0x1000),
 	.rdma_bursten		= REG_FIELD_ID(0x6000, 11, 11, 4, 0x1000),
-- 
2.27.0



