Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9526578D5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbiL1Oyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbiL1Oyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:54:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63258DF1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:54:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 070EDB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781B1C433F0;
        Wed, 28 Dec 2022 14:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239276;
        bh=equXzBOScuNHFwsjvnhCbdOTD/DBMaXGysdemzxdUE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3mStEMHLvS/1zjNS2mfpYBWH+/yKxTIEua2KUUfc64M+Z/v3F4DSXuUYGaXLlL1J
         ujAfcUs5bCltF/Xz3blY4RlVLtnmSOH2kXNPKlntmoRswnmN1oQ+IUnFA4D+pUzVvf
         vEGnJCov7JkDgdiuxtaDGs6b8QaeHvMituu4D1F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/731] ASoC: pxa: fix null-pointer dereference in filter()
Date:   Wed, 28 Dec 2022 15:35:02 +0100
Message-Id: <20221228144302.212712226@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit ec7bf231aaa1bdbcb69d23bc50c753c80fb22429 ]

kasprintf() would return NULL pointer when kmalloc() fail to allocate.
Need to check the return pointer before calling strcmp().

Fixes: 7a824e214e25 ("ASoC: mmp: add audio dma support")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Link: https://lore.kernel.org/r/20221114085629.1910435-1-zengheng4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/pxa/mmp-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/pxa/mmp-pcm.c b/sound/soc/pxa/mmp-pcm.c
index 5d520e18e512..99b245e3079a 100644
--- a/sound/soc/pxa/mmp-pcm.c
+++ b/sound/soc/pxa/mmp-pcm.c
@@ -98,7 +98,7 @@ static bool filter(struct dma_chan *chan, void *param)
 
 	devname = kasprintf(GFP_KERNEL, "%s.%d", dma_data->dma_res->name,
 		dma_data->ssp_id);
-	if ((strcmp(dev_name(chan->device->dev), devname) == 0) &&
+	if (devname && (strcmp(dev_name(chan->device->dev), devname) == 0) &&
 		(chan->chan_id == dma_data->dma_res->start)) {
 		found = true;
 	}
-- 
2.35.1



