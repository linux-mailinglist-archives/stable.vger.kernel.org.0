Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324CB5C025C
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiIUPwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiIUPvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AF29C22F;
        Wed, 21 Sep 2022 08:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 882A763138;
        Wed, 21 Sep 2022 15:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8E5C433D6;
        Wed, 21 Sep 2022 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775305;
        bh=n2AGx12MOguBMY7w6QPaLdfxFfoD2o0St4ptyVUydN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWfqoadawnF0yOvm5oOpnS2SIX5X2eljP/7dI8wezQkcmCvlD7hTCTWoY/dSEGov8
         fyYDmjplIXztWCYl7Uo4nrefGjkvYqGrLR7XOOtuDuiL8Eaub+K8BlkNed77q5Ymm/
         1FVmKrJnc1d9/wpS72nxj7OZm5OqpG9wv6Dw2zK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/45] drm/tegra: vic: Fix build warning when CONFIG_PM=n
Date:   Wed, 21 Sep 2022 17:45:51 +0200
Message-Id: <20220921153646.976415033@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit b5d5288a46876f6767950449aea310f71ac86277 ]

drivers/gpu/drm/tegra/vic.c:326:12: error: ‘vic_runtime_suspend’ defined but not used [-Werror=unused-function]
 static int vic_runtime_suspend(struct device *dev)
            ^~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/tegra/vic.c:292:12: error: ‘vic_runtime_resume’ defined but not used [-Werror=unused-function]
 static int vic_runtime_resume(struct device *dev)
            ^~~~~~~~~~~~~~~~~~

Mark it as __maybe_unused.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Stable-dep-of: c7860cbee998 ("drm/tegra: Fix vmapping of prime buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/vic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tegra/vic.c b/drivers/gpu/drm/tegra/vic.c
index da4af5371991..d3e2fab91086 100644
--- a/drivers/gpu/drm/tegra/vic.c
+++ b/drivers/gpu/drm/tegra/vic.c
@@ -275,7 +275,7 @@ static int vic_load_firmware(struct vic *vic)
 }
 
 
-static int vic_runtime_resume(struct device *dev)
+static int __maybe_unused vic_runtime_resume(struct device *dev)
 {
 	struct vic *vic = dev_get_drvdata(dev);
 	int err;
@@ -309,7 +309,7 @@ static int vic_runtime_resume(struct device *dev)
 	return err;
 }
 
-static int vic_runtime_suspend(struct device *dev)
+static int __maybe_unused vic_runtime_suspend(struct device *dev)
 {
 	struct vic *vic = dev_get_drvdata(dev);
 	int err;
-- 
2.35.1



