Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEA8616157
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 12:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiKBLCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 07:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiKBLCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 07:02:22 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D93C1C12F;
        Wed,  2 Nov 2022 04:02:19 -0700 (PDT)
Received: from booty.fritz.box (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPA id E13CDFF81B;
        Wed,  2 Nov 2022 11:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667386938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BsVwSyTy7VR6zA7SYC3DsZTfRvN6uc9dyTL1pmSjsKc=;
        b=S9wMALCHC+8JwGZW0fLzV0Yl0hnE4rD+7X1HlvjAbPHVOE9uzHDWQWMVKB9odDx3QD1cma
        grde237SUWw9gSJ1zZDAlB7eBlLjo7OGi+MBtMQVd3nIjRL+SZIksNHMxKDyXNzeQGo+eU
        iU6BmZ2aDzL6ZrkXg2ip3K+pdJg3/SrLG+lr2T5EhhU8aWndjlbfC+uk5jx0Hd1UGRfbRs
        6QjHSBOfKvvzuZwAYU0Uov+FEbsrVMORETB2FW3ZW6Hvdku2aEBPNFc6O7eM2gSo7IMpY6
        vZ0SICKwlBKnqvrdlQVhP2/zn1TBi0jnMUqgulniY995e1OMxtn12ptSzk29XQ==
From:   luca.ceresoli@bootlin.com
To:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca.ceresoli@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] staging: media: tegra-video: fix device_node use after free
Date:   Wed,  2 Nov 2022 12:01:02 +0100
Message-Id: <20221102110102.25050-2-luca.ceresoli@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102110102.25050-1-luca.ceresoli@bootlin.com>
References: <20221102110102.25050-1-luca.ceresoli@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

At probe time this code path is followed:

 * tegra_csi_init
   * tegra_csi_channels_alloc
     * for_each_child_of_node(node, channel) -- iterates over channels
       * automatically gets 'channel'
         * tegra_csi_channel_alloc()
           * saves into chan->of_node a pointer to the channel OF node
       * automatically gets and puts 'channel'
       * now the node saved in chan->of_node has refcount 0, can disappear
   * tegra_csi_channels_init
     * iterates over channels
       * tegra_csi_channel_init -- uses chan->of_node

After that, chan->of_node keeps storing the node until the device is
removed.

of_node_get() the node and of_node_put() it during teardown to avoid any
risk.

Fixes: 1ebaeb09830f ("media: tegra-video: Add support for external sensor capture")
Cc: stable@vger.kernel.org
Cc: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

---

No changes in v2.
---
 drivers/staging/media/tegra-video/csi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/tegra-video/csi.c b/drivers/staging/media/tegra-video/csi.c
index 6b59ef55c525..426e653bd55d 100644
--- a/drivers/staging/media/tegra-video/csi.c
+++ b/drivers/staging/media/tegra-video/csi.c
@@ -433,7 +433,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
 	for (i = 0; i < chan->numgangports; i++)
 		chan->csi_port_nums[i] = port_num + i * CSI_PORTS_PER_BRICK;
 
-	chan->of_node = node;
+	chan->of_node = of_node_get(node);
 	chan->numpads = num_pads;
 	if (num_pads & 0x2) {
 		chan->pads[0].flags = MEDIA_PAD_FL_SINK;
@@ -641,6 +641,7 @@ static void tegra_csi_channels_cleanup(struct tegra_csi *csi)
 			media_entity_cleanup(&subdev->entity);
 		}
 
+		of_node_put(chan->of_node);
 		list_del(&chan->list);
 		kfree(chan);
 	}
-- 
2.34.1

