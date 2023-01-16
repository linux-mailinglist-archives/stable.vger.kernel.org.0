Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A4D66CC86
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbjAPR0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbjAPR0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:26:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A323F288
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:03:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE8BF6108B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098ABC433D2;
        Mon, 16 Jan 2023 17:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888619;
        bh=RLbFRT4rSWoiQiRKf7EjKZSZkzYA7nMG9LmlB6bnPs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfh5q7jimSF6RqRNSYydOgqNSJRKIh2vDD18AQ0/tgWWm/V7DTjmr7DNF+O+WBgqI
         Qpi7qMJ7rCcFNUXsa9lUeoAt+jIUWnkqW0if4yPgY7t2kop0f4RamUsRLPMvToTQBs
         GiC8zRpTUY6tK3Q5R6Qq/gF9jyj0RdNe68hk8sM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 074/338] ASoC: pxa: fix null-pointer dereference in filter()
Date:   Mon, 16 Jan 2023 16:49:07 +0100
Message-Id: <20230116154824.110775740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index 624d9bd5dadd..609843f607a3 100644
--- a/sound/soc/pxa/mmp-pcm.c
+++ b/sound/soc/pxa/mmp-pcm.c
@@ -88,7 +88,7 @@ static bool filter(struct dma_chan *chan, void *param)
 
 	devname = kasprintf(GFP_KERNEL, "%s.%d", dma_data->dma_res->name,
 		dma_data->ssp_id);
-	if ((strcmp(dev_name(chan->device->dev), devname) == 0) &&
+	if (devname && (strcmp(dev_name(chan->device->dev), devname) == 0) &&
 		(chan->chan_id == dma_data->dma_res->start)) {
 		found = true;
 	}
-- 
2.35.1



