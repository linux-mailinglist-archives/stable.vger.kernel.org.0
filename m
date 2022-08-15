Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B6659477B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343683AbiHOX3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344063AbiHOX0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:26:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6108E80499;
        Mon, 15 Aug 2022 13:06:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F088B60025;
        Mon, 15 Aug 2022 20:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F203CC433C1;
        Mon, 15 Aug 2022 20:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593996;
        bh=9/FwdszUVmHSP32BE8L/M81PIdZNgATYQgM69wIrkN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7w0nk1mfFhmAbdz5BKelKOU7I9jPFanJcwMy0sePnWerR9Z8RY6bVD7KQx7Zh4xG
         kYtJMDb6cgt/ArCEmL4QpieJr7upYLq3EWTL9nVyESTsdca0rQV7Ru0CLYr0sE4FJ7
         Ccmw4EWe1cu5IxvmL2Pq65z33+JP/KNXn0Xsyb5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0359/1157] drm/bridge: anx7625: Zero error variable when panel bridge not present
Date:   Mon, 15 Aug 2022 19:55:15 +0200
Message-Id: <20220815180454.076004289@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 3f49f7591e7150c502aa8d04354941ec2394153f ]

While parsing the DT, the anx7625 driver checks for the presence of a
panel bridge on endpoint 1. If it is missing, pdata->panel_bridge stores
the error pointer and the function returns successfully without first
cleaning that variable. This is an issue since other functions later
check for the presence of a panel bridge by testing the trueness of that
variable.

In order to ensure proper behavior, zero out pdata->panel_bridge before
returning when no panel bridge is found.

Fixes: 9e82ea0fb1df ("drm/bridge: anx7625: switch to devm_drm_of_get_bridge")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220613163705.1531721-1-nfraprado@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 01f46d9189c1..0117fd8c62ae 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1657,8 +1657,10 @@ static int anx7625_parse_dt(struct device *dev,
 
 	pdata->panel_bridge = devm_drm_of_get_bridge(dev, np, 1, 0);
 	if (IS_ERR(pdata->panel_bridge)) {
-		if (PTR_ERR(pdata->panel_bridge) == -ENODEV)
+		if (PTR_ERR(pdata->panel_bridge) == -ENODEV) {
+			pdata->panel_bridge = NULL;
 			return 0;
+		}
 
 		return PTR_ERR(pdata->panel_bridge);
 	}
-- 
2.35.1



