Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D9550898F
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 15:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344322AbiDTNrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 09:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378976AbiDTNrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 09:47:12 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052CE433A9;
        Wed, 20 Apr 2022 06:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650462266; x=1681998266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3A9McpqYvzVOVGdOMs077O3UyzxI9ty+KcdEkff5rjc=;
  b=DSJNpqOI8yNkNND6S8IyVJhn9guO6R/zGOBB0wcNPSfp8uoJ4F22aL32
   GgYVRIv2VrtVnsmb4TWMyULNU9eBsqZJtD25fK/+KhW5qylmL9fKKavr6
   ufRnsmfNyYpvv7LpwG0I0D+eril69X8XbTLSD/IMwrkkTQMokhWov9DaK
   i0SVWy9zk/RKyudkoyeCu4Kp/7kccbyY4aNQUukY6fWZi739Lc24WEt9h
   V792q0d1lgmX7NzI1X0vF3B6DpOqcUjZiaYAVsZwVSbGfdC62cX2tgO24
   dRlfBBS6PyWsTN7GR9PffCI0c2TQrhfkdrh/2R+GFexsKPu8RXNb0HV08
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="244610510"
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="244610510"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 06:44:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="593179130"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.51])
  by orsmga001.jf.intel.com with SMTP; 20 Apr 2022 06:44:22 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 20 Apr 2022 16:44:22 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     linux-acpi@vger.kernel.org
Cc:     Len Brown <lenb@kernel.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org,
        Woody Suwalski <wsuwalski@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Richard Gong <richard.gong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 2/2] Revert "ACPI: processor: idle: fix lockup regression on 32-bit ThinkPad T40"
Date:   Wed, 20 Apr 2022 16:44:17 +0300
Message-Id: <20220420134417.24546-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220420134417.24546-1-ville.syrjala@linux.intel.com>
References: <20220420134417.24546-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

This reverts commit bfe55a1f7fd6bfede16078bf04c6250fbca11588.

This was presumably misdiagnosed as an inability to use C3 at
all when I suspect the real problem is just misconfiguration of
C3 vs. ARB_DIS.

Cc: stable@vger.kernel.org
Cc: Woody Suwalski <wsuwalski@gmail.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Richard Gong <richard.gong@amd.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/acpi/processor_idle.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 54f0a1915025..d4632b8adbc5 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -96,11 +96,6 @@ static const struct dmi_system_id processor_power_dmi_table[] = {
 	  DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"L8400B series Notebook PC")},
 	 (void *)1},
-	/* T40 can not handle C3 idle state */
-	{ set_max_cstate, "IBM ThinkPad T40", {
-	  DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-	  DMI_MATCH(DMI_PRODUCT_NAME, "23737CU")},
-	 (void *)2},
 	{},
 };
 
-- 
2.35.1

