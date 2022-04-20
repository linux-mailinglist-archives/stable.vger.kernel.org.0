Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138AC508991
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 15:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379011AbiDTNrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 09:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344322AbiDTNrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 09:47:08 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A243EF13;
        Wed, 20 Apr 2022 06:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650462262; x=1681998262;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qot943n4yvRPLIoDlpzQEY0XOrplScM5A1KZYGJHyNU=;
  b=K+39WCcG3GLvgkFxgjNkYXxFux7XAc6Xg9BK0pvYufaymRsoyqYIsRD8
   OVst0wlLYM+GI1OItU8vNR3Hae3EygeymlYUH/8tnTU+hl1Ea2VFhcfuV
   ydX8CmLqFVJ+ooiCinRz5rJoRmOhEd0dtd+47IurUN17JMKZi0Wt5EB0q
   qcZ7KTgOYo7S/Oprb7y3NlfzpBOAuTVXDwLjOtoYKmaW5cP7y82AivBtn
   +N1hB+cEE439TTwH/s9cJaBkhrhO4+NPvZUdYN6KK6q/BiETxsxF74Khf
   u3P2OEbtpWTza69dSu2yT+gIo3QirLpqHDoQThphSfU4U1IqHidMZ/7qo
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="251333930"
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="251333930"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 06:44:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,275,1643702400"; 
   d="scan'208";a="529754188"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.51])
  by orsmga006.jf.intel.com with SMTP; 20 Apr 2022 06:44:18 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 20 Apr 2022 16:44:17 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     linux-acpi@vger.kernel.org
Cc:     Len Brown <lenb@kernel.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org,
        Woody Suwalski <wsuwalski@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Richard Gong <richard.gong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 1/2] ACPI: processor: Do not use C3 w/o ARB_DIS=1
Date:   Wed, 20 Apr 2022 16:44:16 +0300
Message-Id: <20220420134417.24546-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit d6b88ce2eb9d ("ACPI: processor idle: Allow playing dead in C3 state")
was supposedly just trying to enable C3 when the CPU is offlined,
but it also mistakenly enabled C3 usage without setting ARB_DIS=1
in normal idle scenarios.

This results in a machine that won't boot past the point when it first
enters C3. Restore the correct behaviour (either demote to C1/C2, or
use C3 but also set ARB_DIS=1).

I hit this on a Fujitsu Siemens Lifebook S6010 (P3) machine.

Cc: stable@vger.kernel.org
Cc: Woody Suwalski <wsuwalski@gmail.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Richard Gong <richard.gong@amd.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Fixes: d6b88ce2eb9d ("ACPI: processor idle: Allow playing dead in C3 state")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/acpi/processor_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 4556c86c3465..54f0a1915025 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -793,10 +793,10 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 
 		state->flags = 0;
 		if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
-		    cx->type == ACPI_STATE_C3) {
+		    cx->type == ACPI_STATE_C3)
 			state->enter_dead = acpi_idle_play_dead;
+		if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2)
 			drv->safe_state_index = count;
-		}
 		/*
 		 * Halt-induced C1 is not good for ->enter_s2idle, because it
 		 * re-enables interrupts on exit.  Moreover, C1 is generally not
-- 
2.35.1

