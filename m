Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6CB657E6B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiL1Pxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbiL1PxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:53:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26E317886
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:53:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E478613E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEB6C433D2;
        Wed, 28 Dec 2022 15:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242803;
        bh=5rD/59HdX+h5epWfFs5rUJMb551FjsCn9IP3WYyqZVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHeueEX5jeUcfeAYYk4ky6V/3YsYQA/wqNKqzSak9gbMzIBdM7HGeKFmn4Kd5pSCE
         /Gb4s+aHUmy7BI6y8qZjPCqt3bMg2v6y7P2JbTuPVwo66P5rMLniWfPR17vWTxhnIY
         lfQwDzEBXytUiEm6liDKvHWOJ2piMlEriwUi9Qfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Zekun <zhangzekun11@huawei.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0418/1146] drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()
Date:   Wed, 28 Dec 2022 15:32:37 +0100
Message-Id: <20221228144341.525143705@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index bd0f60704467..a67453cee883 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -3205,8 +3205,10 @@ static int tegra_dc_probe(struct platform_device *pdev)
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



