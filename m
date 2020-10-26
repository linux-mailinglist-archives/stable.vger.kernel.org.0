Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADD7299FD9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442331AbgJ0AZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410096AbgJZXx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2600A218AC;
        Mon, 26 Oct 2020 23:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756409;
        bh=SuBg16vC4eEUwkgk6AvsBQsIzGU8tgqwy4dD+svYyhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03cA09BFTg5YTIpkmANaq+OLN76BFCbyA7nv1KK9qsiO9V1+zJfDnwjWi+6yjq9Ga
         HUhXmsdr6ODYa5uzul6KRa9MLScV8uE2964KhVuNdOOr2zlDFw7p3A3KZBQqJZ+Lqx
         XhL0viSbPbM+H8VfkjMHcIQbfcgz8ptUhiRV6mYc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linu Cherian <lcherian@marvell.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 067/132] coresight: Make sysfs functional on topologies with per core sink
Date:   Mon, 26 Oct 2020 19:50:59 -0400
Message-Id: <20201026235205.1023962-67-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 36c943ae94d52..e383bc72143d8 100644
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
 struct list_head *coresight_build_path(struct coresight_device *csdev,
 				       struct coresight_device *sink);
diff --git a/drivers/hwtracing/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
index f3efbb3b2b4d1..f834255b013f3 100644
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
+ * coresight_get_enabled_sink - returns the first enabled sink using
+ * connection based search starting from the source reference
  *
- * When operated from perf the deactivate parameter should be set to 'true'.
- * That way the "enabled_sink" flag of the sink that was selected can be reset,
- * allowing for other concurrent perf sessions to choose a different sink.
- *
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
@@ -823,11 +819,7 @@ int coresight_enable(struct coresight_device *csdev)
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
2.25.1

