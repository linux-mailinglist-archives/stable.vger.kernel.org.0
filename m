Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9381610C15
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 10:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJ1ITt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 04:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJ1ITs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 04:19:48 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF92E101EA;
        Fri, 28 Oct 2022 01:19:45 -0700 (PDT)
Received: from booty.fritz.box (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPA id 150001BF205;
        Fri, 28 Oct 2022 08:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666945183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vqicJIpaIUCqnWaaaf6uDqbeDvMy142ZJ+vF7cMzObg=;
        b=bkKIitouTwGX+kxNBk+gZ1C/8NirLVohgyvNA9v481ufDHZiyykNv8jQ58K6hcQ51bJvbY
        3OHdlEBwpIcPRdjrBnyMJMUrQjx5M40EJ9MYv+pV0cnBQKEAOrsK64BDE+428sxZpcUIYQ
        JPt2PgbhHuZSuCnbBtHSDotME8E0JtTBMWXCggE3M1kS4AL6cpMKmccV+F4hBRiHcFNhfC
        /J89pj8ugT6GSoSmnRrA9QGyYcM76IbCMaMqngzExsY1UX4i0q0E0cgvQM+NYyQ2ssOxWR
        FI3nHWQUgHDxi8bzHsvF834UmiDzMf5tZzlCDb0WXFmVqMw5mcHc1WQiTe6nJA==
From:   luca.ceresoli@bootlin.com
To:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: tegra-video: fix device_node use after free
Date:   Fri, 28 Oct 2022 10:19:26 +0200
Message-Id: <20221028081926.2320663-1-luca.ceresoli@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/staging/media/tegra-video/csi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/tegra-video/csi.c b/drivers/staging/media/tegra-video/csi.c
index b26e44adb2be..1b05f620b476 100644
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
@@ -640,6 +640,7 @@ static void tegra_csi_channels_cleanup(struct tegra_csi *csi)
 			media_entity_cleanup(&subdev->entity);
 		}
 
+		of_node_put(chan->of_node);
 		list_del(&chan->list);
 		kfree(chan);
 	}
-- 
2.34.1

