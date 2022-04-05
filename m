Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6935F4F3723
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349902AbiDELKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348833AbiDEJsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5679AB3DEC;
        Tue,  5 Apr 2022 02:36:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E386361675;
        Tue,  5 Apr 2022 09:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE380C385A2;
        Tue,  5 Apr 2022 09:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151391;
        bh=SzrysxvBq5ZNLxqpDPYaIE3D44TsoqwU/9BTGFVVG8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyce7OYoMeaoGfSx9h4JKgz8gRHe8w4JiQFBb77lUHtp/UAVI1+3Lt3tMCqrIqnXw
         ixLQeA2hH2rZn4MtqegRldfb/bZdb5BU9eUH3DWrm5V4KyCPyrpGtI5I9bm7XSvmYI
         bigut6eLGU4iF7s/n8VQhy//cD6Wshc2o52MONpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 371/913] ASoC: amd: Fix reference to PCM buffer address
Date:   Tue,  5 Apr 2022 09:23:53 +0200
Message-Id: <20220405070350.967960528@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Tang <tangmeng@uniontech.com>

[ Upstream commit 54e1bf9f6177a3ffbd920474f4481a25361163aa ]

PCM buffers might be allocated dynamically when the buffer
preallocation failed or a larger buffer is requested, and it's not
guaranteed that substream->dma_buffer points to the actually used
buffer.  The driver needs to refer to substream->runtime->dma_addr
instead for the buffer address.

Fixes: cab396d8b22c1 ("ASoC: amd: add ACP5x pcm dma driver ops")
Signed-off-by: Meng Tang <tangmeng@uniontech.com>
Link: https://lore.kernel.org/r/20220316091303.9745-1-tangmeng@uniontech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/vangogh/acp5x-pcm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/vangogh/acp5x-pcm-dma.c b/sound/soc/amd/vangogh/acp5x-pcm-dma.c
index f10de38976cb..6abcc2133a2c 100644
--- a/sound/soc/amd/vangogh/acp5x-pcm-dma.c
+++ b/sound/soc/amd/vangogh/acp5x-pcm-dma.c
@@ -281,7 +281,7 @@ static int acp5x_dma_hw_params(struct snd_soc_component *component,
 		return -EINVAL;
 	}
 	size = params_buffer_bytes(params);
-	rtd->dma_addr = substream->dma_buffer.addr;
+	rtd->dma_addr = substream->runtime->dma_addr;
 	rtd->num_pages = (PAGE_ALIGN(size) >> PAGE_SHIFT);
 	config_acp5x_dma(rtd, substream->stream);
 	return 0;
-- 
2.34.1



