Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653373743F6
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbhEEQxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236772AbhEEQuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AEE861970;
        Wed,  5 May 2021 16:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232661;
        bh=b3RxAnqZyvSpqfjl9rUegzuE+IJ21GBgWwQc2A7a/zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABqIhU0VAHdrQKHE4h0e/s897W0OB7IeDRao9+ohjNMRsPMw/MOwQJ7mjtm2GL7B8
         Olf8K5SXah9r+oQmirt1AuKTTEhLOoaNVid635AKewtgonNtvAf8NEV1+pP1nQFajh
         qu1CuKvtZUmA4PYCAZbjLZNbr9TQ3GgMHSFsPv19cMo5ioQCi7khWY4Be6wvLq/T1U
         JAYGnLomSKwcrJS86nZ3X1hZc9v+EU9d1j2x/NmSPQqbqwACdOzzOC7dWMJ2mGUd3Q
         uXyarI2RGyuQYL3rYQnLxIPTQhj3rwOXnm2G/DxzoRr7g0NjNDY4CbRZaU5ZTd67Hn
         dK5hVZ47JUqrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 36/85] coresight: Do not scan for graph if none is present
Date:   Wed,  5 May 2021 12:35:59 -0400
Message-Id: <20210505163648.3462507-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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

