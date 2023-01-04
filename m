Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B1A65D850
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239846AbjADQNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239850AbjADQMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:12:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4551F5FE5
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:12:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D71AD617A0
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A98C433D2;
        Wed,  4 Jan 2023 16:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848769;
        bh=EIZqDPd9fNOCBCswgpx07PnRiZiEE9xZ/S9dqsC6PNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YzO0TrIhgisrhneXYyr2RBeh7k1gg25NE2aA/UmKVSfDzK8yoLM7KHvrnYpyBC5Xs
         txnVi2FN5yiq7AeEaI6dQHavA5k3KXLeGcoaVYVqEVSNRvR3yzHKAs5ZWbfZfsXoOM
         0oWt4F3qLeTM2t1+SEOmWJ0hKfejjrIf2sZu6j3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 6.0 011/177] perf/x86/intel/uncore: Disable I/O stacks to PMU mapping on ICX-D
Date:   Wed,  4 Jan 2023 17:05:02 +0100
Message-Id: <20230104160507.999477946@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

commit efe062705d149b20a15498cb999a9edbb8241e6f upstream.

Current implementation of I/O stacks to PMU mapping doesn't support ICX-D.
Detect ICX-D system to disable mapping.

Fixes: 10337e95e04c ("perf/x86/intel/uncore: Enable I/O stacks to IIO PMON mapping on ICX")
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221117122833.3103580-5-alexander.antonov@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore.h       |    1 +
 arch/x86/events/intel/uncore_snbep.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -2,6 +2,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <asm/apicdef.h>
+#include <asm/intel-family.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 
 #include <linux/perf_event.h>
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5144,6 +5144,11 @@ static int icx_iio_get_topology(struct i
 
 static int icx_iio_set_mapping(struct intel_uncore_type *type)
 {
+	/* Detect ICX-D system. This case is not supported */
+	if (boot_cpu_data.x86_model == INTEL_FAM6_ICELAKE_D) {
+		pmu_clear_mapping_attr(type->attr_update, &icx_iio_mapping_group);
+		return -EPERM;
+	}
 	return pmu_iio_set_mapping(type, &icx_iio_mapping_group);
 }
 


