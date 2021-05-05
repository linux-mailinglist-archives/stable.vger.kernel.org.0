Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8A537408A
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbhEEQfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234261AbhEEQdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:33:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1A456141A;
        Wed,  5 May 2021 16:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232350;
        bh=b3RxAnqZyvSpqfjl9rUegzuE+IJ21GBgWwQc2A7a/zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2R/TtMnNqLsxcUG0uj+BbS1eYu8wyhz5MZc9bji+96xoU/zQAL+kc+rTXt+68HR6
         F9sIAcBbkx5xdOVC5iUMZhwiFw+Z8rudmMhxrHnph7S9m0CoLtx6w86AZAtXe1H/Vr
         FMdDuyh3yzc0CCEXHnNsOR0Y387KRSS1aXWhq+aXta7sZB6h7V3hJGbdBeMu7BJuAx
         M+wPM6ffT5amPXn1+S94FrXrxC1jemts2kv+u46MunOUj8QEPqKZxR+3PVF8LRtbD9
         o2RsERycGen9dJSXYG9aB0fSGrCzKKSWLs0BNhzr5yfCrR++uPmXIQTDu6suQ5EnBf
         mZWQENnJ3JsPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 047/116] coresight: Do not scan for graph if none is present
Date:   Wed,  5 May 2021 12:30:15 -0400
Message-Id: <20210505163125.3460440-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 2b921b671a8d29c2adb255a86409aad1e3267309 ]

If a graph node is not found for a given node, of_get_next_endpoint()
will emit the following error message :

 OF: graph: no port node found in /<node_name>

If the given component doesn't have any explicit connections (e.g,
ETE) we could simply ignore the graph parsing. As for any legacy
component where this is mandatory, the device will not be usable
as before this patch. Updating the DT bindings to Yaml and enabling
the schema checks can detect such issues with the DT.

Cc: Mike Leach <mike.leach@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20210405164307.1720226-11-suzuki.poulose@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-platform.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-platform.c b/drivers/hwtracing/coresight/coresight-platform.c
index 3629b7885aca..c594f45319fc 100644
--- a/drivers/hwtracing/coresight/coresight-platform.c
+++ b/drivers/hwtracing/coresight/coresight-platform.c
@@ -90,6 +90,12 @@ static void of_coresight_get_ports_legacy(const struct device_node *node,
 	struct of_endpoint endpoint;
 	int in = 0, out = 0;
 
+	/*
+	 * Avoid warnings in of_graph_get_next_endpoint()
+	 * if the device doesn't have any graph connections
+	 */
+	if (!of_graph_is_present(node))
+		return;
 	do {
 		ep = of_graph_get_next_endpoint(node, ep);
 		if (!ep)
-- 
2.30.2

