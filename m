Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1177B66CA32
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbjAPRAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbjAPQ7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:59:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9776D3D089
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:42:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36DC861077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EB3C433EF;
        Mon, 16 Jan 2023 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887360;
        bh=OUgQ3YmlL+kC/xj82o2Oh7xprEho4Eb8CVEzeEQBe6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tj6Vy7qVvDxhjGpg81V5rusUWIb3bS0URM7Hjm/TSR0DpNcK8Zq+36AZNHiEwx1dQ
         U1zD+WN6eN/3LK723i8/BAx+vc/wuHp1UTwFyiwgMPNwiaVmSWfMyyIvgT0Efa8Yy5
         uI4wg/gUT2hYUNvMrtJUSEniELLw0BKHx46XLK/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/521] ASoC: pxa: fix null-pointer dereference in filter()
Date:   Mon, 16 Jan 2023 16:46:04 +0100
Message-Id: <20230116154851.820551150@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index d2d4652de32c..5969aa66410d 100644
--- a/sound/soc/pxa/mmp-pcm.c
+++ b/sound/soc/pxa/mmp-pcm.c
@@ -90,7 +90,7 @@ static bool filter(struct dma_chan *chan, void *param)
 
 	devname = kasprintf(GFP_KERNEL, "%s.%d", dma_data->dma_res->name,
 		dma_data->ssp_id);
-	if ((strcmp(dev_name(chan->device->dev), devname) == 0) &&
+	if (devname && (strcmp(dev_name(chan->device->dev), devname) == 0) &&
 		(chan->chan_id == dma_data->dma_res->start)) {
 		found = true;
 	}
-- 
2.35.1



