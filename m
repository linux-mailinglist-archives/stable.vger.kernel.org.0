Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21EB603EC0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiJSJUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiJSJTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:19:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED807DCE8D;
        Wed, 19 Oct 2022 02:08:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 720F161825;
        Wed, 19 Oct 2022 09:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A413C433D7;
        Wed, 19 Oct 2022 09:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170443;
        bh=BdUT6MVBWP9eWHoam61ekkpWBMFDaB0rW36JYnis4qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvZXu4Pimo1U3TIJO77OdgYVS9AFruhx/3Yr1lxxGyKwZCUg5Jforx2XqdU0IwlMo
         fQBIh8uiFEPXvcs8wZ4SEQtj/nxDXutR8/1ZTXGJNk9YZlQerVAArgx2GKnHe+vze3
         PFIbN6IA+Q3H/xbcKYqx7vs0NOYsInobvtvyGETQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Wang Wendy <wendy.wang@intel.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 657/862] tools/power turbostat: Use standard Energy Unit for SPR Dram RAPL domain
Date:   Wed, 19 Oct 2022 10:32:24 +0200
Message-Id: <20221019083318.988379410@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit b2d433ae637626d44c9d4a75dd3330cf68fed9de ]

Intel Xeon servers used to use a fixed energy resolution (15.3uj) for
Dram RAPL domain. But on SPR, Dram RAPL domain follows the standard
energy resolution as described in MSR_RAPL_POWER_UNIT.

Remove the SPR rapl_dram_energy_units quirk.

Fixes: e7af1ed3fa47 ("tools/power turbostat: Support additional CPU model numbers")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Wang Wendy <wendy.wang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 831dc32d45fa..b7d2a0cd0ac2 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4560,7 +4560,6 @@ static double rapl_dram_energy_units_probe(int model, double rapl_energy_units)
 	case INTEL_FAM6_SKYLAKE_X:	/* SKX */
 	case INTEL_FAM6_XEON_PHI_KNL:	/* KNL */
 	case INTEL_FAM6_ICELAKE_X:	/* ICX */
-	case INTEL_FAM6_SAPPHIRERAPIDS_X:	/* SPR */
 		return (rapl_dram_energy_units = 15.3 / 1000000);
 	default:
 		return (rapl_energy_units);
-- 
2.35.1



