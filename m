Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E9D50580A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbiDRN70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244647AbiDRN5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:57:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6902AC71;
        Mon, 18 Apr 2022 06:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBD27B80EDB;
        Mon, 18 Apr 2022 13:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE90C385A1;
        Mon, 18 Apr 2022 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287205;
        bh=18ooWGe6T/Oe8WQdSBw7OV3RQzYgi+roP2OWtW8HRzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ni43NV2ja43f7TOL5UgfrF+fVrvP4ibOj5DGsgQKkYJgxg+WpxnP9PB1fVlFJdBY3
         bdmEC7ddcbT8AxYUnUmmS42O6mcvr5xj6fbe1SB7IF+jZ55d9yaiVl8dbDEXnDpVq+
         N+lhPcuwD5KKt274QEiXyEKXQWliOERtIbbkjFLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 090/218] drm/tegra: Fix reference leak in tegra_dsi_ganged_probe
Date:   Mon, 18 Apr 2022 14:12:36 +0200
Message-Id: <20220418121202.182611664@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3dea1216bafd..dfd9e0b9582d 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -1475,8 +1475,10 @@ static int tegra_dsi_ganged_probe(struct tegra_dsi *dsi)
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



