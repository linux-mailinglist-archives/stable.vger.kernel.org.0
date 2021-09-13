Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CA5409643
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348521AbhIMOul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346882AbhIMOrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:47:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0AD76322C;
        Mon, 13 Sep 2021 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541535;
        bh=zOjkwOZeZF/s9alCxj/ziN4jU7UQaPp70IN1jqRvrrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJT/uFCT6Igi31r/y6tNw0NlXXvrJ/29N+ymzvjTw9bjgPKgg/yXydIu0TmQj1W7I
         B+eU60AaVOy2kBOu7l9FDjtYfsFGL0HjH+jc4QewFe9LNbP5/NsEX6VOKrvdAnSSzd
         ivekK0Wn0VmBFI5zpPvq1yLgXFvuT7TNRn5mY4Bw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 5.14 309/334] perf/x86/intel/uncore: Fix IIO cleanup mapping procedure for SNR/ICX
Date:   Mon, 13 Sep 2021 15:16:03 +0200
Message-Id: <20210913131123.873839850@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Antonov <alexander.antonov@linux.intel.com>

commit 3f2cbe3810a60111a33f5f6267bd5a237b826fc9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |   40 ++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 12 deletions(-)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3838,26 +3838,32 @@ clear_attr_update:
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
@@ -4501,6 +4507,11 @@ static int snr_iio_set_mapping(struct in
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
@@ -4517,7 +4528,7 @@ static struct intel_uncore_type snr_unco
 	.attr_update		= snr_iio_attr_update,
 	.get_topology		= snr_iio_get_topology,
 	.set_mapping		= snr_iio_set_mapping,
-	.cleanup_mapping	= skx_iio_cleanup_mapping,
+	.cleanup_mapping	= snr_iio_cleanup_mapping,
 };
 
 static struct intel_uncore_type snr_uncore_irp = {
@@ -5092,6 +5103,11 @@ static int icx_iio_set_mapping(struct in
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
@@ -5109,7 +5125,7 @@ static struct intel_uncore_type icx_unco
 	.attr_update		= icx_iio_attr_update,
 	.get_topology		= icx_iio_get_topology,
 	.set_mapping		= icx_iio_set_mapping,
-	.cleanup_mapping	= skx_iio_cleanup_mapping,
+	.cleanup_mapping	= icx_iio_cleanup_mapping,
 };
 
 static struct intel_uncore_type icx_uncore_irp = {


