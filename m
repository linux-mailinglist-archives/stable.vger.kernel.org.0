Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006B949A4E8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387646AbiAYAFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839675AbiAXX2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A57C075948;
        Mon, 24 Jan 2022 13:33:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E44961305;
        Mon, 24 Jan 2022 21:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51596C340E4;
        Mon, 24 Jan 2022 21:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060035;
        bh=2E50KrbVkwR/nqccvG/b6nh+kvOETHtkUWtyTvxMPhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daUYLoYmfrc/Hl+Erm14FufKXPamXWwdPgCQTKa2jFgPR45gGc9nvWEgoeG1+hDAM
         1QIJecWBdPtK9Ysu8530v8rxGWg8DO++UVyKAaZNlBuo7cjQRbkU61yph3Q8wCyDj4
         L77SZlvLocbADiaJu2a27mnry5DOoCBiyXWHgZRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0817/1039] drm/sun4i: dw-hdmi: Fix missing put_device() call in sun8i_hdmi_phy_get
Date:   Mon, 24 Jan 2022 19:43:26 +0100
Message-Id: <20220124184152.769352289@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c71af3dae3e34d2fde0c19623cf7f8483321f0e3 ]

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the error handling path.

Fixes: 9bf3797796f5 ("drm/sun4i: dw-hdmi: Make HDMI PHY into a platform device")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220107083633.20843-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
index b64d93da651d2..5e2b0175df36f 100644
--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -658,8 +658,10 @@ int sun8i_hdmi_phy_get(struct sun8i_dw_hdmi *hdmi, struct device_node *node)
 		return -EPROBE_DEFER;
 
 	phy = platform_get_drvdata(pdev);
-	if (!phy)
+	if (!phy) {
+		put_device(&pdev->dev);
 		return -EPROBE_DEFER;
+	}
 
 	hdmi->phy = phy;
 
-- 
2.34.1



