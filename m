Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B30250F7CE
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiDZJHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347782AbiDZJGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390A419290;
        Tue, 26 Apr 2022 01:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF29060A56;
        Tue, 26 Apr 2022 08:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD409C385A0;
        Tue, 26 Apr 2022 08:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962745;
        bh=6JIV9bAl3AlhOIFiWtU+aC2MWdNmcLlPqJm+dbFnVFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtjE06vTMbP5TGqXnBNEbuz4n7TDPWe3zYZYc2B+Fr7ITDFHJx7yMYi+mndlYaHrx
         6n1y2PAF1jX+k3DX3MD13Bbzd/MDhpe/u3McXjXQu1QqO0XpQlD1kwFjX8wt5ZR45l
         Qqj3V0EMpBAtiUJyc3A+7X8XBQqlPQjG7wtmMbrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 058/146] drm/msm/gpu: Rename runtime suspend/resume functions
Date:   Tue, 26 Apr 2022 10:20:53 +0200
Message-Id: <20220426081751.698990532@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit f7eab1ddb9f8bc99206e3efa8d34ca1d2faca209 ]

Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20220310234611.424743-2-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index fb261930ad1c..b93de79000e1 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -601,7 +601,7 @@ static const struct of_device_id dt_match[] = {
 };
 
 #ifdef CONFIG_PM
-static int adreno_resume(struct device *dev)
+static int adreno_runtime_resume(struct device *dev)
 {
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 
@@ -617,7 +617,7 @@ static int active_submits(struct msm_gpu *gpu)
 	return active_submits;
 }
 
-static int adreno_suspend(struct device *dev)
+static int adreno_runtime_suspend(struct device *dev)
 {
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 	int remaining;
@@ -636,7 +636,7 @@ static int adreno_suspend(struct device *dev)
 
 static const struct dev_pm_ops adreno_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
-	SET_RUNTIME_PM_OPS(adreno_suspend, adreno_resume, NULL)
+	SET_RUNTIME_PM_OPS(adreno_runtime_suspend, adreno_runtime_resume, NULL)
 };
 
 static struct platform_driver adreno_driver = {
-- 
2.35.1



