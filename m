Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4177A29BF54
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793669AbgJ0PHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789327AbgJ0PBz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:01:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C670022264;
        Tue, 27 Oct 2020 15:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810914;
        bh=kDkWw07+ycoeL9g5Rbqp86xLJvlkFUxmFz1Zdoqi1e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hf4KMFy6SV6gZd4EjaOypPWL12ZdzroUczVL0OAdXVPITlH1hx0mfuBOb3a/S/cZK
         iRTbh/8j+sObG5QG8YxOlBW7ciEpV36R1eNoOGY+1VaNs4s4qy46sMRVATNBdSfCjQ
         t+qfBu5fOo6sXgXvOncdPGvJBRPi/Y0MpKRs2QJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Tingwei Zhang <tingwei@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 280/633] coresight: etm: perf: Fix warning caused by etm_setup_aux failure
Date:   Tue, 27 Oct 2020 14:50:23 +0100
Message-Id: <20201027135535.807205476@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tingwei Zhang <tingwei@codeaurora.org>

[ Upstream commit 716f5652a13122364a65e694386b9b26f5e98c51 ]

When coresight_build_path() fails on all the cpus, etm_setup_aux
calls etm_free_aux() to free allocated event_data.
WARN_ON(cpumask_empty(mask) will be triggered since cpu mask is empty.
Check event_data->snk_config is not NULL first to avoid this
warning.

Fixes: f5200aa9831f38 ("coresight: perf: Refactor function free_event_data()")
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Tingwei Zhang <tingwei@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200928163513.70169-9-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index c4b9898e28418..9b0c5d719232f 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -126,10 +126,10 @@ static void free_sink_buffer(struct etm_event_data *event_data)
 	cpumask_t *mask = &event_data->mask;
 	struct coresight_device *sink;
 
-	if (WARN_ON(cpumask_empty(mask)))
+	if (!event_data->snk_config)
 		return;
 
-	if (!event_data->snk_config)
+	if (WARN_ON(cpumask_empty(mask)))
 		return;
 
 	cpu = cpumask_first(mask);
-- 
2.25.1



