Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74AA147FCE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388377AbgAXLFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388792AbgAXLFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:05:13 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 970462077C;
        Fri, 24 Jan 2020 11:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863913;
        bh=XS1QrIPd8iC+Cc+Yrtcf+MuZnPatPJ59JT+E2c+/f5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTxYxf7k0DTn9Q07Mu5xzaHaz8I1eDSwsNamMgdEvu886Iqxj+gwebPSq7rjWouiK
         beTZz9VshYXnV2z4dO/PYGskafGU5Ggif96N01PWrDG9Q0W/XMRqDgKACedaPy0wth
         rGzNbAQ4dRtOUK8iNeKhc+ha1EmreLi16Y1zg1jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/639] drm/etnaviv: fix some off by one bugs
Date:   Fri, 24 Jan 2020 10:24:51 +0100
Message-Id: <20200124093102.450934544@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f5fd9fd4000984f19db689282054953981a50534 ]

The ->nr_signal is the supposed to be the number of elements in the
->signal array.  There was one place where it was 5 but it was supposed
to be 4.  That looks like a copy and paste bug.  There were also two
checks that were off by one.

Fixes: 9e2c2e273012 ("drm/etnaviv: add infrastructure to query perf counter")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Tested-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
index 9980d81a26e3c..4227a4006c349 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
@@ -113,7 +113,7 @@ static const struct etnaviv_pm_domain doms_3d[] = {
 		.name = "PE",
 		.profile_read = VIVS_MC_PROFILE_PE_READ,
 		.profile_config = VIVS_MC_PROFILE_CONFIG0,
-		.nr_signals = 5,
+		.nr_signals = 4,
 		.signal = (const struct etnaviv_pm_signal[]) {
 			{
 				"PIXEL_COUNT_KILLED_BY_COLOR_PIPE",
@@ -435,7 +435,7 @@ int etnaviv_pm_query_sig(struct etnaviv_gpu *gpu,
 
 	dom = meta->domains + signal->domain;
 
-	if (signal->iter > dom->nr_signals)
+	if (signal->iter >= dom->nr_signals)
 		return -EINVAL;
 
 	sig = &dom->signal[signal->iter];
@@ -461,7 +461,7 @@ int etnaviv_pm_req_validate(const struct drm_etnaviv_gem_submit_pmr *r,
 
 	dom = meta->domains + r->domain;
 
-	if (r->signal > dom->nr_signals)
+	if (r->signal >= dom->nr_signals)
 		return -EINVAL;
 
 	return 0;
-- 
2.20.1



