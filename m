Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896633BC84C
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 11:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhGFJKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 05:10:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:15431 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhGFJKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 05:10:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="230810065"
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="230810065"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 02:07:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="496531338"
Received: from nntpdsd52-165.inn.intel.com ([10.125.52.165])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jul 2021 02:07:24 -0700
From:   alexander.antonov@linux.intel.com
To:     peterz@infradead.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     kan.liang@linux.intel.com, ak@linux.intel.com,
        stable@vger.kernel.org, alexander.antonov@linux.intel.com,
        alexey.v.bayduraev@linux.intel.com
Subject: [PATCH] perf/x86/intel/uncore: Fix IIO cleanup mapping procedure for SNR/ICX
Date:   Tue,  6 Jul 2021 12:07:23 +0300
Message-Id: <20210706090723.41850-1-alexander.antonov@linux.intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Antonov <alexander.antonov@linux.intel.com>

Cleanup mapping procedure for IIO PMU is needed to free memory which was
allocated for topology data and for attributes in IIO mapping
attribute_group.
Current implementation of this procedure for Snowridge and Icelake Server
platforms doesn't free allocated memory that can be a reason for memory
leak issue.
Fix the issue with IIO cleanup mapping procedure for these platforms
to release allocated memory.

Fixes: 10337e95e04c ("perf/x86/intel/uncore: Enable I/O stacks to IIO PMON mapping on ICX")

Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
---
 arch/x86/events/intel/uncore_snbep.c | 40 +++++++++++++++++++---------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index bb6eb1e5569c..54cdbb96e628 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3836,26 +3836,32 @@ pmu_iio_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
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
@@ -4499,6 +4505,11 @@ static int snr_iio_set_mapping(struct intel_uncore_type *type)
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
@@ -4515,7 +4526,7 @@ static struct intel_uncore_type snr_uncore_iio = {
 	.attr_update		= snr_iio_attr_update,
 	.get_topology		= snr_iio_get_topology,
 	.set_mapping		= snr_iio_set_mapping,
-	.cleanup_mapping	= skx_iio_cleanup_mapping,
+	.cleanup_mapping	= snr_iio_cleanup_mapping,
 };
 
 static struct intel_uncore_type snr_uncore_irp = {
@@ -5090,6 +5101,11 @@ static int icx_iio_set_mapping(struct intel_uncore_type *type)
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
@@ -5107,7 +5123,7 @@ static struct intel_uncore_type icx_uncore_iio = {
 	.attr_update		= icx_iio_attr_update,
 	.get_topology		= icx_iio_get_topology,
 	.set_mapping		= icx_iio_set_mapping,
-	.cleanup_mapping	= skx_iio_cleanup_mapping,
+	.cleanup_mapping	= icx_iio_cleanup_mapping,
 };
 
 static struct intel_uncore_type icx_uncore_irp = {

base-commit: 3dbdb38e286903ec220aaf1fb29a8d94297da246
-- 
2.21.3

