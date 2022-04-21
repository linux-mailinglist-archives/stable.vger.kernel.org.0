Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E6450A0F2
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 15:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245153AbiDUNj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 09:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386507AbiDUNj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 09:39:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7A436E38;
        Thu, 21 Apr 2022 06:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650548198; x=1682084198;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/B25oKD+PgAmoCfxJa+Caby+0Cg4cB73dUY3O11qt8I=;
  b=QOmm9e7GbX4++1H7CYh6sANr0LdQGVtBJYjMpzvTzPCJTcxokLLa2QKW
   Pc4WPIdZDBIye9qZmTpDH1fv0tsvb+F+NJQNDUWOsPNadLU+hs/A+kopI
   ecAzDd+yT1z1GuyEwUqBaoLAkMtKeDK9QhkeviYyDrTAoZmdqpXMIesY4
   oc7HyGvj+4e9q3hCgZarjDl7XxmyOENJwkWG947gQPhvN3fnUP3BW2xIq
   vREvoVIWrzx5Zzjtv6m5U+4xKXuoIqEg6808MGEOZnIqpGyab1kFGeqqj
   J9Zg0h3BfMpR22G7iqTb4XVGBRON4rj6Bpf4H6jQpq1RjdyCQa5hBMhI5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264119166"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="264119166"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 06:36:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="562575947"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.51])
  by fmsmga007.fm.intel.com with SMTP; 21 Apr 2022 06:36:35 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 21 Apr 2022 16:36:34 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     linux-acpi@vger.kernel.org
Cc:     Len Brown <lenb@kernel.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org,
        Woody Suwalski <wsuwalski@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Richard Gong <richard.gong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v2 1/2] ACPI: processor: Do not use C3 w/o ARB_DIS=1
Date:   Thu, 21 Apr 2022 16:36:34 +0300
Message-Id: <20220421133634.19489-1-ville.syrjala@linux.intel.com>
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
v2: Paint it in a different color (Rafael)

 drivers/acpi/processor_idle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 4556c86c3465..5f296e099bce 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -795,7 +795,8 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 		if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
 		    cx->type == ACPI_STATE_C3) {
 			state->enter_dead = acpi_idle_play_dead;
-			drv->safe_state_index = count;
+			if (cx->type != ACPI_STATE_C3)
+				drv->safe_state_index = count;
 		}
 		/*
 		 * Halt-induced C1 is not good for ->enter_s2idle, because it
-- 
2.35.1

