Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5264F29DD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiDEIlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237529AbiDEISG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DC469CF7;
        Tue,  5 Apr 2022 01:06:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71DD2617EF;
        Tue,  5 Apr 2022 08:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E822C385A0;
        Tue,  5 Apr 2022 08:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145997;
        bh=Z9o8gaYS56UaYl5hI66rYbD2VLJumMbKcvklW95+7cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3CDYEVYJzgBUmz5UWn5feNaQquol1o0QFKgbhGFYxXiwLP/vlT8SwtQvblvOUZg4
         Qwyz8dRdSb+8o+SiIIvIuUM2KR5QNxvDy7BV1RkXp4+OCsb/dedWsmL2uCyDDtcVIY
         CoSpcr8Jsg9Ej4a6ldyA6ZRDonmlAxvgwuFuJWsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0606/1126] drm/tegra: Fix reference leak in tegra_dsi_ganged_probe
Date:   Tue,  5 Apr 2022 09:22:33 +0200
Message-Id: <20220405070425.421869964@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 221e3638feb8bc42143833c9a704fa89b6c366bb ]

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore. Add put_device() call to fix this.

Fixes: e94236cde4d5 ("drm/tegra: dsi: Add ganged mode support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index f46d377f0c30..de1333dc0d86 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -1538,8 +1538,10 @@ static int tegra_dsi_ganged_probe(struct tegra_dsi *dsi)
 		dsi->slave = platform_get_drvdata(gangster);
 		of_node_put(np);
 
-		if (!dsi->slave)
+		if (!dsi->slave) {
+			put_device(&gangster->dev);
 			return -EPROBE_DEFER;
+		}
 
 		dsi->slave->master = dsi;
 	}
-- 
2.34.1



