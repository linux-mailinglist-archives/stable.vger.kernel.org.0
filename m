Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0776677B7
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239918AbjALOrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239938AbjALOqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:46:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417885AC54
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:34:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6EC7B81E78
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494D9C433D2;
        Thu, 12 Jan 2023 14:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534088;
        bh=3GrwH53I7jj5jaOGvh11wAcPU4A45l/FLKdPYcPzGlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTKmWd9/XjXtl73GVtR6YvoKBDtHcX4qEz8RTaf0g3XbJOiwQIBttQZ4yavE6IgQS
         5yZez1sa52PIdiBTbOqImPHO83yVmi50jD05L052WgDxI8k6oOUMkNArdB4V80a329
         4kSrWU86FdEZ+ru4gx0wku1ARS6yVUjxIqYxJnsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 691/783] perf/x86/intel/uncore: Generalize I/O stacks to PMON mapping procedure
Date:   Thu, 12 Jan 2023 14:56:47 +0100
Message-Id: <20230112135556.344799288@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Antonov <alexander.antonov@linux.intel.com>

[ Upstream commit f471fac77b41a2573c7b677ef790bf18a0e64195 ]

Currently I/O stacks to IIO PMON mapping is available on Skylake servers
only and need to make code more general to easily enable further platforms.
So, introduce get_topology() callback in struct intel_uncore_type which
allows to move common code to separate function and make mapping procedure
more general.

Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lkml.kernel.org/r/20210426131614.16205-2-alexander.antonov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.h       |  1 +
 arch/x86/events/intel/uncore_snbep.c | 28 +++++++++++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/events/intel/uncore.h b/arch/x86/events/intel/uncore.h
index 9efea154349d..4e2953a9eff0 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -84,6 +84,7 @@ struct intel_uncore_type {
 	/*
 	 * Optional callbacks for managing mapping of Uncore units to PMONs
 	 */
+	int (*get_topology)(struct intel_uncore_type *type);
 	int (*set_mapping)(struct intel_uncore_type *type);
 	void (*cleanup_mapping)(struct intel_uncore_type *type);
 };
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 2fd49cd515f5..03e34a440cdf 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3643,12 +3643,19 @@ static inline u8 skx_iio_stack(struct intel_uncore_pmu *pmu, int die)
 }
 
 static umode_t
-skx_iio_mapping_visible(struct kobject *kobj, struct attribute *attr, int die)
+pmu_iio_mapping_visible(struct kobject *kobj, struct attribute *attr,
+			 int die, int zero_bus_pmu)
 {
 	struct intel_uncore_pmu *pmu = dev_to_uncore_pmu(kobj_to_dev(kobj));
 
-	/* Root bus 0x00 is valid only for die 0 AND pmu_idx = 0. */
-	return (!skx_iio_stack(pmu, die) && pmu->pmu_idx) ? 0 : attr->mode;
+	return (!skx_iio_stack(pmu, die) && pmu->pmu_idx != zero_bus_pmu) ? 0 : attr->mode;
+}
+
+static umode_t
+skx_iio_mapping_visible(struct kobject *kobj, struct attribute *attr, int die)
+{
+	/* Root bus 0x00 is valid only for pmu_idx = 0. */
+	return pmu_iio_mapping_visible(kobj, attr, die, 0);
 }
 
 static ssize_t skx_iio_mapping_show(struct device *dev,
@@ -3740,7 +3747,8 @@ static const struct attribute_group *skx_iio_attr_update[] = {
 	NULL,
 };
 
-static int skx_iio_set_mapping(struct intel_uncore_type *type)
+static int
+pmu_iio_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
 {
 	char buf[64];
 	int ret;
@@ -3748,8 +3756,8 @@ static int skx_iio_set_mapping(struct intel_uncore_type *type)
 	struct attribute **attrs = NULL;
 	struct dev_ext_attribute *eas = NULL;
 
-	ret = skx_iio_get_topology(type);
-	if (ret)
+	ret = type->get_topology(type);
+	if (ret < 0)
 		goto clear_attr_update;
 
 	ret = -ENOMEM;
@@ -3775,7 +3783,7 @@ static int skx_iio_set_mapping(struct intel_uncore_type *type)
 		eas[die].var = (void *)die;
 		attrs[die] = &eas[die].attr.attr;
 	}
-	skx_iio_mapping_group.attrs = attrs;
+	ag->attrs = attrs;
 
 	return 0;
 err:
@@ -3791,6 +3799,11 @@ static int skx_iio_set_mapping(struct intel_uncore_type *type)
 	return ret;
 }
 
+static int skx_iio_set_mapping(struct intel_uncore_type *type)
+{
+	return pmu_iio_set_mapping(type, &skx_iio_mapping_group);
+}
+
 static void skx_iio_cleanup_mapping(struct intel_uncore_type *type)
 {
 	struct attribute **attr = skx_iio_mapping_group.attrs;
@@ -3821,6 +3834,7 @@ static struct intel_uncore_type skx_uncore_iio = {
 	.ops			= &skx_uncore_iio_ops,
 	.format_group		= &skx_uncore_iio_format_group,
 	.attr_update		= skx_iio_attr_update,
+	.get_topology		= skx_iio_get_topology,
 	.set_mapping		= skx_iio_set_mapping,
 	.cleanup_mapping	= skx_iio_cleanup_mapping,
 };
-- 
2.35.1



