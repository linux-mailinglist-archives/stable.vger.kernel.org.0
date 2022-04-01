Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479124EF057
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347427AbiDAOfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347554AbiDAOdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB18231ACC;
        Fri,  1 Apr 2022 07:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9452EB82500;
        Fri,  1 Apr 2022 14:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9540EC2BBE4;
        Fri,  1 Apr 2022 14:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823379;
        bh=eTiovVUCen7xNYJkwiLrMjheRNdT5H42VgeNdAbVmjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iY0HzFuPYi+s0imDltpHRMocEkETTYKm61R7TfU9XFe15ev2tKsadFIjBfhl02lFb
         23Zuo9dtQXdKg2SKm4hEkFbkAkGGY9G0VYyf47ZzNoUnSElMYsUk9RE5Q7HERRH4ZW
         YTxKYiAJMgDnmwbkGH5JxnSajZcke2nAzp/n4lnJ3CUijcxBISuDYSUFKn3LAuhmml
         /J4LHvSbXLRPQZuUHesQDza/22Wo6Zqtl4a0ARA8Zxb0VtfVa9EKWUWIdzRsiUIazw
         vToQivUPl2eEwt3uE159IXhUMAd/kZ3K8dpM5JaEt/A/xJspaRvmH9T4MfgQ+dEUg+
         /yiJY+DNBxAFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Tang <kevin3.tang@gmail.com>, Zou Wei <zou_wei@huawei.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, orsonzhai@gmail.com, baolin.wang7@gmail.com,
        zhang.lyra@gmail.com, maarten.lankhorst@linux.intel.com,
        maxime@cerno.tech, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 072/149] drm/sprd: check the platform_get_resource() return value
Date:   Fri,  1 Apr 2022 10:24:19 -0400
Message-Id: <20220401142536.1948161-72-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Kevin Tang <kevin3.tang@gmail.com>

[ Upstream commit 73792e6e66be1225837cc1a40f1e39b1d077751c ]

platform_get_resource() may fail and return NULL, so check it's value
before using it.

Reported-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Kevin Tang <kevin3.tang@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/all/20220117084156.9338-1-kevin3.tang@gmail.com

v1 -> v2:
- new patch

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sprd/sprd_dpu.c | 5 +++++
 drivers/gpu/drm/sprd/sprd_dsi.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/sprd/sprd_dpu.c b/drivers/gpu/drm/sprd/sprd_dpu.c
index 06a3414ee43a..1637203ea103 100644
--- a/drivers/gpu/drm/sprd/sprd_dpu.c
+++ b/drivers/gpu/drm/sprd/sprd_dpu.c
@@ -790,6 +790,11 @@ static int sprd_dpu_context_init(struct sprd_dpu *dpu,
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "failed to get I/O resource\n");
+		return -EINVAL;
+	}
+
 	ctx->base = devm_ioremap(dev, res->start, resource_size(res));
 	if (!ctx->base) {
 		dev_err(dev, "failed to map dpu registers\n");
diff --git a/drivers/gpu/drm/sprd/sprd_dsi.c b/drivers/gpu/drm/sprd/sprd_dsi.c
index 911b3cddc264..12b67a5d5923 100644
--- a/drivers/gpu/drm/sprd/sprd_dsi.c
+++ b/drivers/gpu/drm/sprd/sprd_dsi.c
@@ -907,6 +907,11 @@ static int sprd_dsi_context_init(struct sprd_dsi *dsi,
 	struct resource *res;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "failed to get I/O resource\n");
+		return -EINVAL;
+	}
+
 	ctx->base = devm_ioremap(dev, res->start, resource_size(res));
 	if (!ctx->base) {
 		drm_err(dsi->drm, "failed to map dsi host registers\n");
-- 
2.34.1

