Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D45C2A5192
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgKCUmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:42:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730070AbgKCUmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCF7A22226;
        Tue,  3 Nov 2020 20:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436126;
        bh=2hxtJN4KJtOpCZe8cRWiw35/42nJX22zmRG7GingO4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFP7Sv4VLX3pnRT5kGYzWEbmMBRZ7GF1IkM/tDgtSbppTkKhAcemNXAgZz1ciDgBG
         HSUDJPYvMcATOlWaVJhEAIwxF1uqu9tnbpfIFT/NpAj1BsFAa05M2a6dpu2FP7CQj2
         nTQhf1wgwHVfQA2QndacQiuMRDvvbbwbJWGscevc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linu Cherian <lcherian@marvell.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 115/391] coresight: Make sysfs functional on topologies with per core sink
Date:   Tue,  3 Nov 2020 21:32:46 +0100
Message-Id: <20201103203354.582118318@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linu Cherian <lcherian@marvell.com>

[ Upstream commit 6d578258b955fc8888e1bbd9a8fefe7b10065a84 ]

Coresight driver assumes sink is common across all the ETMs,
and tries to build a path between ETM and the first enabled
sink found using bus based search. This breaks sysFS usage
on implementations that has multiple per core sinks in
enabled state.

To fix this, coresight_get_enabled_sink API is updated to
do a connection based search starting from the given source,
instead of bus based search.
With sink selection using sysfs depecrated for perf interface,
provision for reset is removed as well in this API.

Signed-off-by: Linu Cherian <lcherian@marvell.com>
[Fixed indentation problem and removed obsolete comment]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-15-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-priv.h |  3 +-
 drivers/hwtracing/coresight/coresight.c      | 62 +++++++++-----------
 2 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
index f2dc625ea5856..5fe773c4d6cc5 100644
--- a/drivers/hwtracing/coresight/coresight-priv.h
+++ b/drivers/hwtracing/coresight/coresight-priv.h
@@ -148,7 +148,8 @@ static inline void coresight_write_reg_pair(void __iomem *addr, u64 val,
 void coresight_disable_path(struct list_head *path);
 int coresight_enable_path(struct list_head *path, u32 mode, void *sink_data);
 struct coresight_device *coresight_get_sink(struct list_head *path);
-struct coresight_device *coresight_get_enabled_sink(bool reset);
+struct coresight_device *
+coresight_get_enabled_sink(struct coresight_device *source);
 struct coresight_device *coresight_get_sink_by_id(u32 id);
 struct coresight_device *
 coresight_find_default_sink(struct coresight_device *csdev);
diff --git a/drivers/hwtracing/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
index cdcb1917216fd..fd46216669449 100644
--- a/drivers/hwtracing/coresight/coresight.c
+++ b/drivers/hwtracing/coresight/coresight.c
@@ -540,50 +540,46 @@ struct coresight_device *coresight_get_sink(struct list_head *path)
 	return csdev;
 }
 
-static int coresight_enabled_sink(struct device *dev, const void *data)
+static struct coresight_device *
+coresight_find_enabled_sink(struct coresight_device *csdev)
 {
-	const bool *reset = data;
-	struct coresight_device *csdev = to_coresight_device(dev);
+	int i;
+	struct coresight_device *sink;
 
 	if ((csdev->type == CORESIGHT_DEV_TYPE_SINK ||
 	     csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) &&
-	     csdev->activated) {
-		/*
-		 * Now that we have a handle on the sink for this session,
-		 * disable the sysFS "enable_sink" flag so that possible
-		 * concurrent perf session that wish to use another sink don't
-		 * trip on it.  Doing so has no ramification for the current
-		 * session.
-		 */
-		if (*reset)
-			csdev->activated = false;
+	     csdev->activated)
+		return csdev;
 
-		return 1;
+	/*
+	 * Recursively explore each port found on this element.
+	 */
+	for (i = 0; i < csdev->pdata->nr_outport; i++) {
+		struct coresight_device *child_dev;
+
+		child_dev = csdev->pdata->conns[i].child_dev;
+		if (child_dev)
+			sink = coresight_find_enabled_sink(child_dev);
+		if (sink)
+			return sink;
 	}
 
-	return 0;
+	return NULL;
 }
 
 /**
- * coresight_get_enabled_sink - returns the first enabled sink found on the bus
- * @deactivate:	Whether the 'enable_sink' flag should be reset
- *
- * When operated from perf the deactivate parameter should be set to 'true'.
- * That way the "enabled_sink" flag of the sink that was selected can be reset,
- * allowing for other concurrent perf sessions to choose a different sink.
+ * coresight_get_enabled_sink - returns the first enabled sink using
+ * connection based search starting from the source reference
  *
- * When operated from sysFS users have full control and as such the deactivate
- * parameter should be set to 'false', hence mandating users to explicitly
- * clear the flag.
+ * @source: Coresight source device reference
  */
-struct coresight_device *coresight_get_enabled_sink(bool deactivate)
+struct coresight_device *
+coresight_get_enabled_sink(struct coresight_device *source)
 {
-	struct device *dev = NULL;
-
-	dev = bus_find_device(&coresight_bustype, NULL, &deactivate,
-			      coresight_enabled_sink);
+	if (!source)
+		return NULL;
 
-	return dev ? to_coresight_device(dev) : NULL;
+	return coresight_find_enabled_sink(source);
 }
 
 static int coresight_sink_by_id(struct device *dev, const void *data)
@@ -988,11 +984,7 @@ int coresight_enable(struct coresight_device *csdev)
 		goto out;
 	}
 
-	/*
-	 * Search for a valid sink for this session but don't reset the
-	 * "enable_sink" flag in sysFS.  Users get to do that explicitly.
-	 */
-	sink = coresight_get_enabled_sink(false);
+	sink = coresight_get_enabled_sink(csdev);
 	if (!sink) {
 		ret = -EINVAL;
 		goto out;
-- 
2.27.0



