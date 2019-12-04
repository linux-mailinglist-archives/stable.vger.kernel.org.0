Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3BAF1131BC
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbfLDSCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:02:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729219AbfLDSCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:02:03 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682E5206DF;
        Wed,  4 Dec 2019 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482522;
        bh=DFBgrIvg0BuTOOkN8cvpbyIpAt5L15g4xAD3vpifjs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzNd93WAIS/6+g9CmDA8qCr99t4XOd+9JkwmUhRVlLGz3kF7QmI56JFp5DqDPmN6V
         dO+VR10y8dglUYaI2jqnjBcWrizqknlxA2ueHfadzQhAG+7Qetb64u9eFG4whpRzsF
         WMrDqZv4GW1IbkDDlRYONnWsNjf4orCt013Rbxrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaojun Sang <xsang@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 003/209] ASoC: compress: fix unsigned integer overflow check
Date:   Wed,  4 Dec 2019 18:53:35 +0100
Message-Id: <20191204175321.829108804@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
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
index 2e2d184684911..7ae8e24dc1e61 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -529,7 +529,7 @@ static int snd_compress_check_input(struct snd_compr_params *params)
 {
 	/* first let's check the buffer parameter's */
 	if (params->buffer.fragment_size == 0 ||
-	    params->buffer.fragments > INT_MAX / params->buffer.fragment_size ||
+	    params->buffer.fragments > U32_MAX / params->buffer.fragment_size ||
 	    params->buffer.fragments == 0)
 		return -EINVAL;
 
-- 
2.20.1



