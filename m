Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DC846265B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbhK2WvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235423AbhK2WuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:50:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4017FC1404ED;
        Mon, 29 Nov 2021 10:30:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEA19B815E0;
        Mon, 29 Nov 2021 18:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17303C53FC7;
        Mon, 29 Nov 2021 18:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210637;
        bh=ealQz6MoUuGawP9YidU5ktrXKRXEJKwBGS0S/skkpI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13vGn6cAvRT5RUsaOKf5mO779eNDSfh0ijJsJFOIN44uDvO0flAsUKUHpOsXLo/oW
         792U1KHc5xTnDs8HNJv2X4FHNVlj46k33EpqH5xWcCGF8HSfCGQNJEqGyqS1c2qTUT
         IXIS4bcDl+msXVTC2KSV7AWDpT5tpaY5HkHobyNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/121] ASoC: codecs: wcd934x: return error code correctly from hw_params
Date:   Mon, 29 Nov 2021 19:18:02 +0100
Message-Id: <20211129181713.371069326@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 006ea27c4e7037369085755c7b5389effa508c04 ]

Error returned from wcd934x_slim_set_hw_params() are not passed to upper layer,
this could be misleading to the user which can start sending stream leading
to unnecessary errors.

Fix this by properly returning the errors.

Fixes: a61f3b4f476e ("ASoC: wcd934x: add support to wcd9340/wcd9341 codec")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211116114623.11891-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd934x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
index d18ae5e3ee809..699b59cd389c0 100644
--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -1812,9 +1812,8 @@ static int wcd934x_hw_params(struct snd_pcm_substream *substream,
 	}
 
 	wcd->dai[dai->id].sconfig.rate = params_rate(params);
-	wcd934x_slim_set_hw_params(wcd, &wcd->dai[dai->id], substream->stream);
 
-	return 0;
+	return wcd934x_slim_set_hw_params(wcd, &wcd->dai[dai->id], substream->stream);
 }
 
 static int wcd934x_hw_free(struct snd_pcm_substream *substream,
-- 
2.33.0



