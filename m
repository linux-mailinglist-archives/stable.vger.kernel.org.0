Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4367059DEF3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiHWL5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359203AbiHWL4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:56:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C40D83BF8;
        Tue, 23 Aug 2022 02:34:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2635B81C97;
        Tue, 23 Aug 2022 09:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC240C433C1;
        Tue, 23 Aug 2022 09:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247196;
        bh=phNkAC8F+v3jZAAggXWf0wDDXqjfMWFljaMGZEJ/A6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxwRIQYn9jVoPU5wY5wBZVXrYIdMbYclY4R2iB7HMEaFrN1ALDzOMyGYR7mFmrPlg
         6nkMYWwp20pu5PR78YXmoDg9+y6Ktpf5Di0/p8llGN4yRJ0dIr4L6U/FzM4EyYPNu4
         53cU6gK0R3MhGcV/D3a92GycWhZm190jffJ/OBac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 348/389] drm/meson: Fix refcount bugs in meson_vpu_has_available_connectors()
Date:   Tue, 23 Aug 2022 10:27:06 +0200
Message-Id: <20220823080130.081021228@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
index 61a6536e7e61..9a39afc3939b 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -124,8 +124,11 @@ static bool meson_vpu_has_available_connectors(struct device *dev)
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



