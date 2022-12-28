Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA270657D53
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiL1Pm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbiL1PmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ABC1705B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:41:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97C116155E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7DDC433D2;
        Wed, 28 Dec 2022 15:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242114;
        bh=q4sc++3K2GfvUAKwubTjvcqFLgZ2ewrtLeGPqSmaAzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yvjnua6MfBaRLzXsDUO1XJuT9E/qQ2NFZ+B5Hx829S8xT4jBfu2a94n9nuZoqob2B
         4ywjksizxZtrNmRPU5+Y/uAPYhIYkAY8x6CaUuvIzp8tlWlagefXghQ6vfZ47wbcd3
         NIv4RrDBK2Ty4zekav/AwVkJf3bMrhV4wMF/9zMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0362/1073] ASoC: Intel: avs: Lock substream before snd_pcm_stop()
Date:   Wed, 28 Dec 2022 15:32:30 +0100
Message-Id: <20221228144337.834349728@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit c30c8f9d51ec24b36e2c65a6307a5c8cbc5a0ebc ]

snd_pcm_stop() shall be called with stream lock held to prevent any
races between nonatomic streaming operations.

Fixes: 2f1f570cd730 ("ASoC: Intel: avs: Coredump and recovery flow")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20221116115550.1100398-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/ipc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/avs/ipc.c b/sound/soc/intel/avs/ipc.c
index 77da206f7dbb..306f0dc4eaf5 100644
--- a/sound/soc/intel/avs/ipc.c
+++ b/sound/soc/intel/avs/ipc.c
@@ -123,7 +123,10 @@ static void avs_dsp_recovery(struct avs_dev *adev)
 				if (!substream || !substream->runtime)
 					continue;
 
+				/* No need for _irq() as we are in nonatomic context. */
+				snd_pcm_stream_lock(substream);
 				snd_pcm_stop(substream, SNDRV_PCM_STATE_DISCONNECTED);
+				snd_pcm_stream_unlock(substream);
 			}
 		}
 	}
-- 
2.35.1



