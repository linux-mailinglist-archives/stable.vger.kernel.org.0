Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E768657DA0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiL1PpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiL1PpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB6E17599
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EC1EB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CABC433F0;
        Wed, 28 Dec 2022 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242307;
        bh=xjvKoBeLivq6v7P9u5FJry/N2JD0b8tlAlmnyi/28TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXWdhj3AmDeIZuDRl2w2a+cLA+WUAjcNXGffsPBcjw8g4uEGHrjgCrJsr8A2QtpFc
         LJ5gC1jpOo2m+IsShKN/Z0zp9HU5Bx+Zef6UM09M5XUjtPgGIEtGFJsK0xwwu2GfB9
         ztJ0qEns3jj2KigqLSWc1cBXXOXpBkrazXnUTzi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0391/1073] media: sun8i-a83t-mipi-csi2: Require both pads to be connected for streaming
Date:   Wed, 28 Dec 2022 15:32:59 +0100
Message-Id: <20221228144338.639627784@linuxfoundation.org>
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

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 8985fc724ba89d9b00694304b3f9faf69f4073d0 ]

The bridge needs both its pads connected to be able to stream data.
Enforcing this is useful to produce an error when no sensor is
connected.

Fixes: 576d196c522b ("media: sunxi: Add support for the A83T MIPI CSI-2 controller")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c       | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c
index b032ec13a683..5e1c25db7bc4 100644
--- a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c
+++ b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c
@@ -557,8 +557,10 @@ sun8i_a83t_mipi_csi2_bridge_setup(struct sun8i_a83t_mipi_csi2_device *csi2_dev)
 
 	/* Media Pads */
 
-	pads[SUN8I_A83T_MIPI_CSI2_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
-	pads[SUN8I_A83T_MIPI_CSI2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	pads[SUN8I_A83T_MIPI_CSI2_PAD_SINK].flags = MEDIA_PAD_FL_SINK |
+						    MEDIA_PAD_FL_MUST_CONNECT;
+	pads[SUN8I_A83T_MIPI_CSI2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE |
+						      MEDIA_PAD_FL_MUST_CONNECT;
 
 	ret = media_entity_pads_init(&subdev->entity,
 				     SUN8I_A83T_MIPI_CSI2_PAD_COUNT, pads);
-- 
2.35.1



