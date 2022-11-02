Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCEB616159
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 12:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiKBLCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 07:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiKBLCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 07:02:22 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96742222B0;
        Wed,  2 Nov 2022 04:02:20 -0700 (PDT)
Received: from booty.fritz.box (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPA id 21E19FF81A;
        Wed,  2 Nov 2022 11:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667386936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AIWP8hCG3H8802+ZOuJvt5Vl5+0UlGU9wyMe8L68JX0=;
        b=il6dEg4V1FoLPtn1gLJiTHTPHNENeF9bzb58WJ1zQuz2JTaOA2NIyarOSIrsc3xmXKiCiL
        Nn1Nn+uwyVC39P7pdBs+56MGUX9ac6tCHwu8QqQQI4vVQ/Cf913yJa28Ve4/J2/8zwSZll
        xOvQ9/HGzov3hy0WiEwVwTuvgEXKknj1OXO7fDh0+yiyfSWG52xp452qr2s5kCP40MIYpG
        W/6GNcYmsCaih1/I3yBfG/VnxWgnNrKAm3zUn3/6cSJVgxSh518GIQSU6NSP9guwDSlwZt
        +8NRQ2dA+nN/hz7oMOZn9HDB0vwiHSvMyYfb4rqltdrpk9ozXIAwKsdHb5wqfA==
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
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2 1/2] staging: media: tegra-video: fix chan->mipi value on error
Date:   Wed,  2 Nov 2022 12:01:01 +0100
Message-Id: <20221102110102.25050-1-luca.ceresoli@bootlin.com>
X-Mailer: git-send-email 2.34.1
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

---

This patch was added in v2.
---
 drivers/staging/media/tegra-video/csi.c | 1 +
 drivers/staging/media/tegra-video/csi.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/tegra-video/csi.c b/drivers/staging/media/tegra-video/csi.c
index b26e44adb2be..6b59ef55c525 100644
--- a/drivers/staging/media/tegra-video/csi.c
+++ b/drivers/staging/media/tegra-video/csi.c
@@ -448,6 +448,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
 	chan->mipi = tegra_mipi_request(csi->dev, node);
 	if (IS_ERR(chan->mipi)) {
 		ret = PTR_ERR(chan->mipi);
+		chan->mipi = NULL;
 		dev_err(csi->dev, "failed to get mipi device: %d\n", ret);
 	}
 
diff --git a/drivers/staging/media/tegra-video/csi.h b/drivers/staging/media/tegra-video/csi.h
index 4ee05a1785cf..6960ea2e3d36 100644
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
-- 
2.34.1

