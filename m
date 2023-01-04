Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD90D65D87C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239850AbjADQPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239841AbjADQPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:15:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4149DDFC4
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8646AB81714
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0732C433D2;
        Wed,  4 Jan 2023 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848871;
        bh=jiIx4HYpVT3taMwTPfdx3q/sP+YnH5gARTg3EPGV9x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkDdYBcHPwQ11yLdcA/vWBaYF8Jdpsm6VkwxIrPJhratn2V3A+DHL+77Q2PYcCn42
         v9GndGiD0DUQ/FGKWDD2lPmH9EbA6YZw3hjCDUUzCl0x1Q0y38ALjZ/bm5pFUJEbJX
         yTYOmcoEwav4VAgkkPUDhRt4qjacEjmDA99wKYvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 097/207] staging: media: tegra-video: fix chan->mipi value on error
Date:   Wed,  4 Jan 2023 17:05:55 +0100
Message-Id: <20230104160514.996375985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit 10b5ce6743c839fa75336042c64e2479caec9430 upstream.

chan->mipi takes the return value of tegra_mipi_request() which can be a
valid pointer or an error. However chan->mipi is checked in several places,
including error-cleanup code in tegra_csi_channels_cleanup(), as 'if
(chan->mipi)', which suggests the initial intent was that chan->mipi should
be either NULL or a valid pointer, never an error. As a consequence,
cleanup code in case of tegra_mipi_request() errors would dereference an
invalid pointer.

Fix by ensuring chan->mipi always contains either NULL or a void pointer.

Also add that to the documentation.

Fixes: 523c857e34ce ("media: tegra-video: Add CSI MIPI pads calibration")
Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/tegra-video/csi.c |    1 +
 drivers/staging/media/tegra-video/csi.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/media/tegra-video/csi.c
+++ b/drivers/staging/media/tegra-video/csi.c
@@ -448,6 +448,7 @@ static int tegra_csi_channel_alloc(struc
 	chan->mipi = tegra_mipi_request(csi->dev, node);
 	if (IS_ERR(chan->mipi)) {
 		ret = PTR_ERR(chan->mipi);
+		chan->mipi = NULL;
 		dev_err(csi->dev, "failed to get mipi device: %d\n", ret);
 	}
 
--- a/drivers/staging/media/tegra-video/csi.h
+++ b/drivers/staging/media/tegra-video/csi.h
@@ -56,7 +56,7 @@ struct tegra_csi;
  * @framerate: active framerate for TPG
  * @h_blank: horizontal blanking for TPG active format
  * @v_blank: vertical blanking for TPG active format
- * @mipi: mipi device for corresponding csi channel pads
+ * @mipi: mipi device for corresponding csi channel pads, or NULL if not applicable (TPG, error)
  * @pixel_rate: active pixel rate from the sensor on this channel
  */
 struct tegra_csi_channel {


