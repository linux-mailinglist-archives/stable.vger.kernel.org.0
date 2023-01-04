Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EE665D531
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbjADOMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239705AbjADOLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:11:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126C739FAB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7F6B3CE17BB
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F549C433EF;
        Wed,  4 Jan 2023 14:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841482;
        bh=EW5cHZJyXSWlu8cHw6Ge3vBcCpm3MEkGyBooUXUS8fs=;
        h=Subject:To:Cc:From:Date:From;
        b=XriZEe3wRRJ082gJKaeTNW6/QGCPIg128MbK0TkMhuVGUDNoCKKeSudFtF/GkdgU7
         1ztyyU8wtU2t7Tyq83nmNic7ts/pmAmm33i+qgwbMyK2Ug/y+lROvrg4bBLH7bm7ub
         VAfZwnzJw3a3IbPU3QWY7ePUITMIFcNhSFWfoXmw=
Subject: FAILED: patch "[PATCH] staging: media: tegra-video: fix device_node use after free" failed to apply to 5.10-stable tree
To:     luca.ceresoli@bootlin.com, hverkuil-cisco@xs4all.nl,
        skomatineni@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:11:19 +0100
Message-ID: <1672841479123169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c4d344163c3a ("staging: media: tegra-video: fix device_node use after free")
2ac4035a78c9 ("media: tegra-video: Add support for x8 captures with gang ports")
4281d115a4eb ("media: tegra-video: Add DV timing support")
fbef4d6bb92e ("media: tegra-video: Add support for V4L2_PIX_FMT_NV16")
c1bcc5472825 ("media: tegra-video: Enable VI pixel transform for YUV and RGB formats")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c4d344163c3a7f90712525f931a6c016bbb35e18 Mon Sep 17 00:00:00 2001
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Date: Wed, 2 Nov 2022 12:01:02 +0100
Subject: [PATCH] staging: media: tegra-video: fix device_node use after free

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

