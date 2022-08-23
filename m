Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A39E59D5B2
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347955AbiHWJHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240664AbiHWJGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:06:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF6885F83;
        Tue, 23 Aug 2022 01:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5042B81C55;
        Tue, 23 Aug 2022 08:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52295C433D6;
        Tue, 23 Aug 2022 08:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243328;
        bh=K7ahQAN1O3DYTL9J9OrKOMX8MgIAfw6ui3rxdDEwoMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcNwR7KMhVgi9bQg89hKUo46GlDe9ZWAuhKlot2AgtZ5tnpwXYkkdDWO5EBvLMcjh
         zXaWllFuq27xLiDgM2NwFf6ap3UROE1Pr+FN1avAFnACHwpgG/g95bcRNanKAxQbrx
         cnM4Bnn4KGROI1yBgMpcq/Pqkugi7vkWAfwEhhvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 243/365] drm/meson: Fix refcount bugs in meson_vpu_has_available_connectors()
Date:   Tue, 23 Aug 2022 10:02:24 +0200
Message-Id: <20220823080128.399413304@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 91b3c8dbe898df158fd2a84675f3a284ff6666f7 ]

In this function, there are two refcount leak bugs:
(1) when breaking out of for_each_endpoint_of_node(), we need call
the of_node_put() for the 'ep';
(2) we should call of_node_put() for the reference returned by
of_graph_get_remote_port() when it is not used anymore.

Fixes: bbbe775ec5b5 ("drm: Add support for Amlogic Meson Graphic Controller")
Signed-off-by: Liang He <windhl@126.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220726010722.1319416-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 1b70938cfd2c..bd4ca11d3ff5 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -115,8 +115,11 @@ static bool meson_vpu_has_available_connectors(struct device *dev)
 	for_each_endpoint_of_node(dev->of_node, ep) {
 		/* If the endpoint node exists, consider it enabled */
 		remote = of_graph_get_remote_port(ep);
-		if (remote)
+		if (remote) {
+			of_node_put(remote);
+			of_node_put(ep);
 			return true;
+		}
 	}
 
 	return false;
-- 
2.35.1



