Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF68754118E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356686AbiFGTiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356081AbiFGTiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:38:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDE536B41;
        Tue,  7 Jun 2022 11:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52823B8233E;
        Tue,  7 Jun 2022 18:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9C0C385A2;
        Tue,  7 Jun 2022 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625623;
        bh=RBHz7ZF803gdhje7BfbRLZ/t4QWWO44yiiVcusiMfKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TL0l+30vNG0w0chT0Xfi0uoblNd/koIzJp2icW0++y6LGfhak6rm/4d6rVkBZ+Sqo
         o9Uxqx5YgtcZkerv3i5LP3rqcAqnSu7HwU8M+v1W1tFJI4KbOLrKjBiQgKpvWZjgtp
         DorllSATjIXZddZvHsDpj4ixEeZBBojMbiOE1Ag4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 077/772] tools/power turbostat: fix ICX DRAM power numbers
Date:   Tue,  7 Jun 2022 18:54:29 +0200
Message-Id: <20220607164951.309194275@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 47d3ba895d6d..4f176bbf29f4 100644
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



