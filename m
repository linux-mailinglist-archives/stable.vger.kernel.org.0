Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9050A113135
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfLDR5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:57:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727912AbfLDR5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:57:24 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F5EA20675;
        Wed,  4 Dec 2019 17:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482244;
        bh=e5j/ZtD2OiKfDf7ymG95euYso+ztKBcv2DPMouOhxD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYletN3X4w9ZByns0oJY48VKHiV/Q/RMN1QMrn37tWqTrssI6Oaxt3B1CqvdEcIVF
         dMnK6VEkjpvr4lUIz5vgJvTlnAtKD+puKaSzT5pCq5ry+4pj1UyPVpkIfqThjfjLEV
         Yry5c24N2i+mD97vZI2fFtsDFh5eujy+m/FJBAME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaojun Sang <xsang@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/92] ASoC: compress: fix unsigned integer overflow check
Date:   Wed,  4 Dec 2019 18:49:01 +0100
Message-Id: <20191204174327.881261387@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojun Sang <xsang@codeaurora.org>

[ Upstream commit d3645b055399538415586ebaacaedebc1e5899b0 ]

Parameter fragments and fragment_size are type of u32. U32_MAX is
the correct check.

Signed-off-by: Xiaojun Sang <xsang@codeaurora.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20191021095432.5639-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 771d7b334ad87..07f5017cbea2a 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -501,7 +501,7 @@ static int snd_compress_check_input(struct snd_compr_params *params)
 {
 	/* first let's check the buffer parameter's */
 	if (params->buffer.fragment_size == 0 ||
-	    params->buffer.fragments > INT_MAX / params->buffer.fragment_size ||
+	    params->buffer.fragments > U32_MAX / params->buffer.fragment_size ||
 	    params->buffer.fragments == 0)
 		return -EINVAL;
 
-- 
2.20.1



