Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBB054050B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243185AbiFGRVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345902AbiFGRT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:19:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B831F1059C4;
        Tue,  7 Jun 2022 10:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD0DFCE21A9;
        Tue,  7 Jun 2022 17:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7B3C385A5;
        Tue,  7 Jun 2022 17:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622386;
        bh=u+z48SM47mESXsWhumFb6ZKzLhZAopSDcM0JtCRIbDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANtrrgbCY692d/Chl8OLf3HBFjqbn1/zwBhM8A5Ht3vqs5KqyM8Rt3Gz4kikBYrVW
         Ju5foO8TM3zMRRQYHuwyzYsfD4c/JdSTpw+OO7MuXm2WWQm96fNPcj0celuoBpdRqV
         tTFWDt+mapy8S94xdtvbRXlOW2TGskqed2W0MA+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/452] tools/power turbostat: fix ICX DRAM power numbers
Date:   Tue,  7 Jun 2022 18:58:18 +0200
Message-Id: <20220607164909.772517875@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 424ed19a9d54..ef65f7eed1ec 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4189,6 +4189,7 @@ rapl_dram_energy_units_probe(int  model, double rapl_energy_units)
 	case INTEL_FAM6_HASWELL_X:	/* HSX */
 	case INTEL_FAM6_BROADWELL_X:	/* BDX */
 	case INTEL_FAM6_XEON_PHI_KNL:	/* KNL */
+	case INTEL_FAM6_ICELAKE_X:	/* ICX */
 		return (rapl_dram_energy_units = 15.3 / 1000000);
 	default:
 		return (rapl_energy_units);
-- 
2.35.1



