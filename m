Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E095936C0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiHOS5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244650AbiHOSzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:55:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC41048CB9;
        Mon, 15 Aug 2022 11:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 015A060EEB;
        Mon, 15 Aug 2022 18:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087FDC433D7;
        Mon, 15 Aug 2022 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588210;
        bh=eQjlNsFUeo7Ol1B/gW2YN5f5GReWLkx2orpeVdoEiDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chgWhflh6GnDQXhwER+cbG3zsc+FgbhwFwK+Cek3E7ag8Gu9AfMe2vAg7vAj9cClp
         brtGCCTiyQicrzJK7Q5j0bkI3j4KGI1dl6xKXzXVxiZ2AiEO0qYyAlO1whdUKeQC8b
         O9Zs2UE6MivllzedHM8EWA9cpr7dMXGcX+TNMDZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/779] drm/vc4: Use of_device_get_match_data()
Date:   Mon, 15 Aug 2022 19:59:02 +0200
Message-Id: <20220815180350.024639631@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

[ Upstream commit 9cbe89ede58294d23af06ec12c20f2ce6acc1892 ]

Use of_device_get_match_data() to simplify the code.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220214020530.1714631-1-chi.minghao@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dsi.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index 64dfefeb03f5..98308a17e4ed 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -1493,15 +1493,10 @@ static int vc4_dsi_bind(struct device *dev, struct device *master, void *data)
 	struct drm_device *drm = dev_get_drvdata(master);
 	struct vc4_dsi *dsi = dev_get_drvdata(dev);
 	struct vc4_dsi_encoder *vc4_dsi_encoder;
-	const struct of_device_id *match;
 	dma_cap_mask_t dma_mask;
 	int ret;
 
-	match = of_match_device(vc4_dsi_dt_match, dev);
-	if (!match)
-		return -ENODEV;
-
-	dsi->variant = match->data;
+	dsi->variant = of_device_get_match_data(dev);
 
 	vc4_dsi_encoder = devm_kzalloc(dev, sizeof(*vc4_dsi_encoder),
 				       GFP_KERNEL);
-- 
2.35.1



