Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2BF537C4A
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbiE3N2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbiE3N12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:27:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C2184A20;
        Mon, 30 May 2022 06:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71180B80DAA;
        Mon, 30 May 2022 13:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6E3C36AE3;
        Mon, 30 May 2022 13:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917141;
        bh=mFZmCmXfkFOAG5ewdktFRxWxnqMPBYAH8t2tEQhXe+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKR7S3lI6hY7HvBWueWUYTf1knso/0m35jcJbLLIeRygM3crF8OICfd39Jgj+O18T
         hoXzpb2BwYikOxnZcY01CzU0n9BehelPDrz+6lcpKRIntJPrIcpUEHp3VykWIPN6HE
         ba6A6vMHf4ND65RTs4jOxVDsRIGV11HG7tnZEirtr+PqS+uAKzlOkxXOaLny7wBeSv
         +yWDlYqqz8tMtL8Ar1raAyKl21R5Z9QkPgEme6MPcpICaUCFLQBPqmFEMzRh92+rBS
         cYzKWes9r8JdUorexJJ4XU2OPeUodghb6cVvJ5BWpnNalASg647+l4VQRr+qF09tiV
         pQwDhrbrRSDRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, lenb@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 032/159] tools/power turbostat: fix ICX DRAM power numbers
Date:   Mon, 30 May 2022 09:22:17 -0400
Message-Id: <20220530132425.1929512-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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
index bc5ae0872fed..babede4486de 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4376,6 +4376,7 @@ static double rapl_dram_energy_units_probe(int model, double rapl_energy_units)
 	case INTEL_FAM6_BROADWELL_X:	/* BDX */
 	case INTEL_FAM6_SKYLAKE_X:	/* SKX */
 	case INTEL_FAM6_XEON_PHI_KNL:	/* KNL */
+	case INTEL_FAM6_ICELAKE_X:	/* ICX */
 		return (rapl_dram_energy_units = 15.3 / 1000000);
 	default:
 		return (rapl_energy_units);
-- 
2.35.1

