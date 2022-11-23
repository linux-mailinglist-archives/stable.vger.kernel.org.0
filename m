Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E70635793
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238128AbiKWJnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbiKWJmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:42:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAFEF2B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:40:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05BE1B81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3C7C433C1;
        Wed, 23 Nov 2022 09:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196426;
        bh=XArU3TO7AQ2vdLMZAPZu9OOgf+sON8XbgI7gyApuQII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcvlO10kgdQY3pSlGCXJrpIvt+nwCmMTZ38kpjC10F9K7DLxTwFNJw5jOyQpqRpqn
         bAIfXvYOVAv4eRR9RBkL3yF7lcfl7DFERV2LU05awHoqmQMQ6f3RWdtEgzv/aXr7H3
         Z/8N+X8huFJPkLa+rFy4TwRhN0y9vNnRMnVtZRWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Box <david.e.box@intel.com>,
        Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        Gayatri Kammela <gayatri.kammela@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 027/314] platform/x86/intel: pmc/core: Add Raptor Lake support to pmc core driver
Date:   Wed, 23 Nov 2022 09:47:52 +0100
Message-Id: <20221123084626.735234962@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gayatri Kammela <gayatri.kammela@linux.intel.com>

[ Upstream commit 555a68dd681b7437a2708001d465c85f6dfa6955 ]

Add Raptor Lake client parts (both RPL and RPL_S) support to pmc core
driver. Raptor Lake client parts reuse all the Alder Lake PCH IPs.

Cc: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Box <david.e.box@intel.com>
Acked-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@linux.intel.com>
Link: https://lore.kernel.org/r/20220912233307.409954-2-gayatri.kammela@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index a1fe1e0dcf4a..17ec5825d13d 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -1914,6 +1914,8 @@ static const struct x86_cpu_id intel_pmc_core_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N,		&tgl_reg_map),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&adl_reg_map),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,        &tgl_reg_map),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&adl_reg_map),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&adl_reg_map),
 	{}
 };
 
-- 
2.35.1



