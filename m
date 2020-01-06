Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F4F1310BA
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 11:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgAFKno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 05:43:44 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40319 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgAFKno (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 05:43:44 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so49066571wrn.7;
        Mon, 06 Jan 2020 02:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bt4iLSsaVU4TRitOeaJ5RT9zwbVmXACqxBToaITFncc=;
        b=fPDyAAhQEuL6y9QUdvXHkdRPpFudVO7CV8w0HtxlhKhTxksP69AOSM+TtlwVfOyfrs
         VN/OXPwmTnTcXQCl2ffNArHe8W1eSkm7O0saAAXRLi9cVnzQ0faEzLwUpqcFU5WdFxkl
         g+7gpzFa0KL3yt8rusv12pPGcfQY9tdkISOYKNGUct73AiIHgcQOK2XXtAJk0V3B/jh0
         8/ftL55sfEx56wf80qgy9hLzCeCDTNbqxeR5pBwPa7pwsFgg0D2K6jvxoZ9iDYhHR+Zk
         NNGaIBy1YEpMgWTObGlU9p/G+ZrFASZAFTlxeIA5CfRTkFCEHsIy7XVcwpQYh0Luprrq
         F3Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bt4iLSsaVU4TRitOeaJ5RT9zwbVmXACqxBToaITFncc=;
        b=iFmAabbTwTe5MJQ6IVtBHYGuqpBmnrR7Ske0CUqt0EERqBMhDm5uTPuSHpEeKRFdNd
         Wz1xqhioFVcFGlIfBV0lfF+9batmSoHnqf1RmSVW5XeliLKk1m6Nl3T8Q5CfB+eRpr0Q
         Ut5p8XCVCfawmepu6gNjITpiMN22Lmb49pkKmFKZkxGDAdUDDDXANj/BLz6jlFsaN2JQ
         nLg+L7UO18mQetTl/eWFhcoUFzPm/FFxNYALyIdFjeMVfAKKi0iNZNy388lGUPPy/rh/
         Yt+xo54Fn+qBOfWASuOEak4V7z9tEuddnPPJOWrFqOCDR7Gw83h4IrRvo0BVUMoQ3X+G
         8VOg==
X-Gm-Message-State: APjAAAXp8V0bVdn9Nib+6PaRisRTVKbdQIh5y0bwSIMOXrtPUqEfMP19
        k2D28W9XpdGubcKxTg7hYWr4rC7Ev5X4dg==
X-Google-Smtp-Source: APXvYqz2ar7hWu8+Or3z6UDvr30I/9eI76qO8YYBwNQwKNh8wiZhQu+kOGqke2xanfu3YYR/vsUK8A==
X-Received: by 2002:a5d:5381:: with SMTP id d1mr43080644wrv.259.1578307422666;
        Mon, 06 Jan 2020 02:43:42 -0800 (PST)
Received: from localhost.localdomain ([62.178.82.229])
        by smtp.gmail.com with ESMTPSA id r62sm23513239wma.32.2020.01.06.02.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 02:43:41 -0800 (PST)
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Gmeiner <christian.gmeiner@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/etnaviv: rework perfmon query infrastructure
Date:   Mon,  6 Jan 2020 11:43:36 +0100
Message-Id: <20200106104339.215511-1-christian.gmeiner@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Report the correct perfmon domains and signals depending
on the supported feature flags.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 9e2c2e273012 ("drm/etnaviv: add infrastructure to query perf counter")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 57 ++++++++++++++++++++---
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
index 8adbf2861bff..7ae8f347ca06 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
@@ -32,6 +32,7 @@ struct etnaviv_pm_domain {
 };
 
 struct etnaviv_pm_domain_meta {
+	unsigned int feature;
 	const struct etnaviv_pm_domain *domains;
 	u32 nr_domains;
 };
@@ -410,36 +411,78 @@ static const struct etnaviv_pm_domain doms_vg[] = {
 
 static const struct etnaviv_pm_domain_meta doms_meta[] = {
 	{
+		.feature = chipFeatures_PIPE_3D,
 		.nr_domains = ARRAY_SIZE(doms_3d),
 		.domains = &doms_3d[0]
 	},
 	{
+		.feature = chipFeatures_PIPE_2D,
 		.nr_domains = ARRAY_SIZE(doms_2d),
 		.domains = &doms_2d[0]
 	},
 	{
+		.feature = chipFeatures_PIPE_VG,
 		.nr_domains = ARRAY_SIZE(doms_vg),
 		.domains = &doms_vg[0]
 	}
 };
 
+static unsigned int num_pm_domains(const struct etnaviv_gpu *gpu)
+{
+	unsigned int num = 0, i;
+
+	for (i = 0; i < ARRAY_SIZE(doms_meta); i++) {
+		const struct etnaviv_pm_domain_meta *meta = &doms_meta[i];
+
+		if (gpu->identity.features & meta->feature)
+			num += meta->nr_domains;
+	}
+
+	return num;
+}
+
+static const struct etnaviv_pm_domain *pm_domain(const struct etnaviv_gpu *gpu,
+	unsigned int index)
+{
+	const struct etnaviv_pm_domain *domain = NULL;
+	unsigned int offset = 0, i;
+
+	for (i = 0; i < ARRAY_SIZE(doms_meta); i++) {
+		const struct etnaviv_pm_domain_meta *meta = &doms_meta[i];
+
+		if (!(gpu->identity.features & meta->feature))
+			continue;
+
+		if (meta->nr_domains < (index - offset)) {
+			offset += meta->nr_domains;
+			continue;
+		}
+
+		domain = meta->domains + (index - offset);
+	}
+
+	BUG_ON(!domain);
+
+	return domain;
+}
+
 int etnaviv_pm_query_dom(struct etnaviv_gpu *gpu,
 	struct drm_etnaviv_pm_domain *domain)
 {
-	const struct etnaviv_pm_domain_meta *meta = &doms_meta[domain->pipe];
+	const unsigned int nr_domains = num_pm_domains(gpu);
 	const struct etnaviv_pm_domain *dom;
 
-	if (domain->iter >= meta->nr_domains)
+	if (domain->iter >= nr_domains)
 		return -EINVAL;
 
-	dom = meta->domains + domain->iter;
+	dom = pm_domain(gpu, domain->iter);
 
 	domain->id = domain->iter;
 	domain->nr_signals = dom->nr_signals;
 	strncpy(domain->name, dom->name, sizeof(domain->name));
 
 	domain->iter++;
-	if (domain->iter == meta->nr_domains)
+	if (domain->iter == nr_domains)
 		domain->iter = 0xff;
 
 	return 0;
@@ -448,14 +491,14 @@ int etnaviv_pm_query_dom(struct etnaviv_gpu *gpu,
 int etnaviv_pm_query_sig(struct etnaviv_gpu *gpu,
 	struct drm_etnaviv_pm_signal *signal)
 {
-	const struct etnaviv_pm_domain_meta *meta = &doms_meta[signal->pipe];
+	const unsigned int nr_domains = num_pm_domains(gpu);
 	const struct etnaviv_pm_domain *dom;
 	const struct etnaviv_pm_signal *sig;
 
-	if (signal->domain >= meta->nr_domains)
+	if (signal->domain >= nr_domains)
 		return -EINVAL;
 
-	dom = meta->domains + signal->domain;
+	dom = pm_domain(gpu, signal->domain);
 
 	if (signal->iter >= dom->nr_signals)
 		return -EINVAL;
-- 
2.24.1

