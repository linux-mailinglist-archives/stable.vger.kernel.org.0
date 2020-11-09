Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9192ABAF1
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732881AbgKINP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:15:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732913AbgKINP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3ECB208FE;
        Mon,  9 Nov 2020 13:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927726;
        bh=eWAXtWlHbL+UEXQDDC840B9t1tX3td866nAML6WaOj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjA0cYZcIgDhtYB6KeB2u2eFZlxcJROQsNi2yJtCEaBO2zccDnWxCtQVqRlNIF6bt
         1N60EeXBTXFmKLZMZcnnE13RWHql4tXI3t+utIVRG3PsXQ0O4PByuJ0CzBpQWLYEvW
         kQpbI18911t9AHNwlALWToyKrmXXtZHyzMuqxZhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 63/85] Revert "coresight: Make sysfs functional on topologies with per core sink"
Date:   Mon,  9 Nov 2020 13:56:00 +0100
Message-Id: <20201109125025.591630329@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 8fd52a21ab570e80f84f39e12affce42a5300e91.

Guenter Roeck <linux@roeck-us.net> writes:

I get the following build warning in v5.4.75.

drivers/hwtracing/coresight/coresight-etm-perf.c: In function 'etm_setup_aux':
drivers/hwtracing/coresight/coresight-etm-perf.c:226:37: warning:
                        passing argument 1 of 'coresight_get_enabled_sink' makes pointer from integer without a cast

Actually, the warning is fatal, since the call is
        sink = coresight_get_enabled_sink(true);
However, the argument to coresight_get_enabled_sink() is now a pointer.
The parameter change was introduced with commit 8fd52a21ab57
("coresight: Make sysfs functional on topologies with per core sink").

In the upstream kernel, the call is removed with commit bb1860efc817
("coresight: etm: perf: Sink selection using sysfs is deprecated").
That commit alone would, however, likely not solve the problem.
It looks like at least two more commits would be needed.

716f5652a131 coresight: etm: perf: Fix warning caused by etm_setup_aux failure
8e264c52e1da coresight: core: Allow the coresight core driver to be built as a module
39a7661dcf65 coresight: Fix uninitialised pointer bug in etm_setup_aux()

Looking into the coresight code, I see several additional commits affecting
the sysfs interface since v5.4. I have no idea what would actually be needed
for stable code in v5.4.y, short of applying them all.

With all this in mind, I would suggest to revert commit 8fd52a21ab57
("coresight: Make sysfs functional on topologies with per core sink")
from v5.4.y, especially since it is not marked as bug fix or for stable.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-priv.h |  3 +-
 drivers/hwtracing/coresight/coresight.c      | 62 +++++++++++---------
 2 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
index dfd24b85a5775..82e563cdc8794 100644
--- a/drivers/hwtracing/coresight/coresight-priv.h
+++ b/drivers/hwtracing/coresight/coresight-priv.h
@@ -147,8 +147,7 @@ static inline void coresight_write_reg_pair(void __iomem *addr, u64 val,
 void coresight_disable_path(struct list_head *path);
 int coresight_enable_path(struct list_head *path, u32 mode, void *sink_data);
 struct coresight_device *coresight_get_sink(struct list_head *path);
-struct coresight_device *
-coresight_get_enabled_sink(struct coresight_device *source);
+struct coresight_device *coresight_get_enabled_sink(bool reset);
 struct coresight_device *coresight_get_sink_by_id(u32 id);
 struct list_head *coresight_build_path(struct coresight_device *csdev,
 				       struct coresight_device *sink);
diff --git a/drivers/hwtracing/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
index 90ecd04a2f20b..0bbce0d291582 100644
--- a/drivers/hwtracing/coresight/coresight.c
+++ b/drivers/hwtracing/coresight/coresight.c
@@ -481,46 +481,50 @@ struct coresight_device *coresight_get_sink(struct list_head *path)
 	return csdev;
 }
 
-static struct coresight_device *
-coresight_find_enabled_sink(struct coresight_device *csdev)
+static int coresight_enabled_sink(struct device *dev, const void *data)
 {
-	int i;
-	struct coresight_device *sink;
+	const bool *reset = data;
+	struct coresight_device *csdev = to_coresight_device(dev);
 
 	if ((csdev->type == CORESIGHT_DEV_TYPE_SINK ||
 	     csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) &&
-	     csdev->activated)
-		return csdev;
-
-	/*
-	 * Recursively explore each port found on this element.
-	 */
-	for (i = 0; i < csdev->pdata->nr_outport; i++) {
-		struct coresight_device *child_dev;
+	     csdev->activated) {
+		/*
+		 * Now that we have a handle on the sink for this session,
+		 * disable the sysFS "enable_sink" flag so that possible
+		 * concurrent perf session that wish to use another sink don't
+		 * trip on it.  Doing so has no ramification for the current
+		 * session.
+		 */
+		if (*reset)
+			csdev->activated = false;
 
-		child_dev = csdev->pdata->conns[i].child_dev;
-		if (child_dev)
-			sink = coresight_find_enabled_sink(child_dev);
-		if (sink)
-			return sink;
+		return 1;
 	}
 
-	return NULL;
+	return 0;
 }
 
 /**
- * coresight_get_enabled_sink - returns the first enabled sink using
- * connection based search starting from the source reference
+ * coresight_get_enabled_sink - returns the first enabled sink found on the bus
+ * @deactivate:	Whether the 'enable_sink' flag should be reset
  *
- * @source: Coresight source device reference
+ * When operated from perf the deactivate parameter should be set to 'true'.
+ * That way the "enabled_sink" flag of the sink that was selected can be reset,
+ * allowing for other concurrent perf sessions to choose a different sink.
+ *
+ * When operated from sysFS users have full control and as such the deactivate
+ * parameter should be set to 'false', hence mandating users to explicitly
+ * clear the flag.
  */
-struct coresight_device *
-coresight_get_enabled_sink(struct coresight_device *source)
+struct coresight_device *coresight_get_enabled_sink(bool deactivate)
 {
-	if (!source)
-		return NULL;
+	struct device *dev = NULL;
+
+	dev = bus_find_device(&coresight_bustype, NULL, &deactivate,
+			      coresight_enabled_sink);
 
-	return coresight_find_enabled_sink(source);
+	return dev ? to_coresight_device(dev) : NULL;
 }
 
 static int coresight_sink_by_id(struct device *dev, const void *data)
@@ -760,7 +764,11 @@ int coresight_enable(struct coresight_device *csdev)
 		goto out;
 	}
 
-	sink = coresight_get_enabled_sink(csdev);
+	/*
+	 * Search for a valid sink for this session but don't reset the
+	 * "enable_sink" flag in sysFS.  Users get to do that explicitly.
+	 */
+	sink = coresight_get_enabled_sink(false);
 	if (!sink) {
 		ret = -EINVAL;
 		goto out;
-- 
2.27.0



