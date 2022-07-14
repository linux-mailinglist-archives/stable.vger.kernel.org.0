Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AA8574489
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 07:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbiGNFcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 01:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbiGNFcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 01:32:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC2C20BEF;
        Wed, 13 Jul 2022 22:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657776771; x=1689312771;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=g3JhouRCSU7SAPZqa1QXPR7km+MMP1OzGRbcWLjGIBc=;
  b=dm+rkUwdHg6rTyd0I88Bo2IPQD8Cee74n1wssixFf0D2t65ULZHien0j
   zZFqBgm9P5eYoNhJ2Gl6vk0BZo5VIQ3MLDTCD8hEseXjCOWch8Cw4A4Hv
   QerlxhbgG9QRcmXZoOJA2uS+9BtWgTGz0DcziJRQKcuC31fJI4dOIoe3d
   N1ItER9joqNW8lRDKxrMXIiADx4olGj8jcHS1ITP8URs2H4yb1Yo4DvkH
   ItmApJXhsx5qihu69TRJb/MeRMUE3AaBbKgQbDkDSt1CV+bD2zDBlEpll
   G/fl/BWIJZ4Ue3nttxdvXNyMIu5bEDIMZ25vSBLlf7KF/wdzB+1TT+Uq+
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="265208550"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="265208550"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 22:32:38 -0700
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="653719713"
Received: from pfische1-mobl1.amr.corp.intel.com (HELO desk) ([10.251.18.51])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 22:32:38 -0700
Date:   Wed, 13 Jul 2022 22:32:37 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH] x86/bugs: Switch to "auto" when "ibrs" selected on Enhanced
 IBRS parts
Message-ID: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently spectre_v2=ibrs forces write to MSR_IA32_SPEC_CTRL at every
entry and exit. On Enhanced IBRS parts setting MSR_IA32_SPEC_CTRL[IBRS]
only once at bootup is sufficient. MSR write at every kernel entry/exit
incur unnecessary penalty that can be avoided.

When Enhanced IBRS feature is present, switch from "ibrs" to "auto" mode
so that appropriate mitigation is selected.

Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/kernel/cpu/bugs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0dd04713434b..7d7ebfdfbeda 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1303,6 +1303,12 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
+	if (cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
+		pr_err("%s selected but CPU supports Enhanced IBRS. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
 	spec_v2_print_cond(mitigation_options[i].option,
 			   mitigation_options[i].secure);
 	return cmd;

base-commit: 72a8e05d4f66b5af7854df4490e3135168694b6b
-- 
2.35.3


