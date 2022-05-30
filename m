Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC66538228
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237693AbiE3OWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241484AbiE3ORh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2E653A41;
        Mon, 30 May 2022 06:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAD0560FDA;
        Mon, 30 May 2022 13:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A891C3411C;
        Mon, 30 May 2022 13:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918452;
        bh=X0JSBJCMl164uPRpCFAKDoP0BwSaR6OSa+/yCCXETJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcx0teN8odUVYtDV1l0h5MQUPom/dGLsjgNlQZQAOafDoRAsXQSu6OauRlce7Mrek
         bW7h2eMJP63FDXcXtlYSbjv2aIontMKT87g4wAE4IkjgghcXycL0BaHIcW+L90Ou8x
         dAEw0Tf/VX3mU1+VRvJCx6Slp4d5bnKg1LVvyeqgA/i2Pckg1L6F8u5F0wpx66rswb
         +zoQTXYqfJqCUdoQ5h8wSy6n5n1XKCSVm2QDirQf9fKiij3C72vWjoF64aNIUB2sf+
         qXLfHQjfkA5RgyM+QLV5gQ/DfFDGkgrBvTgE48lKUN8Y5x1dVqlIPZ3Ap+TMrcsfkO
         wpo1QaCXU4+KQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, lenb@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/55] tools/power turbostat: fix ICX DRAM power numbers
Date:   Mon, 30 May 2022 09:46:18 -0400
Message-Id: <20220530134701.1935933-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Len Brown <len.brown@intel.com>

[ Upstream commit 6397b6418935773a34b533b3348b03f4ce3d7050 ]

ICX (and its duplicates) require special hard-coded DRAM RAPL units,
rather than using the generic RAPL energy units.

Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 988326b67a91..8bf6b01b3560 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -3865,6 +3865,7 @@ rapl_dram_energy_units_probe(int  model, double rapl_energy_units)
 	case INTEL_FAM6_HASWELL_X:	/* HSX */
 	case INTEL_FAM6_BROADWELL_X:	/* BDX */
 	case INTEL_FAM6_XEON_PHI_KNL:	/* KNL */
+	case INTEL_FAM6_ICELAKE_X:	/* ICX */
 		return (rapl_dram_energy_units = 15.3 / 1000000);
 	default:
 		return (rapl_energy_units);
-- 
2.35.1

