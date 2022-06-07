Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5065419F7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378541AbiFGV10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378812AbiFGVZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:25:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D32150A2B;
        Tue,  7 Jun 2022 12:01:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B785D61787;
        Tue,  7 Jun 2022 19:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FFCC385A2;
        Tue,  7 Jun 2022 19:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628476;
        bh=YYntbBxSmHLpv4WdmEm/Uq7d1DT6K8VOfuhEt88cfHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUcRw+EngNipYMwYKoKAx4D8PFsvyQncR8ml2xx0PZ2vPG82E0j0xcLQsWUW1IIS6
         x4PElYis39kYqbf7BIf8DJC/SO0EPZxGmynIKM+U45eUfC6FnR3ljkJllAuYpMIQEk
         rnJDbvB3O1rl9ygDJtAVhJzZAs56/kg4FZ8hwzxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 344/879] media: imx: imx-mipi-csis: Fix active format initialization on source pad
Date:   Tue,  7 Jun 2022 18:57:42 +0200
Message-Id: <20220607165012.845606488@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit fe14b546d6e57542dbd4f5ccdb5a382904d26c5a ]

Commit 5c0701a0e791 ("media: imx: csis: Store pads format separately")
broke initialization of the active format on the source pad, as it
forgot to update the .init_cfg() handler. Fix it.

Fixes: 5c0701a0e791 ("media: imx: csis: Store pads format separately")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-mipi-csis.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-mipi-csis.c b/drivers/media/platform/nxp/imx-mipi-csis.c
index d9719d0b2f0a..e0e345fbb00f 100644
--- a/drivers/media/platform/nxp/imx-mipi-csis.c
+++ b/drivers/media/platform/nxp/imx-mipi-csis.c
@@ -994,14 +994,6 @@ static int mipi_csis_init_cfg(struct v4l2_subdev *sd,
 		V4L2_MAP_QUANTIZATION_DEFAULT(false, fmt_sink->colorspace,
 					      fmt_sink->ycbcr_enc);
 
-	/*
-	 * When called from mipi_csis_subdev_init() to initialize the active
-	 * configuration, cfg is NULL, which indicates there's no source pad
-	 * configuration to set.
-	 */
-	if (!sd_state)
-		return 0;
-
 	fmt_source = mipi_csis_get_format(csis, sd_state, which,
 					  CSIS_PAD_SOURCE);
 	*fmt_source = *fmt_sink;
-- 
2.35.1



