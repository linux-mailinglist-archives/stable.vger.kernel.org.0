Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EECF6E64E7
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbjDRMx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbjDRMx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977087A80
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5FA262B02
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034DFC433EF;
        Tue, 18 Apr 2023 12:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822365;
        bh=UcWlxnkfaTaHqhQh+AsaOONkbCEZ+BBA1EBTLwG5NIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vj+fJEtheb0BcFh0SH1bGU6PyIa02pRyktdHkX7Zc1+sAboF6bJEbmII9MyhOvnAh
         xZt243CWj6Wby1/Xxhe4KRycgfdwwuObgZkFlIwMKQfq2zXcjZfVJ9TZKOI/ig86XG
         reZsDRiJCgdVVEtuNd0tE1woMGHCyKZFG+GjbDLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Horatio Zhang <Hongkun.Zhang@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 122/139] drm/amd/pm: correct SMU13.0.7 pstate profiling clock settings
Date:   Tue, 18 Apr 2023 14:23:07 +0200
Message-Id: <20230418120318.409162466@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatio Zhang <Hongkun.Zhang@amd.com>

commit f06b8887e3ef4f50098d3a949aef392c529c831a upstream.

Correct the pstate standard/peak profiling mode clock
settings for SMU13.0.7.

Signed-off-by: Horatio Zhang <Hongkun.Zhang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |   22 ++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1329,9 +1329,17 @@ static int smu_v13_0_7_populate_umd_stat
 				&dpm_context->dpm_tables.fclk_table;
 	struct smu_umd_pstate_table *pstate_table =
 				&smu->pstate_table;
+	struct smu_table_context *table_context = &smu->smu_table;
+	PPTable_t *pptable = table_context->driver_pptable;
+	DriverReportedClocks_t driver_clocks =
+		pptable->SkuTable.DriverReportedClocks;
 
 	pstate_table->gfxclk_pstate.min = gfx_table->min;
-	pstate_table->gfxclk_pstate.peak = gfx_table->max;
+	if (driver_clocks.GameClockAc &&
+		(driver_clocks.GameClockAc < gfx_table->max))
+		pstate_table->gfxclk_pstate.peak = driver_clocks.GameClockAc;
+	else
+		pstate_table->gfxclk_pstate.peak = gfx_table->max;
 
 	pstate_table->uclk_pstate.min = mem_table->min;
 	pstate_table->uclk_pstate.peak = mem_table->max;
@@ -1348,12 +1356,12 @@ static int smu_v13_0_7_populate_umd_stat
 	pstate_table->fclk_pstate.min = fclk_table->min;
 	pstate_table->fclk_pstate.peak = fclk_table->max;
 
-	/*
-	 * For now, just use the mininum clock frequency.
-	 * TODO: update them when the real pstate settings available
-	 */
-	pstate_table->gfxclk_pstate.standard = gfx_table->min;
-	pstate_table->uclk_pstate.standard = mem_table->min;
+	if (driver_clocks.BaseClockAc &&
+		driver_clocks.BaseClockAc < gfx_table->max)
+		pstate_table->gfxclk_pstate.standard = driver_clocks.BaseClockAc;
+	else
+		pstate_table->gfxclk_pstate.standard = gfx_table->max;
+	pstate_table->uclk_pstate.standard = mem_table->max;
 	pstate_table->socclk_pstate.standard = soc_table->min;
 	pstate_table->vclk_pstate.standard = vclk_table->min;
 	pstate_table->dclk_pstate.standard = dclk_table->min;


