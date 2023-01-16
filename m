Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5940966C72D
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbjAPQ26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbjAPQ2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:28:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7555C2D166
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:16:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F4161041
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E187EC433EF;
        Mon, 16 Jan 2023 16:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885795;
        bh=2N/zyrmvZxVXf9UnfBaY5VptyHvddOnsQozxmqhL+Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFSKRS36Tbdkaf+orxweBmSVFJLvrNVnMgwUCATeI9kXL/n/67ATNSPzvn3g+pd1h
         /tP5xjRoRL0cONGBgyFYw4cexlJVXb75E9+QvofiJAZ0wbu+X4O9OPiK2swcfXgnMx
         Ex5rjAcAy1mLxADHl2k9V24iYuQuRJ2PyXBSFd/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Zekun <zhangzekun11@huawei.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 157/658] drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()
Date:   Mon, 16 Jan 2023 16:44:05 +0100
Message-Id: <20230116154916.636639693@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit 7ad4384d53c67672a8720cdc2ef638d7d1710ab8 ]

Add the missing clk_disable_unprepare() before return from
tegra_dc_probe() in the error handling path.

Fixes: f68ba6912bd2 ("drm/tegra: dc: Link DC1 to DC0 on Tegra20")
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index c410221824c1..923899b95c88 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -2458,8 +2458,10 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	usleep_range(2000, 4000);
 
 	err = reset_control_assert(dc->rst);
-	if (err < 0)
+	if (err < 0) {
+		clk_disable_unprepare(dc->clk);
 		return err;
+	}
 
 	usleep_range(2000, 4000);
 
-- 
2.35.1



