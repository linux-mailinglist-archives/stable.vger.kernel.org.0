Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43A6608734
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiJVH5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiJVHzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:55:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EBE108DCE;
        Sat, 22 Oct 2022 00:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8497DB82DF1;
        Sat, 22 Oct 2022 07:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A07C433D6;
        Sat, 22 Oct 2022 07:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424876;
        bh=Gdu8FkS/FwQ0ued/QFrnPBGMV5XAprYfU7DZMznsFag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZ1fVqY7WBzNjKlsHxU6NP/lw4fclO0p2fHoG9C9UgrhHbzTwqg3CNw+O6MJURtkD
         XTGBbDnHFlXLxjbelh0fBSLUsb9HK1tELTOrZA3DHahsl4+gz3dZkLltCzlfGWwDC9
         sQH1PwRvvZn77lHkPJhvCGFYmts+InbuD4yslMI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 310/717] ASoC: soc-pcm.c: call __soc_pcm_close() in soc_pcm_close()
Date:   Sat, 22 Oct 2022 09:23:09 +0200
Message-Id: <20221022072507.380977444@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 6bbabd28805f36baf6d0f3eb082db032a638f612 ]

commit b7898396f4bbe16 ("ASoC: soc-pcm: Fix and cleanup DPCM locking")
added __soc_pcm_close() for non-lock version of soc_pcm_close().
But soc_pcm_close() is not using it. It is no problem, but confusable.

	static int __soc_pcm_close(...)
	{
=>		return soc_pcm_clean(rtd, substream, 0);
	}

	static int soc_pcm_close(...)
	{
		...
		snd_soc_dpcm_mutex_lock(rtd);
=>		soc_pcm_clean(rtd, substream, 0);
		snd_soc_dpcm_mutex_unlock(rtd);
		return 0;
	}

This patch use it.

Fixes: b7898396f4bbe16 ("ASoC: soc-pcm: Fix and cleanup DPCM locking")
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87czctgg3w.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 0c1de5624842..6359d00b7bda 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -723,7 +723,7 @@ static int soc_pcm_close(struct snd_pcm_substream *substream)
 	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
 
 	snd_soc_dpcm_mutex_lock(rtd);
-	soc_pcm_clean(rtd, substream, 0);
+	__soc_pcm_close(rtd, substream);
 	snd_soc_dpcm_mutex_unlock(rtd);
 	return 0;
 }
-- 
2.35.1



