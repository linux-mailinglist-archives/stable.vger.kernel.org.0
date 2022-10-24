Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9220D60BBC3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbiJXVMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiJXVLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:11:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D98315FCA;
        Mon, 24 Oct 2022 12:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D502B811FB;
        Mon, 24 Oct 2022 11:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEE8C433D6;
        Mon, 24 Oct 2022 11:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612722;
        bh=XfMKacPpJHtPyrtK6XCrrjpMb+UmbtczHbISfWsQXXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRlbPLl3mzKxwDFbzDqCBi++Wy/p0g8+gzzUzZvUxu7X2yDldGgMYL8PVdImdoPw1
         FlDTCZIJEfiUYadXbiQes6BEEjriGkgWq0w4Rrex6vRcN6yeicJ9pI5P5i6GSkmEnY
         3DgkI634OezbhmRo2U+74hALAmVuPOx7NWd3BZqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/229] drm/mipi-dsi: Detach devices when removing the host
Date:   Mon, 24 Oct 2022 13:30:14 +0200
Message-Id: <20221024113002.116718205@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 668a8f17b5290d04ef7343636a5588a0692731a1 ]

Whenever the MIPI-DSI host is unregistered, the code of
mipi_dsi_host_unregister() loops over every device currently found on that
bus and will unregister it.

However, it doesn't detach it from the bus first, which leads to all kind
of resource leaks if the host wants to perform some clean up whenever a
device is detached.

Fixes: 068a00233969 ("drm: Add MIPI DSI bus support")
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220711173939.1132294-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index 7ed8e510565e..c8c9daecd00d 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -305,6 +305,7 @@ static int mipi_dsi_remove_device_fn(struct device *dev, void *priv)
 {
 	struct mipi_dsi_device *dsi = to_mipi_dsi_device(dev);
 
+	mipi_dsi_detach(dsi);
 	mipi_dsi_device_unregister(dsi);
 
 	return 0;
-- 
2.35.1



