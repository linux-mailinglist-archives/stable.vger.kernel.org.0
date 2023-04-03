Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CB36D4A94
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbjDCOsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbjDCOsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:48:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB0B2A5BA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AA6EB81D52
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB44CC433EF;
        Mon,  3 Apr 2023 14:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533208;
        bh=Einpn2ALN2xXNuQcDxCgB93uEJyh1ApAX7KK/N9oS+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlE2edNg8+DpXa/ztgmiGczBxXb2Desd/PyXZuwKdKfxR/ARfrE1AWZyib0C26BYE
         T/DSbmsfOOLgGzWQrxPUSRafsrBSUjXOFwPm5afrmXIvx1HQ3jvRK3AIhp2jad/zXV
         CvAJFITOMukvMcB8EWVE/D7jJL1efelN79rQQ2kQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rajvi Jingar <rajvi.jingar@linux.intel.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 096/187] platform/x86/intel/pmc: Alder Lake PCH slp_s0_residency fix
Date:   Mon,  3 Apr 2023 16:09:01 +0200
Message-Id: <20230403140419.139213118@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajvi Jingar <rajvi.jingar@linux.intel.com>

[ Upstream commit fb5755100a0a5aa5957bdb204fd1e249684557fc ]

For platforms with Alder Lake PCH (Alder Lake S and Raptor Lake S) the
slp_s0_residency attribute has been reporting the wrong value. Unlike other
platforms, ADL PCH does not have a counter for the time that the SLP_S0
signal was asserted. Instead, firmware uses the aggregate of the Low Power
Mode (LPM) substate counters as the S0ix value.  Since the LPM counters run
at a different frequency, this lead to misreporting of the S0ix time.

Add a check for Alder Lake PCH and adjust the frequency accordingly when
display slp_s0_residency.

Fixes: bbab31101f44 ("platform/x86/intel: pmc/core: Add Alderlake support to pmc core driver")
Signed-off-by: Rajvi Jingar <rajvi.jingar@linux.intel.com>
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20230320212029.3154407-1-david.e.box@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index 3a15d32d7644c..b9591969e0fa1 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -66,7 +66,18 @@ static inline void pmc_core_reg_write(struct pmc_dev *pmcdev, int reg_offset,
 
 static inline u64 pmc_core_adjust_slp_s0_step(struct pmc_dev *pmcdev, u32 value)
 {
-	return (u64)value * pmcdev->map->slp_s0_res_counter_step;
+	/*
+	 * ADL PCH does not have the SLP_S0 counter and LPM Residency counters are
+	 * used as a workaround which uses 30.5 usec tick. All other client
+	 * programs have the legacy SLP_S0 residency counter that is using the 122
+	 * usec tick.
+	 */
+	const int lpm_adj_x2 = pmcdev->map->lpm_res_counter_step_x2;
+
+	if (pmcdev->map == &adl_reg_map)
+		return (u64)value * GET_X2_COUNTER((u64)lpm_adj_x2);
+	else
+		return (u64)value * pmcdev->map->slp_s0_res_counter_step;
 }
 
 static int set_etr3(struct pmc_dev *pmcdev)
-- 
2.39.2



