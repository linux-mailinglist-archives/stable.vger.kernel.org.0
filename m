Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DB9593F4E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbiHOVCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346677AbiHOUzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:55:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858483B94C;
        Mon, 15 Aug 2022 12:11:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D73460BB5;
        Mon, 15 Aug 2022 19:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1868FC433C1;
        Mon, 15 Aug 2022 19:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590669;
        bh=hP/9KZye9mvWkD+qnzNh7Mn9ujOi/BfJgmHbNS6xy7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntO2nN81cF3GIceOa6Qc/Bs2VhqrJ+37ThCcVIOl6Md60UfAqth2Rj9YbLDI4MU/4
         wMJ/dUyH0kxyI3NFnT7OYsazHM+VQ00X9mA1VsIoBS3RK3p92ftvKEEzUPq1z/H+UQ
         jxP+XOFJ/ezfAvbbVRsSs0txfIfiZee1iDuUcm1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0302/1095] drm/meson: Fix refcount leak in meson_encoder_hdmi_init
Date:   Mon, 15 Aug 2022 19:55:01 +0200
Message-Id: <20220815180442.263636035@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 7381076809586528e2a812a709e2758916318a99 ]

of_find_device_by_node() takes reference, we should use put_device()
to release it when not need anymore.
Add missing put_device() in error path to avoid refcount
leak.

Fixes: 0af5e0b41110 ("drm/meson: encoder_hdmi: switch to bridge DRM_BRIDGE_ATTACH_NO_CONNECTOR")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220511054052.51981-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_encoder_hdmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/meson/meson_encoder_hdmi.c b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
index 5e306de6f485..de87f02cd388 100644
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -435,8 +435,10 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 		cec_fill_conn_info_from_drm(&conn_info, meson_encoder_hdmi->connector);
 
 		notifier = cec_notifier_conn_register(&pdev->dev, NULL, &conn_info);
-		if (!notifier)
+		if (!notifier) {
+			put_device(&pdev->dev);
 			return -ENOMEM;
+		}
 
 		meson_encoder_hdmi->cec_notifier = notifier;
 	}
-- 
2.35.1



