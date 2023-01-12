Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461C86677E8
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240065AbjALOu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240071AbjALOuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0BE120B4
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE8662037
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56270C433D2;
        Thu, 12 Jan 2023 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534213;
        bh=kjMTYuvImgGqVxRGl4RYX1kN/el3Z79nv0IS4eFNTbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAxi8A4TdwiPhY8OteVZgf2wAWD5HkRJoeryfCO6wDlDb0z1pEwy5WV17A7hs0bn1
         uod3JYfE4RDwHqkTnNn6X3QvDyXS1dPzuP1RBE7O/VMUPOtITV+4x5Ltaf6DXrPqvQ
         bXorB6oDlBMCbk3VzKK8f79JVK75QpZY2HFxAMD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 703/783] staging: media: tegra-video: fix device_node use after free
Date:   Thu, 12 Jan 2023 14:56:59 +0100
Message-Id: <20230112135556.933780883@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit c4d344163c3a7f90712525f931a6c016bbb35e18 ]

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
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/tegra-video/csi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/tegra-video/csi.c b/drivers/staging/media/tegra-video/csi.c
index edfdf6db457d..dc5d432a09e8 100644
--- a/drivers/staging/media/tegra-video/csi.c
+++ b/drivers/staging/media/tegra-video/csi.c
@@ -420,7 +420,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
 	chan->csi = csi;
 	chan->csi_port_num = port_num;
 	chan->numlanes = lanes;
-	chan->of_node = node;
+	chan->of_node = of_node_get(node);
 	chan->numpads = num_pads;
 	if (num_pads & 0x2) {
 		chan->pads[0].flags = MEDIA_PAD_FL_SINK;
@@ -621,6 +621,7 @@ static void tegra_csi_channels_cleanup(struct tegra_csi *csi)
 			media_entity_cleanup(&subdev->entity);
 		}
 
+		of_node_put(chan->of_node);
 		list_del(&chan->list);
 		kfree(chan);
 	}
-- 
2.35.1



