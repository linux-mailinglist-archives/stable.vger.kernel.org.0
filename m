Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25D463786C
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 13:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiKXMDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 07:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiKXMDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 07:03:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F31391DB;
        Thu, 24 Nov 2022 04:03:01 -0800 (PST)
Date:   Thu, 24 Nov 2022 12:02:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669291380;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kUHiE8a+1lv9ytkeBFtI2aUbZ3z2LKhBsO12Nwyan9Q=;
        b=r3NfTtOqmCXc4Y7bkMQpx1kmVoPkrKkokfBjw3TlL3WuTrD3GsUC/jjHevU0Xyg92s9Bvz
        JAfQWHiZI10gAwN85rqJYxE4nMTiQJSgt7Q7EGhovHt7H1P2M3kH3TUJKiaFxtJii8U8fp
        CgHAxMocDTR9mShrN3VKAK55+Xtti3LQ64bIJwJLDwI6UXmgDtWy3mE5tG/hkd/HYS/vv2
        yNWFMwc09tWFSTkK3MGMfvvTB2QeaSvA7CmCbMp+3tViAC771FiYeoAtIBkKZA6Cg5n4Bc
        2UQ2Fpq4WeBq+cHwNFPfBgxhzyNmqLWl1yA7/YLzrDLV/c2HOSIIVVTu2l/q4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669291380;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kUHiE8a+1lv9ytkeBFtI2aUbZ3z2LKhBsO12Nwyan9Q=;
        b=I5d7HIU/BshIv/S0ThgDs2ffH1DA83Plz2harpRmDTuIy6wGTO95dAI2moxj7QDsXhZlHi
        fGhS/lvaRAEOtNCg==
From:   "tip-bot2 for Alexander Antonov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel/uncore: Clear attr_update properly
Cc:     Alexander Antonov <alexander.antonov@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20221117122833.3103580-4-alexander.antonov@linux.intel.com>
References: <20221117122833.3103580-4-alexander.antonov@linux.intel.com>
MIME-Version: 1.0
Message-ID: <166929137917.4906.3753361587804959232.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     6532783310e2b2f50dc13f46c49aa6546cb6e7a3
Gitweb:        https://git.kernel.org/tip/6532783310e2b2f50dc13f46c49aa6546cb6e7a3
Author:        Alexander Antonov <alexander.antonov@linux.intel.com>
AuthorDate:    Thu, 17 Nov 2022 12:28:25 
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 24 Nov 2022 11:09:20 +01:00

perf/x86/intel/uncore: Clear attr_update properly

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
---
 arch/x86/events/intel/uncore_snbep.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index d3323f1..0d06b56 100644
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
@@ -3926,7 +3941,7 @@ clear_attrs:
 clear_topology:
 	pmu_free_topology(type);
 clear_attr_update:
-	type->attr_update = NULL;
+	pmu_clear_mapping_attr(type->attr_update, ag);
 	return ret;
 }
 
