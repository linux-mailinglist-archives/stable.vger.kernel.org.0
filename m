Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B1A65D309
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjADMuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjADMuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDCE17412
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DC15B8162F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F893C433D2;
        Wed,  4 Jan 2023 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672836615;
        bh=klSrvD1odZYJ2ffXwmpcBWwa8d+k5f69ldG7ZhLg3Rc=;
        h=Subject:To:Cc:From:Date:From;
        b=RYhtGEl3wMKyGj3YppIyZ1W7Cj09PHVPZgbTUXz/rH+1utAAwK7MwGf4uLi+w6+Q4
         Q2PJbSdi92Twym6PsnqnEiOpCPoaCiLXdIBgji7o9SzTctZzuS8h59Nr3faL8+m2hm
         amb/B8rvqDZW3nXu7xnnwJvk6efKGOxwxWiDxX7E=
Subject: FAILED: patch "[PATCH] perf/x86/intel/uncore: Clear attr_update properly" failed to apply to 5.10-stable tree
To:     alexander.antonov@linux.intel.com, kan.liang@linux.intel.com,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 13:50:12 +0100
Message-ID: <1672836612100229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6532783310e2 ("perf/x86/intel/uncore: Clear attr_update properly")
f471fac77b41 ("perf/x86/intel/uncore: Generalize I/O stacks to PMON mapping procedure")
cface0326a6c ("perf/x86/intel/uncore: Enable IIO stacks to PMON mapping for multi-segment SKX")
ba9506be4e40 ("perf/x86/intel/uncore: Store the logical die id instead of the physical die id.")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6532783310e2b2f50dc13f46c49aa6546cb6e7a3 Mon Sep 17 00:00:00 2001
From: Alexander Antonov <alexander.antonov@linux.intel.com>
Date: Thu, 17 Nov 2022 12:28:25 +0000
Subject: [PATCH] perf/x86/intel/uncore: Clear attr_update properly

Current clear_attr_update procedure in pmu_set_mapping() sets attr_update
field in NULL that is not correct because intel_uncore_type pmu types can
contain several groups in attr_update field. For example, SPR platform
already has uncore_alias_group to update and then UPI topology group will
be added in next patches.

Fix current behavior and clear attr_update group related to mapping only.

Fixes: bb42b3d39781 ("perf/x86/intel/uncore: Expose an Uncore unit to IIO PMON mapping")
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221117122833.3103580-4-alexander.antonov@linux.intel.com

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index d3323f13c304..0d06b56b8a33 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3872,6 +3872,21 @@ static const struct attribute_group *skx_iio_attr_update[] = {
 	NULL,
 };
 
+static void pmu_clear_mapping_attr(const struct attribute_group **groups,
+				   struct attribute_group *ag)
+{
+	int i;
+
+	for (i = 0; groups[i]; i++) {
+		if (groups[i] == ag) {
+			for (i++; groups[i]; i++)
+				groups[i - 1] = groups[i];
+			groups[i - 1] = NULL;
+			break;
+		}
+	}
+}
+
 static int
 pmu_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag,
 		ssize_t (*show)(struct device*, struct device_attribute*, char*),
@@ -3926,7 +3941,7 @@ pmu_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag,
 clear_topology:
 	pmu_free_topology(type);
 clear_attr_update:
-	type->attr_update = NULL;
+	pmu_clear_mapping_attr(type->attr_update, ag);
 	return ret;
 }
 

