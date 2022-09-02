Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C4D5AB3B9
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiIBOeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiIBOcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:32:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961671FCD3;
        Fri,  2 Sep 2022 06:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB20B82A77;
        Fri,  2 Sep 2022 12:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E515C433C1;
        Fri,  2 Sep 2022 12:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122236;
        bh=bCF/wtT9qhY2o2fiAbXiqrUVuVfn3Hpp0lo+dq3HfM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaOLC5WBG5/zwZnMsP3XmwoE+3LAI9xg1437s5C/7Cz3uW3MJuAUd1gD3Y1Qu85mi
         P07fg1O7ZCyO+cOq7EfyRk00yG2I+6SA63Sk3xLlmpYmcH+GrGZ/Hlym070EzwQvF0
         +qXmf9plJjovKGSR0TKl7jTcm5Nph5WM/EkFpWLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 54/72] drm/amd/pm: add missing ->fini_xxxx interfaces for some SMU13 asics
Date:   Fri,  2 Sep 2022 14:19:30 +0200
Message-Id: <20220902121406.540255185@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 4bac1c846eff8042dd59ddecd0a43f3b9de5fd23 ]

Without these, potential memory leak may be induced.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 2 ++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 7432b3e76d3d7..201546c369945 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1583,7 +1583,9 @@ static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.dump_pptable = smu_v13_0_0_dump_pptable,
 	.init_microcode = smu_v13_0_init_microcode,
 	.load_microcode = smu_v13_0_load_microcode,
+	.fini_microcode = smu_v13_0_fini_microcode,
 	.init_smc_tables = smu_v13_0_0_init_smc_tables,
+	.fini_smc_tables = smu_v13_0_fini_smc_tables,
 	.init_power = smu_v13_0_init_power,
 	.fini_power = smu_v13_0_fini_power,
 	.check_fw_status = smu_v13_0_check_fw_status,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 4e1861fb2c6a4..9cde13b07dd26 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1539,7 +1539,9 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.dump_pptable = smu_v13_0_7_dump_pptable,
 	.init_microcode = smu_v13_0_init_microcode,
 	.load_microcode = smu_v13_0_load_microcode,
+	.fini_microcode = smu_v13_0_fini_microcode,
 	.init_smc_tables = smu_v13_0_7_init_smc_tables,
+	.fini_smc_tables = smu_v13_0_fini_smc_tables,
 	.init_power = smu_v13_0_init_power,
 	.check_fw_status = smu_v13_0_7_check_fw_status,
 	.setup_pptable = smu_v13_0_7_setup_pptable,
-- 
2.35.1



