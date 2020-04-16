Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D1B1ACC12
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442607AbgDPPyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896175AbgDPNaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:30:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1E26206E9;
        Thu, 16 Apr 2020 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043810;
        bh=n4gMo6AOjihmI1Q+oarcYaDlhVYqFweCvZItTBIEFX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRMxyDQt7EcknNYEWyeOYSssyZ8daWQKBMjHvzftBcuv10qBXkfSiosPN/SfMPfSG
         bU6fVNi/pa7YR0c6uKhpsoGuKIQZ3in9babEk4lRQ/p8ekGmrQosiBjFTickagO4lA
         D5UDe4/5fAbuSLO1gJ1oR7fLMqR5kpUC4UYSmTK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 4.19 108/146] drm/etnaviv: rework perfmon query infrastructure
Date:   Thu, 16 Apr 2020 15:24:09 +0200
Message-Id: <20200416131257.469946725@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Gmeiner <christian.gmeiner@gmail.com>

commit ed1dd899baa32d47d9a93d98336472da50564346 upstream.

Report the correct perfmon domains and signals depending
on the supported feature flags.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 9e2c2e273012 ("drm/etnaviv: add infrastructure to query perf counter")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c |   60 ++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2017 Zodiac Inflight Innovations
  */
 
+#include "common.xml.h"
 #include "etnaviv_gpu.h"
 #include "etnaviv_perfmon.h"
 #include "state_hi.xml.h"
@@ -31,6 +32,7 @@ struct etnaviv_pm_domain {
 };
 
 struct etnaviv_pm_domain_meta {
+	unsigned int feature;
 	const struct etnaviv_pm_domain *domains;
 	u32 nr_domains;
 };
@@ -388,36 +390,78 @@ static const struct etnaviv_pm_domain do
 
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
+	if (!dom)
+		return -EINVAL;
 
 	domain->id = domain->iter;
 	domain->nr_signals = dom->nr_signals;
 	strncpy(domain->name, dom->name, sizeof(domain->name));
 
 	domain->iter++;
-	if (domain->iter == meta->nr_domains)
+	if (domain->iter == nr_domains)
 		domain->iter = 0xff;
 
 	return 0;
@@ -426,14 +470,16 @@ int etnaviv_pm_query_dom(struct etnaviv_
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
+	if (!dom)
+		return -EINVAL;
 
 	if (signal->iter >= dom->nr_signals)
 		return -EINVAL;


