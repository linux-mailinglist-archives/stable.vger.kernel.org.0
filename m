Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9472594848
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbiHOX23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245140AbiHOXZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:25:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7BF14C364;
        Mon, 15 Aug 2022 13:05:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F4DFB80EAB;
        Mon, 15 Aug 2022 20:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B82C433D6;
        Mon, 15 Aug 2022 20:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593953;
        bh=bwO1Mm4K1TDzi0Wmw7DeJjExMDBZD3OMknw3wAmxiZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfZdGd06xgRXzSOlMFHZ9dT9wgUBA0P1grKfSYFHhRfWy+dUw6j3KeHHv9p9Hwg2E
         k5F6ik7eS/2MnISIiQM30vxJYaCd99sWfLzMdVQS05tIosi69sQOXTTIFQt5yjeLC0
         J6cxdE3lX33AfFM19/PYWuU3gsCarmiZd8chK01c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0340/1157] drm/meson: encoder_cvbs: Fix refcount leak in meson_encoder_cvbs_init
Date:   Mon, 15 Aug 2022 19:54:56 +0200
Message-Id: <20220815180453.279858424@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 7d255ddbbf679aa47e041cbf68520fd985ed2279 ]

of_graph_get_remote_node() returns remote device nodepointer with
refcount incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 318ba02cd8a8 ("drm/meson: encoder_cvbs: switch to bridge with ATTACH_NO_CONNECTOR")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220601033927.47814-2-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_encoder_cvbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/meson/meson_encoder_cvbs.c b/drivers/gpu/drm/meson/meson_encoder_cvbs.c
index fd8db97ba8ba..8110a6e39320 100644
--- a/drivers/gpu/drm/meson/meson_encoder_cvbs.c
+++ b/drivers/gpu/drm/meson/meson_encoder_cvbs.c
@@ -238,6 +238,7 @@ int meson_encoder_cvbs_init(struct meson_drm *priv)
 	}
 
 	meson_encoder_cvbs->next_bridge = of_drm_find_bridge(remote);
+	of_node_put(remote);
 	if (!meson_encoder_cvbs->next_bridge) {
 		dev_err(priv->dev, "Failed to find CVBS Connector bridge\n");
 		return -EPROBE_DEFER;
-- 
2.35.1



