Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B8F3D77A5
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbhG0N7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236672AbhG0N65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 09:58:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31135C061764;
        Tue, 27 Jul 2021 06:58:57 -0700 (PDT)
Date:   Tue, 27 Jul 2021 13:58:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1627394335;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2nR+5jMfkCJTHfxk2uZxnrbhPjucYhJrPlcEnost6Y=;
        b=WqGd4+t0om6tc9QtCtcwmZwwCmxvRdqeGFti+Z/9AOVMyE5J0z6JqRLEq2en2zHE7x6vOp
        AQUb6HY1GBBgeRnCh7u7zFKt8IE68oyQXoA/lr4kf1/rVwzepKVOMPD6VPs6LIFgtJSV3e
        NNcIY02Z0l7RMnV07GfrMKFMdYGcb74V5j7KW3w4axQhA23tcK2X4jKL/1j8hoiD/okj6F
        DwnC7awRJ+LvCebN1rP9iDGziR63txIg2wYR3v3Pi1WzXkD3ZBTS5X7teY8DaBa47Qlyge
        T5/2TiWSp9n0JkSKA4upPSntHBs7a3jkKwHEMJIfZh1Iy73/hg/iZx6obFP7OQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1627394335;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2nR+5jMfkCJTHfxk2uZxnrbhPjucYhJrPlcEnost6Y=;
        b=RHWKnyvOhMJYFNl6YGztLDEQ/g5gEfwqVJWVTfyWS2gyGCjULaou3+ASBJVUHB+nGk2kAL
        PeNgPvGYvbjozDDg==
From:   "tip-bot2 for Alexander Antonov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel/uncore: Fix IIO cleanup mapping
 procedure for SNR/ICX
Cc:     Alexander Antonov <alexander.antonov@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210706090723.41850-1-alexander.antonov@linux.intel.com>
References: <20210706090723.41850-1-alexander.antonov@linux.intel.com>
MIME-Version: 1.0
Message-ID: <162739433514.395.10272219341326813838.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     3f2cbe3810a60111a33f5f6267bd5a237b826fc9
Gitweb:        https://git.kernel.org/tip/3f2cbe3810a60111a33f5f6267bd5a237b826fc9
Author:        Alexander Antonov <alexander.antonov@linux.intel.com>
AuthorDate:    Tue, 06 Jul 2021 12:07:23 +03:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Fri, 16 Jul 2021 18:46:48 +02:00

perf/x86/intel/uncore: Fix IIO cleanup mapping procedure for SNR/ICX

skx_iio_cleanup_mapping() is re-used for snr and icx, but in those
cases it fails to use the appropriate XXX_iio_mapping_group and as
such fails to free previously allocated resources, leading to memory
leaks.

Fixes: 10337e95e04c ("perf/x86/intel/uncore: Enable I/O stacks to IIO PMON mapping on ICX")
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
[peterz: Changelog]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210706090723.41850-1-alexander.antonov@linux.intel.com
---
 arch/x86/events/intel/uncore_snbep.c | 40 ++++++++++++++++++---------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 2558e26..f665b16 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3847,26 +3847,32 @@ clear_attr_update:
 	return ret;
 }
 
-static int skx_iio_set_mapping(struct intel_uncore_type *type)
-{
-	return pmu_iio_set_mapping(type, &skx_iio_mapping_group);
-}
-
-static void skx_iio_cleanup_mapping(struct intel_uncore_type *type)
+static void
+pmu_iio_cleanup_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
 {
-	struct attribute **attr = skx_iio_mapping_group.attrs;
+	struct attribute **attr = ag->attrs;
 
 	if (!attr)
 		return;
 
 	for (; *attr; attr++)
 		kfree((*attr)->name);
-	kfree(attr_to_ext_attr(*skx_iio_mapping_group.attrs));
-	kfree(skx_iio_mapping_group.attrs);
-	skx_iio_mapping_group.attrs = NULL;
+	kfree(attr_to_ext_attr(*ag->attrs));
+	kfree(ag->attrs);
+	ag->attrs = NULL;
 	kfree(type->topology);
 }
 
+static int skx_iio_set_mapping(struct intel_uncore_type *type)
+{
+	return pmu_iio_set_mapping(type, &skx_iio_mapping_group);
+}
+
+static void skx_iio_cleanup_mapping(struct intel_uncore_type *type)
+{
+	pmu_iio_cleanup_mapping(type, &skx_iio_mapping_group);
+}
+
 static struct intel_uncore_type skx_uncore_iio = {
 	.name			= "iio",
 	.num_counters		= 4,
@@ -4510,6 +4516,11 @@ static int snr_iio_set_mapping(struct intel_uncore_type *type)
 	return pmu_iio_set_mapping(type, &snr_iio_mapping_group);
 }
 
+static void snr_iio_cleanup_mapping(struct intel_uncore_type *type)
+{
+	pmu_iio_cleanup_mapping(type, &snr_iio_mapping_group);
+}
+
 static struct intel_uncore_type snr_uncore_iio = {
 	.name			= "iio",
 	.num_counters		= 4,
@@ -4526,7 +4537,7 @@ static struct intel_uncore_type snr_uncore_iio = {
 	.attr_update		= snr_iio_attr_update,
 	.get_topology		= snr_iio_get_topology,
 	.set_mapping		= snr_iio_set_mapping,
-	.cleanup_mapping	= skx_iio_cleanup_mapping,
+	.cleanup_mapping	= snr_iio_cleanup_mapping,
 };
 
 static struct intel_uncore_type snr_uncore_irp = {
@@ -5113,6 +5124,11 @@ static int icx_iio_set_mapping(struct intel_uncore_type *type)
 	return pmu_iio_set_mapping(type, &icx_iio_mapping_group);
 }
 
+static void icx_iio_cleanup_mapping(struct intel_uncore_type *type)
+{
+	pmu_iio_cleanup_mapping(type, &icx_iio_mapping_group);
+}
+
 static struct intel_uncore_type icx_uncore_iio = {
 	.name			= "iio",
 	.num_counters		= 4,
@@ -5130,7 +5146,7 @@ static struct intel_uncore_type icx_uncore_iio = {
 	.attr_update		= icx_iio_attr_update,
 	.get_topology		= icx_iio_get_topology,
 	.set_mapping		= icx_iio_set_mapping,
-	.cleanup_mapping	= skx_iio_cleanup_mapping,
+	.cleanup_mapping	= icx_iio_cleanup_mapping,
 };
 
 static struct intel_uncore_type icx_uncore_irp = {
