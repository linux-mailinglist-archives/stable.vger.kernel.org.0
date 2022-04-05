Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506A34F36EB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbiDELI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348797AbiDEJsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120418A308;
        Tue,  5 Apr 2022 02:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF882B81C8B;
        Tue,  5 Apr 2022 09:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8F0C385A6;
        Tue,  5 Apr 2022 09:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151338;
        bh=XoLi14Jvj17Qay94bQj6Gt2sk1ZC6Zgsi2JS+PwQfOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2jh/OlpDQFrdQkpmmhjB75ojN7zIWv90fR3BbuqHyV5TZElICAcvHBkhJgKjD4/A
         ynWYitW8Ug2C5f9gus/QgPaL37nlzoUPekR6LRLFeAPtkbvwfiX7QWG6s7hsatb+cj
         ItGJ5k0siyJmgZ7Q3PV7BCLhhmtTm6dwWJEVpDw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 380/913] drm/bridge: nwl-dsi: Fix PM disable depth imbalance in nwl_dsi_probe
Date:   Tue,  5 Apr 2022 09:24:02 +0200
Message-Id: <20220405070351.238496841@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit b146e343a9e05605b491b1bf4a2b62a39d5638d8 ]

The pm_runtime_enable will increase power disable depth.
Thus a pairing decrement is needed on the error handling
path to keep it balanced according to context.

Fixes: 44cfc6233447 ("drm/bridge: Add NWL MIPI DSI host controller support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220105104826.1418-1-linmq006@gmail.com
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/nwl-dsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index af07eeb47ca0..6e484d836cfe 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -1204,6 +1204,7 @@ static int nwl_dsi_probe(struct platform_device *pdev)
 
 	ret = nwl_dsi_select_input(dsi);
 	if (ret < 0) {
+		pm_runtime_disable(dev);
 		mipi_dsi_host_unregister(&dsi->dsi_host);
 		return ret;
 	}
-- 
2.34.1



