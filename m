Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9068B4F30B0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242885AbiDEJiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241805AbiDEJHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:07:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083E64B1F7;
        Tue,  5 Apr 2022 01:56:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59E57B81C6C;
        Tue,  5 Apr 2022 08:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FC8C385A0;
        Tue,  5 Apr 2022 08:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148996;
        bh=Z9o8gaYS56UaYl5hI66rYbD2VLJumMbKcvklW95+7cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8FKc5wiGdDC9nbgLeFUJnhRKEEQbqD//dzybOv9W7/XGMgf+gWBi3HHlY4djtc5c
         Yd/6TZh0NCNX7zrBqfHwaTa8kaCBrcSEDab82qZUkbuVwzBO9c7wQdmWRhBI9kbX1o
         j0E1+wBrHbJjm0MjEjC71S+N2X20FkNBdaQCX1ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0549/1017] drm/tegra: Fix reference leak in tegra_dsi_ganged_probe
Date:   Tue,  5 Apr 2022 09:24:22 +0200
Message-Id: <20220405070410.581332758@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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



